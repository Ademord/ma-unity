import sys
import os
import random
from mse_utils import *
import numpy as np
import torch
import wandb
from stable_baselines3.common.vec_env import DummyVecEnv, VecVideoRecorder

print('Python %s on %s' % (sys.version, sys.platform))
sys.path.extend(['C:\\Users\\franc\\PycharmProjects\\mlagents_gym_39',
                 'C:/Users/franc/PycharmProjects/mlagents_gym_39'])

gym.logger.set_level(40)
# Ensure deterministic behavior
random.seed(hash("setting random seeds") % 2**32 - 1)
np.random.seed(hash("improves reproducibility") % 2**32 - 1)
torch.manual_seed(hash("by removing stochasticity") % 2**32 - 1)

print("============================================================================================")
if torch.cuda.is_available():
    device = torch.device('cuda:0')
    # device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    print("Device set to : " + str(torch.cuda.get_device_name(device)))

    torch.cuda.empty_cache()
    torch.backends.cudnn.deterministic = True
    torch.cuda.manual_seed_all(hash("so runs are repeatable") % 2**32 - 1)
else:
    print("Device set to : cpu")
print("============================================================================================")


def main():
    wandb.login(key="5d9d8684c32eecb60c3bffc59ec8addce718eeb8")

    # new config
    global_config = dict(
        worker_id=1,
        env_id="MyUnityGymEnv-v0",
        env_path="drone3D_linux_run61.3c/mse-dreamscape",
        has_continuous_action_space=True,
        debug_env=False,
        num_env=1,

        # train
        time_scale=40,
        no_graphics=True,
        total_timesteps=300,  # int(1e4),

        # test
        test_time_scale=40,
        test_no_graphics=True,
        test_total_episodes=1,

        # Algorithm HP
        max_ep_len=800,
        K_epochs=40,               # update policy for K epochs
        eps_clip=0.2,              # clip parameter for PPO
        gamma=0.9,
        lr_actor=0.0003,
        lr_critic=0.001
    )

    wandb.init(project="mse-dreamscape",
               config=global_config,
               sync_tensorboard=True,  # auto-upload sb3's tensorboard metrics
               monitor_gym=True,  # auto-upload the videos of agents playing the game
               save_code=True,  # optional
               )

    should_train = True
    should_test_with_video = False

    if should_train:
        print("===============================================================================")
        # get environment
        env = DummyVecEnv([lambda: gym.make(wandb.config.env_id)])
        # test env compatibility
        test_env_compatibility(env)
        # get model
        model = make_model(env)
        # train and save model
        _ = train(model, wandb.config)
        # load saved trained model
        model_path = os.path.join(wandb.run.dir, "model")
        model = make_model(env, model_path)
        # test
        _, _ = test(model, env, wandb.config)  # mean_reward, std_reward
        # close env
        env.close()
        print("===============================================================================")

    if should_test_with_video:
        # get environment
        env = DummyVecEnv([lambda: gym.make(wandb.config.env_id)])
        # wrap env
        videos_path = os.path.join(wandb.run.dir, "videos")
        print("LOG: base videos_path" + videos_path)
        env = VecVideoRecorder(env, videos_path, record_video_trigger=lambda x: x % 2000 == 0, video_length=200)

        # get model
        model_path = os.path.join(wandb.run.dir, "model")
        model = make_model(env, model_path)

        # run tests
        test(model, env, wandb.config)


if __name__ == '__main__':
    main()
