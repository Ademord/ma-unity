import gym
import numpy as np
from mlagents_envs.environment import UnityEnvironment
from gym_unity.envs import UnityToGymWrapper
import os


from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import SubprocVecEnv, DummyVecEnv
from stable_baselines3.common.env_util import make_vec_env
from stable_baselines3.common.utils import set_random_seed
from stable_baselines3.common.evaluation import evaluate_policy
from stable_baselines3.common.monitor import Monitor

import matplotlib.pyplot as plt
from stable_baselines3.common import results_plotter
from stable_baselines3.common.results_plotter import load_results, ts2xy, plot_results
import unity_env_wrapper

# from gym import envs
# print(envs.registry.all())
try:
    from mpi4py import MPI
except ImportError:
    MPI = None
    
def make_unity_env(env_directory, num_env, visual, start_index=0, log_dir="tmp/"):
    """
    Create a wrapped, monitored Unity environment.
    """
    def make_env(rank, use_visual=True): # pylint: disable=C0111
        def _thunk():
            unity_env = UnityEnvironment(env_directory, base_port=5000 + rank, no_graphics=True)
            env = UnityToGymWrapper(unity_env, uint8_visual=True)
            env = Monitor(env, os.path.join(log_dir, "sb3ppo" + str(rank)))
            return env
        return _thunk
    return SubprocVecEnv([make_env(i + start_index) for i in range(num_env)])
    
#     if visual:
#         return SubprocVecEnv([make_env(i + start_index) for i in range(num_env)])
#     else:
#         rank = MPI.COMM_WORLD.Get_rank() if MPI else 0
#         return DummyVecEnv([make_env(rank, use_visual=False)])

# def make_env(env_id, rank, seed=0):
#     """
#     Utility function for multiprocessed env.

#     :param env_id: (str) the environment ID
#     :param num_env: (int) the number of environments you wish to have in subprocesses
#     :param seed: (int) the inital seed for RNG
#     :param rank: (int) index of the subprocess
#     """
#     def _init():
#         env = gym.make(env_id)
#         env.seed(seed + rank)
#         return env
#     set_random_seed(seed)
#     return _init

def main():
#     env_id = "CartPole-v1"
    env_id = "BirdSingleAgentNoStackedNoVisual-v1"
    model_id = "sb_ppo_HumSingleNoStacked_vectorized"
    log_dir = "tmp/"
    num_cpu = 4  # Number of processes to use
    timesteps = 2e5

    # Create the vectorized environment
#     env = SubprocVecEnv([make_env(env_id, i) for i in range(num_cpu)])
#     env = Monitor(env, log_dir)
    env = make_unity_env(env_directory="../run32_nostacked/run32_nostacked", num_env=1, visual=False, start_index=10, log_dir=log_dir)
    model = PPO('MlpPolicy', env, verbose=1)
    model.learn(total_timesteps=timesteps)
    
    # Save the agent
    model.save(model_id)
    del model  # delete trained model to demonstrate loading

    env.close()
    
    
    # Load the trained agent
    model = PPO.load(model_id)
    
    # open single environment
    env = DummyVecEnv([lambda: gym.make("BirdSingleAgentNoStacked-v1")])

    # Evaluate the agent
    mean_reward, std_reward = evaluate_policy(model, env, n_eval_episodes=10)
    print("===================")
    print(" Policy evaluation")
    print("===================")
    print("Mean R: ", mean_reward)
    print("Std R: ", std_reward)
    print("===================")
    
    # Enjoy trained agent
    obs = env.reset()
    for i in range(1000):
        action, _states = model.predict(obs)
        obs, rewards, dones, info = env.step(action)

#     plot_results([log_dir], timesteps, results_plotter.X_TIMESTEPS, "PPO Vectorized")
#     plt.show()

if __name__ == '__main__':
    main()