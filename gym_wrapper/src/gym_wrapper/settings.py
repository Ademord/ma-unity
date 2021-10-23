import wandb, json, os
from colors import *
import numpy as np


class SettingsController:
    self.wandb_tables = {}


    def callback(table_id, key, val):
        if wandb.run is not None:

            # add table_id to tables
            if table_id not in self.wandb_tables:
                self.wandb_tables[table_id] = {}

            # add new metric  to respective table_id
            if key in wandb_tables[table_id]:
                self.wandb_tables[table_id][key] += [val]
            else:
                self.wandb_tables[table_id][key] = [val]

    def log_wandb_tables(self):
        global wandb_tables
        print("Logging tables found: {}".format(wandb_tables.keys()))

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



    def __init__(self, args):

        pretty_print(SEPARATOR, Colors.OKCYAN)

        pretty_print("Initializing run.....", Colors.OKCYAN)

        cwd_path = os.path.dirname(os.path.abspath(__file__))
        base_run_dir = os.path.join(cwd_path, args.run_dir)
        project_config_path = os.path.join('../', base_run_dir, 'config.txt')
        run_config_path = os.path.join(base_run_dir, 'config.txt')
        wandb_run_dir = base_run_dir
        best_model_path = os.path.join(base_run_dir, 'best/')

        print("project_config_path: " + project_config_path)
        print("run_config_path: " + run_config_path)
        print("base_run_dir: " + base_run_dir)
        print("wandb_run_dir: " + base_run_dir)

        with open(run_config_path) as json_file:
            local_config = json.load(json_file)

        with open(project_config_path) as json_file:
            project_config = json.load(json_file)

        global_config = {**project_config, **local_config}

        # update starting_rank in project config

        with open(project_config_path) as outfile:
            project_config = 3 
            json.dump(dict(wandb.config), outfile)

        del project_config
        del local_config


        wandb.login(key=os.environ.get('WANDB_KEY', None))

        pretty_print("Initializing WandB", Colors.FAIL)

        resume_wandb = global_config["resume_wandb"]
        project_name = wandb_run_dir.split("/")[-3] # global_config["wandb_project"]
        run_id = wandb_run_dir.split("/")[-2] # global_config["run_id"]
        monitor_gym = global_config["monitor_gym"]


        pretty_print("resume_wandb: {}".format(resume_wandb), Colors.FAIL)
        pretty_print("project_name: {}".format(project_name), Colors.FAIL)
        pretty_print("run_id: {}".format(run_id), Colors.FAIL)

        wandb.init(project=project_name,
                   config=global_config,
                   sync_tensorboard=True,  # auto-upload sb3's tensorboard metrics
                   monitor_gym=monitor_gym,  # auto-upload the videos of agents playing the game
                   save_code=True,  # optional
                   resume=resume_wandb,
                   id=run_id,
                   dir=wandb_run_dir, 
                   settings=wandb.Settings(_save_requirements=False))

        # update with run_dir value and config
        wandb.config.update(
            {"run_dir": wandb.run.dir}, allow_val_change=True)
        wandb.config.update(
            {"env_path": os.path.join(base_run_dir, wandb.config.env_path)}, allow_val_change=True)
        wandb.config.update(
            {"best_model_path": os.path.join(best_model_path, 'model.zip')}, allow_val_change=True)

        bestFolderExist = os.path.exists(best_model_path)
        if not bestFolderExist: os.makedirs(best_model_path)

        with open('temp_run_config.json', 'w') as outfile:
            json.dump(dict(wandb.config), outfile)
        print_config()


    def print_config(self):
        config_str = json.dumps(dict(wandb.config), sort_keys=True, indent=4)

        pretty_print(SEPARATOR, Colors.OKCYAN)

        pretty_print("config: {}".format(config_str), Colors.FAIL)

        pretty_print(SEPARATOR, Colors.OKCYAN)


    def close_all(self):
        pretty_print("Exiting WandB run.....", Colors.OKCYAN)

        os.remove('temp_run_config.json')

        self.log_wandb_tables()

        wandb.finish()

        pretty_print_separator()
