from gym.envs.registration import register
import gym
from mlagents_envs.side_channel.engine_configuration_channel import EngineConfigurationChannel
from mlagents_envs.environment import UnityEnvironment as UE
from gym_unity.envs import UnityToGymWrapper
from mlagents_envs.side_channel.side_channel import SideChannel, IncomingMessage
import uuid
from stable_baselines3.common.monitor import Monitor
import os
from mlagents_envs.side_channel.stats_side_channel import StatsSideChannel, StatsAggregationMethod
from colors import *
import json
from wandb import Config
from typing import Tuple, List, Mapping
from collections import defaultdict

StatList = List[Tuple[float, StatsAggregationMethod]]
EnvironmentStats = Mapping[str, StatList]


rank = 0
env_callback = None


# Opening JSON file
with open('run_config.json') as json_file:
    file_config = json.load(json_file)
    # print("loaded config: " + str(file_config))
    config = Config()
    for k, v in file_config.items():
        config[k] = v

register(
    id='MyUnityGymEnv-v0',
    entry_point='environment_controller:CustomEnv'
)

gym.logger.set_level(40)


# problems with Gym. register has to be at the top of the module because it a vectorized environment creates a new
# environment_controller.py file

# problem 2: the variable of configuration cannot be modified on the run for some reason, it just keeps the first value
# that it was assigned. rank, on the other hand, can be modified with initialize. dont ask me why.

wandb_run_identifier = "rank"


def set_rank(_rank, _wandb_run_identifier=None, _callback=None):
    global rank
    rank = _rank

    global wandb_run_identifier
    if _wandb_run_identifier:
        wandb_run_identifier = _wandb_run_identifier
    else:
        wandb_run_identifier = str(_rank)

    wandb_run_identifier = "[{}]".format(wandb_run_identifier)

    global env_callback
    env_callback = _callback


def test_env_compatibility(env: gym.Env):
    pretty_print_separator()
    pretty_print("test_env_compatibility...")
    print(type(env))
    from stable_baselines3.common.env_checker import check_env
    check_env(env)

    from stable_baselines3.common.env_util import is_wrapped
    is_monitor_wrapped = is_wrapped(env, Monitor)
    print("------------------------------------------------------------------------------")
    print("Is monitor wrapped: ", is_monitor_wrapped)


def make_env():
    pretty_print_separator()
    pretty_print("Initializing env with rank: {}".format(rank))

    env = gym.make(config.env_id)
    base_path = os.path.join(config.run_dir, "monitor")
    env = Monitor(env, base_path)
    # VERY important where this line goes
    return env


def get_wandb_ue_env():
    # engine config
    engine_channel = EngineConfigurationChannel()
    engine_channel.set_configuration_parameters(time_scale=config.time_scale)
    # side channels
    channel = SB3StatsRecorder()
    # environment
    env = UE(config.env_path,
             seed=1,
             worker_id=config.worker_id,
             base_port=5000 + rank,
             no_graphics=config.no_graphics,
             side_channels=[engine_channel, channel])

    return env


# class SChannel(SideChannel):
#     def __init__(self, uid):
#         super().__init__(uuid.UUID(uid))
#
#     def on_message_received(self, msg: IncomingMessage):
#         pass


class SB3StatsRecorder(SideChannel):
    """
    Side channel that receives (string, float) pairs from the environment, so that they can eventually
    be passed to a StatsReporter.
    """

    def __init__(self, queue_name='wandb_queue') -> None:
        # >>> uuid.uuid5(uuid.NAMESPACE_URL, "com.unity.ml-agents/StatsSideChannel")
        # UUID('a1d8f7b7-cec8-50f9-b78b-d3e165a78520')
        super().__init__(uuid.UUID("a1d8f7b7-cec8-50f9-b78b-d3e165a78520"))
        pretty_print("Initializing SB3StatsRecorder", Colors.FAIL)
        self.stats: EnvironmentStats = defaultdict(list)
        self.i = 0

    def on_message_received(self, msg: IncomingMessage) -> None:
        """
        Receive the message from the environment, and save it for later retrieval.

        :param msg:
        :return:
        """
        key = msg.read_string()
        val = msg.read_float32()
        agg_type = StatsAggregationMethod(msg.read_int32())

        self.stats[key].append((val, agg_type))

        # print('\n' + key + ', ' + str(val))
        # print('\n'.join(str(key) + ', ' + str(value[0][0]) for key, value in self.stats.items()))
        # print("----------------------------------------------------------------------------")
        # from settings import log as log_to_wandb, run_finished

        # assign different Drone[id] to each subprocess within this wandb run
        key = key.split("/")
        key[0] = key[0] + wandb_run_identifier
        key = "/".join(key)

        self.i += 1

        # TODO train are not being registered because they are out of scope. This bug is not a priority
        # TODO need to accumulate this data in the channel and send the callback on destruction
        # TODO then push all aggregated to wandb at once. until then, it works like this
        if env_callback is not None and wandb_run_identifier == "[test]":
            if self.i % 100000 == 0:
                pretty_print("Publishing {}.i: {}, exporting to {}"
                             .format(key, self.i, self.queue_name), Colors.FAIL)

            if self.i % (19 * 100) == 0:
                env_callback({key:val})

    def get_and_reset_stats(self) -> EnvironmentStats:
        """
        Returns the current stats, and resets the internal storage of the stats.

        :return:
        """
        s = self.stats
        self.stats = defaultdict(list)
        return s


class CustomEnv(gym.Env):
    def __init__(self):
        super(CustomEnv, self).__init__()

        env = get_wandb_ue_env()
        env = UnityToGymWrapper(env, allow_multiple_obs=True)

        self.env = env
        self.action_space = self.env.action_space
        self.action_size = self.env.action_size
        self.observation_space = gym.spaces.Dict({
            0: gym.spaces.Box(low=0, high=1, shape=(27, 60, 3)),  # =(40, 90, 3)),
            1: gym.spaces.Box(low=0, high=1, shape=(20, 40, 1)),  # (56, 121, 1
            2: gym.spaces.Box(low='-inf', high='inf', shape=(400,))
        })

    @staticmethod
    def tuple_to_dict(s):
        obs = {
            0: s[0],
            1: s[1],
            2: s[2]
        }
        return obs

    def reset(self):
        #         print("LOG: returning reset" + self.tuple_to_dict(self.env.reset()))
        #         print("LOG: returning reset" + (self.env.reset()))
        #          np.array(self._observation)
        return self.tuple_to_dict(self.env.reset())

    def step(self, action):
        s, r, d, info = self.env.step(action)
        return self.tuple_to_dict(s), float(r), d, info

    def close(self):
        self.env.close()
        global rank
        rank -= 1

    def render(self, mode="human"):
        self.env.render()
