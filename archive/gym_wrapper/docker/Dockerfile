# First Dockerfile setup spins up a jupyter notebook setup
# This Dockerfile is used to build an ROS + OpenGL + Gazebo + Tensorflow image based on Ubuntu 18.04
# FROM nvidia/cudagl:10.1-devel-ubuntu18.04
# FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu20.04
# FROM nvidia/cuda:11.1-devel-ubuntu20.04
# FROM vistart/cuda:11.0-cudnn8-devel-ubuntu20.04

# edited image on 16.06 to cuda:11.3.1 > hopefully proper gcc is installed
# FROM vistart/cuda:10.2-cudnn7-devel-ubuntu20.04
# FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
# FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
# FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-devel
FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

LABEL maintainer="Franco Ribera"
LABEL franco-ribera="https://github.com/ademord"

ENV REFRESHED_AT 11.10.2020

# Install sudo
RUN apt-get update && \
    apt-get install -y sudo apt-utils

ARG DEBIAN_FRONTEND=noninteractive
# Add new sudo user
ARG user=ros
ARG passwd=ros
ARG uid=1000
ARG gid=1000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid
ENV ROS_DISTRO=noetic
ENV HOME=/home/ros

RUN useradd --create-home -m $USER && \
        echo "$USER:$PASSWD" | chpasswd && \
        usermod --shell /bin/bash $USER && \
        usermod -aG sudo $USER && \
        echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER && \
        chmod 0440 /etc/sudoers.d/$USER && \
        # Replace 1000 with your user/group id
        usermod  --uid $UID $USER && \
        groupmod --gid $GID $USER

# install the python3 libraries 
RUN apt-get install -y python3.8 python3.8-dev python3-pip build-essential

# link python -> python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Same for pip (not needed in cuda11 image)
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# update apt-mirrors
RUN pip install apt-mirror-updater && apt-mirror-updater --auto-change-mirror

# install utilities
RUN apt-get update && apt-get install -y vim bash tmux git wget lsb-release lsb-core

#### INSTALL ROS ###
# # install ROS dependencies
# RUN pip install rosdep rospkg rosinstall catkin_tools catkin_pkg

# # install python-empy
# RUN apt-get install -y python3-empy

# # Install ROS
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list' && \
#     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-ros-base \
#     ros-${ROS_DISTRO}-pcl-ros \
#     ros-${ROS_DISTRO}-pcl-conversions \
#     ros-${ROS_DISTRO}-image-geometry \
#     ros-${ROS_DISTRO}-image-view

# # initialize catkin build environment
# RUN rosdep init

# # adjust user
# USER $USER

# # fix permissions and update dependencies
# RUN rosdep fix-permissions && rosdep update

# # i  dont know what to name this comment
# RUN ls -la /opt/ros/${ROS_DISTRO}/
# RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
# RUN /bin/bash -c "source ~/.bashrc"

# # setup catkin workspace << this just makes mkdir, catkin_init_workspace and catkin_make, in brief 
# ENV CATKIN_WS ${HOME}/catkin_ws
# COPY init_workspace.sh ${HOME}
# RUN sudo chmod +x ${HOME}/init_workspace.sh

# # build ros workspace
# RUN ${HOME}/init_workspace.sh

# # copy ROS packages for MaskRCNN
# RUN /bin/bash -c "cd ${CATKIN_WS}/src; \
#   git clone https://github.com/gtoff/maskrcnn_msgs.git"

# # adjust dependencies
# USER root
# RUN chown -R 1000:1000  ${HOME}/*

# # discover new dependencies
# USER $USER
# RUN bash -c ". ${CATKIN_WS}/devel/setup.bash ; cd ${CATKIN_WS}; catkin_make"


### ML INSTALL ###
USER root

# update expired ROS key
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
# update 
RUN apt-get update

# install utilities
ENV PATH "$PATH:/home/ros/.local/bin"
RUN apt-get install -y ffmpeg freeglut3-dev xvfb
RUN apt-get install -y libgtk2.0-0 unzip libblas-dev liblapack-dev libhdf5-dev libgl1-mesa-glx
RUN apt-get install -y htop

# RUN apt-get install -y cuda-cudart-10-1
# RUN apt-get install -y cuda-cudart-11-3
# RUN ldconfig /usr/local/cuda/lib64

# fix dependencies for cudnn
# 10.2 and 7
ENV CUDA=11.1 
ENV CUDNN_MAJOR=8
ENV LD_LIBRARY_PATH=/usr/local/cuda-${CUDA}/lib64:${LD_LIBRARY_PATH}
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.${CUDNN_MAJOR} /usr/local/cuda-${CUDA}/lib64/libcudnn.so.${CUDNN_MAJOR}
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.${CUDNN_MAJOR} /usr/local/cuda-${CUDA}/lib64/libcudnn.so

USER $USER

# install required base packages
RUN pip install --upgrade pip
# RUN python --version

# removed numpy ==1.19.2, removed upgrades from these two lines 
RUN pip install numpy matplotlib pandas h5py testresources scipy scikit-build scikit-learn scikit-image pycocotools imgaug imantics
RUN pip install jupyterlab tensorflow-graphics-gpu tensorflow pygments keras 

# install pytorch 
# need to set to 1.8.1 because torch_geometric has not been updated yet. will probably be updated from 20.06.21 on
# RUN pip install torch==1.8.1
# torch==1.5 torchvision==0.6 -f https://download.pytorch.org/whl/cu101/torch_stable.html
# RUN sudo apt-get install -y python3-tk << moved down as pip install tk

# old robotics dependencies
# RUN pip install cython pyyaml==5.1 tk
# RUN pip install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
# RUN pip install detectron2==0.1.3 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/index.html
# RUN pip install python-cfonts django
# gym is installed through stable-baselines3
RUN sudo apt-get install tmux
RUN pip install -U stable-baselines3[extra]==1.3.0 mlagents==0.26.0 gym-unity==0.26.0 wandb 
RUN pip install ipywidgets jupyterlab-system-monitor

# RUN pip install pika

# torch-points3d dependencies
# ARG TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" 
# RUN pip install torch-points-kernels==0.6.6 torch-points3d 
# RUN pip install pyvista panel
# pyvista panel plyfile torch-geometric torch-sparse torch-scatter torch-points-kernels omegaconf torch-clustertorch-points-kernels omegaconf torch-cluster hydra torchnet wandb "PySocks!=1.5.7,>=1.5.6" gdown pytorch-metric-learning open3d torch-cluster

# MINKOWSKI ENGINE
# RUN sudo apt install -y libopenblas-dev
# RUN pip install ninja
# RUN pip install -U MinkowskiEngine --install-option="--blas=openblas" -v --no-deps

# Expose Jupyter 
EXPOSE 8888

# Expose Tensorboard
EXPOSE 6006


COPY entrypoint.sh /home/${USER}/entrypoint.sh

# Entrypoint Jupyter
WORKDIR /
CMD jupyter-lab --port=8888 --allow-root --ip=0.0.0.0 --NotebookApp.iopub_data_rate_limit=1e10

# CMD "/home/${USER}/entrypoint.sh"
# CMD python manage.py runserver 0.0.0.0:8000
