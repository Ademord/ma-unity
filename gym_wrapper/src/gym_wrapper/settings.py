import wandb, json, os
from colors import *
import numpy as np


wandb_tables = {}

def callback(table_id, key, val):
    if wandb.run is not None:
        global wandb_tables
        
        # add table_id to tables
        if table_id not in wandb_tables:
            wandb_tables[table_id] = {}

        # add new metric  to respective table_id
        if key in wandb_tables[table_id]:
            wandb_tables[table_id][key] += [val]
        else:
            wandb_tables[table_id][key] = [val]

        
def log_wandb_tables():
    global wandb_tables
    
    for table_id, table in wandb_tables.items():
        pretty_print("Publishing table: {} ...".format(table_id), Colors.FAIL)
        
        columns = list(table.keys())
        my_data = list(table.values())

        n_smallest_list = min([len(x) for x in my_data]) 
        step = n_smallest_list // 1000
        print("smallest list found: ", n_smallest_list)
        print("step found: ", step)
        
        for j in range(0, n_smallest_list, step): #n_smallest_list
            payload = {}
            for i in range(len(columns)):
                metric = columns[i]
                payload[metric] = sum(table[metric][j:j+step])//step # following https://stackoverflow.com/questions/41933232/python-average-every-n-elements-in-a-list
                # print("adding table[{}][{}]: {}".format(metric,j,table[metric][j]))
            # print("logging payload: ", payload)
            wandb.log(payload)
                    
        pretty_print("\tTable {} logged.".format(table_id), Colors.OKGREEN)


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


def close_all():
    pretty_print("Exiting WandB run.....", Colors.OKCYAN)

    log_wandb_tables()

    wandb.finish()
    
    pretty_print_separator()
