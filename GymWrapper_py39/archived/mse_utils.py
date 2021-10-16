import matplotlib.pyplot as plt
import torch as t
import torch.nn as nn
from mlagents_envs.side_channel.side_channel import SideChannel, IncomingMessage, OutgoingMessage
from mlagents_envs.side_channel.engine_configuration_channel import EngineConfigurationChannel
import gym
from mlagents_envs.environment import UnityEnvironment as UE
from gym_unity.envs import UnityToGymWrapper
import uuid
import numpy as np
from stable_baselines3.common.vec_env import VecVideoRecorder

import gym

# class CustomEnv(gym.Env):
#     def __init__(self, _env):
#         super(CustomEnv, self).__init__()
#         self.env = _env
#         self.action_space = self.env.action_space
#         self.action_size = self.env.action_size
#         self.observation_space = gym.spaces.Dict({
#             0 : gym.spaces.Box(low = 0, high = 1, shape=(27, 60, 3)), # =(40, 90, 3)),
#             1 : gym.spaces.Box(low = 0, high = 1, shape=(20, 40, 1)), # (56, 121, 1
#             2 : gym.spaces.Box(low = '-inf', high = 'inf', shape=(400, ))
#         })
#
#     @staticmethod
#     def tuple_to_dict(s):
#         obs = {
#             0 : s[0],
#             1 : s[1],
#             2 : s[2]
#         }
#         return obs
#
#     def reset(self):
#         #         print("LOG: returning reset" + self.tuple_to_dict(self.env.reset()))
#         #         print("LOG: returning reset" + (self.env.reset()))
#         #          np.array(self._observation)
#         return self.tuple_to_dict(self.env.reset())
#
#     def step(self, action):
#         s, r, d, info = self.env.step(action)
#         return self.tuple_to_dict(s), float(r), d, info
#
#     def close(self):
#         self.env.close()


