import wandb, json, os
from colors import *


class SettingsController:
    def __init__(self):
        self.wandb_tables = {}
        self.project_name = None
        self.global_config = None
        self.monitor_gym = None
        self.run_id = None
        self.resume_wandb = None
        self.wandb_run_dir = None
        self.best_model_path = None
        self.base_run_dir = None
        self.project_config_path = None
        self.run_config_path = None

    def initialize(self, base_run_dir):
        self.base_run_dir = base_run_dir
        print("setting... " + self.base_run_dir)
        
        pretty_print(SEPARATOR, Colors.OKCYAN)
        pretty_print("Initializing run.....", Colors.OKCYAN)

        self.setup_from_configs()

        wandb.login(key=os.environ.get('WANDB_KEY', None))

        pretty_print("\nInitializing WandB\n", Colors.FAIL)

        self.init_wandb("train")

        self.dump_temp_config()
        print_config()

    def init_wandb(self, section: str, resume_overwrite=None):
        
        wandb.init(project=self.project_name,
                   config=self.global_config,
                   sync_tensorboard=True,  # auto-upload sb3's tensorboard metrics
                   monitor_gym=self.monitor_gym,  # auto-upload the videos of agents playing the game
                   save_code=True,  # optional
                   resume=resume_overwrite or self.resume_wandb,
                   id=self.run_id,
                   dir=self.wandb_run_dir,
                   settings=wandb.Settings(_save_requirements=False),
                   reinit=True,
                   tags=[section])

    def setup_from_configs(self):
        
        # resume_run": "",
        # reinitialize from is solved in trainer.py
        # "reinitialize_from": "",
        
        cwd_path = os.path.dirname(os.path.abspath(__file__))
        base_run_dir = self.base_run_dir
        project_config_path = os.path.join(base_run_dir, '../config.txt')
        run_config_path = os.path.join(base_run_dir, 'config.txt')
        wandb_run_dir = base_run_dir

        print("project_config_path: " + project_config_path)
        print("run_config_path: " + run_config_path)
        print("base_run_dir: " + base_run_dir)
        print("wandb_run_dir: " + base_run_dir)

        with open(run_config_path) as json_file:
            local_config = json.load(json_file)
            local_config["ranks_to_use"] = []

        with open(project_config_path) as json_file:
            project_config = json.load(json_file)
        
        # update starting_rank in project config
        with open(project_config_path, 'w') as outfile:
            if project_config["clear_project_ranks"]:
                project_config["available_ranks"] = list(range(0, 50))
                project_config["taken_ranks"] = []

            ranks_to_take = local_config["num_env"]
            local_config["ranks_to_use"] = project_config["available_ranks"][:ranks_to_take]

            project_config["available_ranks"] = project_config["available_ranks"][ranks_to_take:]
            project_config["taken_ranks"] += local_config["ranks_to_use"]

            json.dump(project_config, outfile, indent=4)
        
        # merge configs
        self.global_config = {**project_config, **local_config}
        
        # privacy in wandb push
        del self.global_config["available_ranks"]
        del self.global_config["taken_ranks"]
        
        # project and run data
        self.wandb_run_dir = wandb_run_dir
        self.base_run_dir = base_run_dir
        
        self.project_name = wandb_run_dir.split("/")[-3]  # global_config["wandb_project"]
        self.run_id = wandb_run_dir.split("/")[-2]  # global_config["run_id"]
        import time
        self.run_id += time.strftime('-%m%d-%H%M%S')
        self.project_config_path = project_config_path
        
        # monitoring
        self.monitor_gym = self.global_config["monitor_gym"]

        # resume
        self.resume_run_id = self.global_config["resume_run_id"]
        self.resume_wandb = self.resume_run_id != ""
        if self.resume_wandb: self.run_id = self.resume_run_id

        # reinitialization
        self.reinitialize_model_path = os.path.join(self.global_config["reinitialize_from"], 'files/model.zip') if self.global_config["reinitialize_from"] != "" else ""
        self.best_model_path = os.path.join(base_run_dir, 'best/model.zip')

        pretty_print("resume_run_id: {}".format(self.resume_run_id), Colors.FAIL)
        pretty_print("resume_wandb: {}".format(self.resume_wandb), Colors.FAIL)
        pretty_print("reinitialize_model_path: {}".format(self.reinitialize_model_path), Colors.FAIL)
        pretty_print("project_name: {}".format(self.project_name), Colors.FAIL)
        pretty_print("run_id: {}".format(self.run_id), Colors.FAIL)

    def dump_temp_config(self):
        # update with run_dir value and config
        wandb.config.update(
            {"run_dir": wandb.run.dir}, allow_val_change=True)
        wandb.config.update(
            {"env_path": os.path.join(self.base_run_dir, wandb.config.env_path)}, allow_val_change=True)
        wandb.config.update(
            {"best_model_path": self.best_model_path}, allow_val_change=True)
        wandb.config.update(
            {"reinitialize_model_path": self.reinitialize_model_path}, allow_val_change=True)
        # wandb.config.update(
        #     {"resume_run_id": self.resume_run_id}, allow_val_change=True)

    
        bestFolderExist = os.path.exists(self.best_model_path)
        if not bestFolderExist: os.makedirs(self.best_model_path)

        with open('temp_run_config.json', 'w') as outfile:
            json.dump(dict(wandb.config), outfile)

    def log_wandb_tables(self):
        print("Logging tables found: {}".format(self.wandb_tables.keys()))

        for table_id, table in self.wandb_tables.items():
            # create a new section
            self.init_wandb(section=table_id, resume_overwrite=True)
            pretty_print("Publishing table: {} ...".format(table_id), Colors.FAIL)


            columns = list(table.keys())
            my_data = list(table.values())

            n_smallest_list = min([len(x) for x in my_data])
            step = n_smallest_list // 1000
            # print("columns: ", columns)

            print("smallest list found: ", n_smallest_list)
            print("step found: ", step)

            for j in range(0, n_smallest_list, step):  # n_smallest_list
                payload = {}
                for i in range(len(columns)):
                    metric = columns[i]
                    payload[metric] = sum(table[metric][
                                          j:j + step]) // step  # following https://stackoverflow.com/questions/41933232/python-average-every-n-elements-in-a-list
                    # print("adding table[{}][{}]: {}".format(metric,j,table[metric][j]))
                # print("logging payload: ", payload)
                wandb.log(payload)
                # wandb.log({table_id: payload})

            pretty_print("\tTable {} logged.".format(table_id), Colors.OKGREEN)

    def close_all(self):
        pretty_print("Exiting WandB run.....", Colors.OKCYAN)

        os.remove('temp_run_config.json')

        with open(self.project_config_path) as json_file:
            project_config = json.load(json_file)
            
        with open(self.project_config_path, 'w') as outfile:
            project_config["available_ranks"] += self.global_config["ranks_to_use"]
            project_config["available_ranks"].sort()

            project_config["taken_ranks"] = [r for r in project_config["taken_ranks"] if r not in self.global_config["ranks_to_use"]]

            print("saving project config: {}".format(project_config))

            json.dump(project_config, outfile, indent=4)


        if wandb.config.log_wandb_tables:
            self.log_wandb_tables()

        wandb.finish()

        pretty_print_separator()


settings_controller = SettingsController()


def callback(table_id, key, val):
    if wandb.run is not None:

        # add table_id to tables
        if table_id not in settings_controller.wandb_tables:
            settings_controller.wandb_tables[table_id] = {}

        # add new metric  to respective table_id
        if key in settings_controller.wandb_tables[table_id]:
            settings_controller.wandb_tables[table_id][key] += [val]
        else:
            settings_controller.wandb_tables[table_id][key] = [val]


def print_config():
    config_str = json.dumps(dict(wandb.config), sort_keys=True, indent=4)

    pretty_print(SEPARATOR, Colors.OKCYAN)

    pretty_print("config: {}".format(config_str), Colors.FAIL)

    pretty_print(SEPARATOR, Colors.OKCYAN)
