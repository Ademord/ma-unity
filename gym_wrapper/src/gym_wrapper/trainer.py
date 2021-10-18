import json
from time import time
from stable_baselines3 import PPO
from stable_baselines3.common.evaluation import evaluate_policy
from functools import wraps
import torch
import os
from wandb.integration.sb3 import WandbCallback
from stable_baselines3.common.torch_layers import BaseFeaturesExtractor
import torch.nn as nn
from stable_baselines3.common.vec_env import DummyVecEnv, VecVideoRecorder, SubprocVecEnv
import random
import numpy as np
from stable_baselines3.common.utils import set_random_seed

import environment_controller
import gym
from wandb import Config
from colors import *

# Ensure deterministic behavior
random.seed(hash("setting random seeds") % 2 ** 32 - 1)
np.random.seed(hash("improves reproducibility") % 2 ** 32 - 1)
torch.manual_seed(hash("by removing stochasticity") % 2 ** 32 - 1)

if torch.cuda.is_available():
    device = torch.device('cuda:0')
    # device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    print("Device set to : " + str(torch.cuda.get_device_name(device)))

    torch.cuda.empty_cache()
    torch.backends.cudnn.deterministic = True
    torch.cuda.manual_seed_all(hash("so runs are repeatable") % 2 ** 32 - 1)
else:
    print("Device set to : cpu")
    pretty_print_separator()


def measure(func):
    @wraps(func)
    def _time_it(*args, **kwargs):
        start = int(round(time() * 1000))
        try:
            return func(*args, **kwargs)
        finally:
            end_ = int(round(time() * 1000)) - start
            #             print(f"Total execution time: {end_ if end_ > 0 else 0} ms")
            #             end_ = int(round(time())) - start
            print("------------------------------------------------------------------------------")
            print("Total execution time: {:.2f} seconds".format(end_ / 1000 if end_ > 0 else 0))
    return _time_it


class CustomCombinedExtractor(BaseFeaturesExtractor):
    def __init__(self, observation_space: gym.spaces.Dict, features_dim: int = 1024):
        super(CustomCombinedExtractor, self).__init__(observation_space, features_dim)

        self.cnn1 = nn.Sequential(
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3, stride=2),
            nn.ReLU(),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=2, stride=1),
            nn.MaxPool2d(kernel_size=2),
            nn.ReLU(),
            nn.Flatten()
        )
        self.cnn2 = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=16, kernel_size=3, stride=2),
            nn.ReLU(),
            nn.Conv2d(in_channels=16, out_channels=32, kernel_size=3, stride=2),
            nn.MaxPool2d(kernel_size=2),
            nn.ReLU(),
            nn.Flatten()
        )

        sample_obs = observation_space.sample()

        obs1 = sample_obs[0]
        obs2 = sample_obs[1]
        obs3 = sample_obs[2]
        with torch.no_grad():
            n_flatten = self.cnn1(torch.as_tensor([obs1]).permute(0, 3, 1, 2)).shape[-1]
            n_flatten += self.cnn2(torch.as_tensor([obs2]).permute(0, 3, 1, 2)).shape[-1]
            n_flatten += obs3.shape[-1]

        self.linear_layer = nn.Sequential(
            nn.Linear(in_features=n_flatten, out_features=features_dim),
            nn.ReLU()
        )

    def forward(self, observation):
        obs1 = self.cnn1(observation[0].permute(0, 3, 1, 2))
        obs2 = self.cnn2(observation[1].permute(0, 3, 1, 2))
        obs3 = observation[2]
        x = torch.cat([obs1, obs2, obs3], dim=1)
        return self.linear_layer(x)


class FullModel(nn.Module):
    def __init__(self, custom_extractor, extractor, action_net, value_net, observation_shape):
        super(FullModel, self).__init__()

        self.custom_extractor = custom_extractor
        self.extractor = extractor
        self.action_net = action_net
        self.value_net = value_net

        self.observation_shape = observation_shape

    def forward(self, observation):
        feature_hidden = self.custom_extractor(observation)
        aval, vval = self.extractor(feature_hidden)
        return self.action_net(aval), self.value_net(vval)


class Trainer:
    def __init__(self, callback):
        with open('run_config.json') as json_file:
            config = json.load(json_file)
        # print("loaded config: " + str(config))
        self.config = Config()
        for k, v in config.items():
            self.config[k] = v
        self.rank = 0

        base_path = os.path.join(self.config.run_dir, "monitor")
        pretty_print("Monitor base path: " + base_path)

        self.callback = callback


    @measure
    def test_compatibility(self):
        environment_controller.set_rank(_rank=self.rank, _callback=self.callback)
        self.rank += 1

        test_env: gym.Env = environment_controller.make_env()
        environment_controller.test_env_compatibility(test_env)
        test_env.close()

    @measure
    def model_pipeline(self):
        train = self.config.total_timesteps > 0
        test = self.config.test_total_episodes > 0
        export_onnx = self.config.export_onnx

        reinitialize_from = self.config.run_dir.split("/")[:-2] + [self.config.reinitialize_from, "files"]
        reinitialize_from = "/".join(reinitialize_from)
        # pretty_print("Building reinitialize_from string: {}".format(reinitialize_from), Colors.FAIL)

        if not os.path.isdir(reinitialize_from): 
            print("\tReinitialize folder does not exist!")
        else: 
            print("\tReinitialize folder was found!")
        
        model_path = os.path.join(reinitialize_from, "model")  \
            if self.config.reinitialize_from != "" and os.path.isdir(reinitialize_from) \
            else os.path.join(self.config.run_dir, "model")

        if self.config.reinitialize_from != "":
            pretty_print("Reinitializing training from run: {}".format(model_path), Colors.FAIL)

            if train:
                num_cpu = self.config.num_env
                # Create the vectorized environment
                idx_r = self.rank
                self.rank += num_cpu

                env = SubprocVecEnv([self._make_my_vec_env(self.config.env_id, i, self.callback) for i in range(idx_r, num_cpu + idx_r)])
                env.reset()

                # get a new model
                model = self._make_model(env)
                # train and save model
                _ = self._train_pipeline(model)

                # notify of saved trained model
                pretty_print("Trained model saved to: " + model_path)

                env.close()
                del env
                self.rank -= num_cpu

            if test or export_onnx:
                # load env
                environment_controller.set_rank(_rank=self.rank, _wandb_run_identifier="test", _callback=self.callback)
                self.rank += 1
                env = DummyVecEnv([environment_controller.make_env])
                env.reset()
                # load saved trained model
                # model_path = "/host/unity_builds/mse-dreamscape/wandb/run-20211003_110641-34bcwtgd/files/model"
                model = self._load_model(model_path)

                if test:
                    test_r, test_std_r = self._test_pipeline(model, env)  # mean_reward, std_reward
                    pretty_print("Test evaluation results: {}, {}".format(test_r, test_std_r))

                if export_onnx:
                    self._export_pipeline(model, env)

                # close env
                env.close()
                del env
                self.rank -= 1

@measure
    def _make_my_vec_env(self, env_id, rank, callback, seed=0):
        """
        Utility function for multiprocessed env.

        :param env_id: (str) the environment ID
        :param seed: (int) the inital seed for RNG
        :param rank: (int) index of the subprocess
        """

        def _init():
            environment_controller.set_rank(_rank=rank, _callback=callback)
            env = environment_controller.make_env()
            # print("_make_my_vec_env of type:", type(env))
            env.seed(seed + rank)
            return env

        set_random_seed(seed)
        return _init

    @measure
    def _load_model(self, model_path):
        try:
            model = PPO.load(model_path)
            pretty_print("Model successfully loaded: {} from {}".format(model, model_path))
            return model

        except BaseException as e:
            error_msg = "Model could not be loaded. Error: {}".format(e)
            pretty_print(error_msg, Colors.FAIL)
            raise Exception(error_msg)

    @measure
    def _make_model(self, env, model_path=None):
        print("------------------------------------------------------------------------------")

        # policy kwargs
        policy_kwargs = dict(features_extractor_class=CustomCombinedExtractor, )

        model = PPO("MlpPolicy", env,
                    policy_kwargs=policy_kwargs,
                    learning_rate=self.config.lr_actor,
                    # n_steps=self.config.buffer_size,
                    # batch_size=self.config.batch_size,
                    # n_epochs=self.config.n_epochs,
                    gamma=self.config.gamma,
                    gae_lambda=self.config.gae_lambda,
                    clip_range=self.config.clip_range,
                    tensorboard_log=self.config.run_dir, verbose=1)

        pretty_print("New model successfully created: {}".format(model))
        return model

    @measure
    def _train_pipeline(self, model):
        pretty_print_separator()
        pretty_print("Training...")

        model.learn(
            total_timesteps=self.config.total_timesteps,
            callback=WandbCallback(
                gradient_save_freq=100,
                model_save_path=f"" + os.path.join(self.config.run_dir, "models"),
                verbose=2,
            ),
        )
        return model

    @measure
    def _test_pipeline(self, model, env):
        pretty_print_separator()
        pretty_print("Testing...")
        # model.eval()

        # Run the model on some test examples
        with torch.no_grad():
            print("Evaluating on {} episodes".format(self.config.test_total_episodes))
            return evaluate_policy(model, env, n_eval_episodes=self.config.test_total_episodes)

    # TODO FIX based on github feedback
    @measure
    def _export_pipeline(self, model, env):
        pretty_print_separator()
        pretty_print("Exporting model...")

        # temp
        full_model = self._get_full_model_for_export(model, env)
        s = self._get_empty_observations_for_export(env)

        # export to onnx
        export_path = os.path.join(self.config.run_dir, "model.onnx")
        torch.onnx.export(full_model, s, export_path)
        pretty_print("Model ({}) successfully exported.".format(type(model))
                     if os.path.isfile(export_path)
                     else "Error: Could not model ({}) export to onnx.".format(type(model)))

    def _get_full_model_for_export(self, model, custom_env):
        return FullModel(
            model.policy.features_extractor,
            model.policy.mlp_extractor,
            model.policy.action_net,
            model.policy.value_net,
            [custom_env.observation_space[i].shape for i in custom_env.observation_space.sample().keys()]
        )

    def _get_empty_observations_for_export(self, env):
        # adapt environment and observations
        s = env.reset()
        print("state shapes:", s[0].shape)

        x = torch.randn(1, *env.observation_space[0].shape).cuda()
        y = torch.randn(1, *env.observation_space[1].shape).cuda()
        z = torch.randn(1, *env.observation_space[2].shape).cuda()
        s = [x, y, z]

        print("--------------------------")
        print(s[0].shape)
        print(x.shape)
        print(y.shape)
        print(z.shape)
        print("--------------------------")

        return s
