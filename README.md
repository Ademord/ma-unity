
# Entropy-Aware Active Vision through Voxelized Octree Exploration of 3D Scenes

![image description](docs/MSE_github_cover.png)


The large and still increasing popularity of deep learning, along with the growing availability of 3D labeled datasets has been setting the stage to the continuous development of new algorithms in scene understanding and autonomous systems. Where traditional approaches to navigation depend on task subdivisions and map awareness, newer approaches take on the problem of navigation from the perspective of model-free solutions with partial observability, given that challenging real life scenarios, such as rescue missions and dynamic scenes, are unknown environments.

In this thesis, we propose an embodied agent to tackle the problem of object exploration given partial observability in an unknown environment by exploiting octrees for the efficient navigation of 3D scenes. Furthermore, given the necessity to incorporate the temporal dimension in visual object recognition tasks, we propose extrinsic rewards for the scanning of voxelized objects with a reinforcement learning agent in order to cover various trajectories around an object of interest, therefore reducing the uncertainty of such objects and their characteristics.
We also take into account the level of entropy in a simulated Unity environment to adjust the behavior of our agent on-the-fly, improving on the exploratory performance of current methods in active vision. 
Our results outperform our Unity implementations of previous classical and geometric approaches and improve upon current state-of-the-art exploration methods that are motivated by coverage maximization and semantic curiosity. We achieve better exploratory performance by at least a factor of two in the scanning of objects and cover 8\% more of the environment in comparison to our baselines.

Furthermore, by using octrees, voxels and panoramic vision, our method is able to adapt to new environments without changes in its behavior or fine-tuning, bridging the gap between synthetic data and real data for the exploration of 3D environments, where the data distribution plays a key role given the commonly seen noise, outliers and missing data in RGB-D sensors.
Finally, given the increasing amount of algorithms, newer and extensible benchmarks are needed for testing more sophisticated challenges that are representative of the real world. Motivated by recent works in the Unity 3D engine and the ML-Agents plugin, we demonstrate the applicability our approach in three 3D environments, test its performance in two environments inspired by the DARPA Subterranean Challenge and aim to further motivate the creation of new benchmarks, custom-made testing environments, exploration methods, and the reproducibility and extensibility of research results.

Our approach aims to serve as a baseline for computer vision methods that incorporate the temporal dimension for increased certainty about objects, in tasks such as synthetic data generation, rescue missions, autonomous driving, exploration and navigation, point-to-goal tasks, etc. All Unity 3D Assets are protected by copyright.


# Thesis document
Please feel free to reference this thesis work in your own work and publications. The document PDF is added in this repository.

For the latex of the thesis document please refer to: https://github.com/Ademord/MT_scene_understanding_2

# Unity Assets used

![image description](docs/MSE_github_assets.png)


# Unity Packages used

![image description](docs/MSE_github_packages.png)


# Licenses and Copyright

[Apache License 2.0](https://github.com/Unity-Technologies/ml-agents/blob/main/LICENSE.md)

All assets in the project from the Unity Asset Store are under copyright and must be bought.
 
The Unity code included are the scripts for the trained agents and the ONNX models. 
For a full copy of the Unity project please reach out to me directly.

# Acknowledgements

Thanks to all the developers who contributed with their own projects, tutorials and ideas to the conception of this master's thesis, and to my family and friends.
Special thanks to [Mbaske](https://github.com/mbaske) and [Aakarshan Chauhan](https://github.com/Aakarshan-chauhan).

