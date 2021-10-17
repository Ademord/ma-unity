import wandb, atexit, json, os
from colors import *


def callback(payload):
    if wandb.run is not None:
        # print(" [x] Received {}".format(payload))
        # print(" [x] Received type {}".format(type(payload)))
        # raise Exception("hello")
        wandb.log(payload, commit=False)


def initialize():
    pretty_print(SEPARATOR, Colors.OKCYAN)
    pretty_print("Initializing run.....", Colors.OKCYAN)
    # safety blocker
    configured = True
    # open config
    with open('config.txt') as json_file:
        global_config = json.load(json_file)
    # login
    wandb.login(key=os.environ.get('WANDB_KEY', None))
    # init
    pretty_print("Initializing WandB", Colors.FAIL)
    wandb.init(project="mse-dreamscape",
               config=global_config,
               sync_tensorboard=True,  # auto-upload sb3's tensorboard metrics
               monitor_gym=True,  # auto-upload the videos of agents playing the game
               save_code=True,  # optional
               )
    # update with run_dir
    wandb.config.update({"run_dir": wandb.run.dir}, allow_val_change=True)
    # update config.json
    with open('run_config.json', 'w') as outfile:
        json.dump(dict(wandb.config), outfile)

    print_config()
    # atexit.register(exit_handler)


def print_config():
    config_str = json.dumps(dict(wandb.config), sort_keys=True, indent=4)
    pretty_print(SEPARATOR, Colors.OKCYAN)
    pretty_print("config: {}".format(config_str), Colors.OKCYAN)
    pretty_print(SEPARATOR, Colors.OKCYAN)


def consume_TFSideStats():
    pretty_print_separator()
    # pretty_print("Waiting for async...", Colors.FAIL)
    consumer = Consumer(callback)
    consumer.setDaemon(True)
    consumer.start_consuming()
    import asyncio
    #asyncio.run(consumer.start_consuming())

    pretty_print("Closing consumer connection.....", Colors.OKCYAN)
    # close consumer
    consumer.close_connection()
    pretty_print_separator()


def close_all():
    # consume_TFSideStats()
    # close wandb
    pretty_print("Exiting WandB run.....", Colors.OKCYAN)
    wandb.finish()
    pretty_print_separator()
