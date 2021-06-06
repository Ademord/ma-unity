from gym.envs.registration import register

from mlagents_envs.environment import UnityEnvironment
from gym_unity.envs import UnityToGymWrapper

path_run32 = "../run32/run32"
path_run32_multiagent = "run32_training"
path_run32_nostacked = "../run32_nostacked/run32_nostacked"


# class MyUnityEnv(UnityToGymWrapper):
#     def __init__(self, **kwargs):
#         unity_env = UnityEnvironment(file_name="run32_training")
#         super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)
class SingleAgentEnv(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)
        
class SingleAgentEnvNoVisual(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32, no_graphics=True)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)

class MultiAgentEnv(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32_multiagent)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)

class MultiAgentEnvNoVisual(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32_multiagent, no_graphics=True)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)

class SingleAgentEnvNoStacked(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32_nostacked)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)
        
class SingleAgentEnvNoStackedNoVisual(UnityToGymWrapper):
    def __init__(self, **kwargs):
        unity_env = UnityEnvironment(file_name=path_run32_nostacked, no_graphics=True)
        super().__init__(unity_env=unity_env, uint8_visual=False, flatten_branched=False, allow_multiple_obs=False)

def get_all_ids():
    print("Available Hummingbird Environments:")
    print(" HumMultiagent\n", "HumMultiagentNovisual")
    print(" HumSingleagent\n", "HumSingleAgentNovisual")
    print(" BirdSingleAgentNoStacked\n", "BirdSingleAgentNoStackedNoVisual")

register(
    id='HumMultiagent-v1',
    entry_point='unity_env_wrapper:MultiAgentEnv'
)
register(
    id='HumMultiagentNovisual-v1',
    entry_point='unity_env_wrapper:MultiAgentEnvNoVisual'
)
register(
    id='HumSingleagent-v1',
    entry_point='unity_env_wrapper:SingleAgentEnv'
)
register(
    id='HumSingleAgentNovisual-v1',
    entry_point='unity_env_wrapper:SingleAgentEnvNoVisual'
)
# the environments above wont work perfectly because of the stacked observations
register(
    id='BirdSingleAgentNoStacked-v1',
    entry_point='unity_env_wrapper:SingleAgentEnvNoStacked'
)
register(
    id='BirdSingleAgentNoStackedNoVisual-v1',
    entry_point='unity_env_wrapper:SingleAgentEnvNoStackedNoVisual'
)
# unity_env = UnityEnvironment(file_name=env_location)
# env = UnityToGymWrapper(unity_env, uint8_visual=False, allow_multiple_obs=False)