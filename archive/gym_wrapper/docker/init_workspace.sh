#!/bin/bash
#

# Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

# Stop in case of any error.
set -e

source /opt/ros/${ROS_DISTRO}/setup.bash

# Create catkin workspace.
mkdir -p ${CATKIN_WS}/src
cd ${CATKIN_WS}/src
catkin_init_workspace
cd ..
catkin_make 
# --cmake-args \
#             -DCMAKE_BUILD_TYPE=Release \
#             -DPYTHON_EXECUTABLE=/usr/bin/python3 \
#             -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m \
#             -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so