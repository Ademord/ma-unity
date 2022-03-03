#!/bin/bash
echo "Initiating Detectron2 entrypoint..."

echo "Initiating roscore..."
# start roscore
. ${CATKIN_WS}/devel/setup.bash
roscore &
rosparam set /use_sim_time true
sleep 3

# if DETECTRON_TRAIN set to empty variable 
if [[ -z ${DETECTRON_TRAIN} ]]; then
    echo "Initiating Predictor network: INFERENCE MODE"
    # start predictor network
    . ${CATKIN_WS}/devel/setup.bash
    cd  ${HOME}/catkin_ws/src/detectron2/samples/teats
    # using local weights
    python faketeatsros.py ros \
        --weights=${DETECTRON_WEIGHTS} \
        --config="packed"
    sleep 3
    # TODO remove these comments, this code has been moved to another component

    # # align PC
    # . ${CATKIN_WS}/devel/setup.bash
    # rosrun align_pointcloud align_pointcloud_node "/maskrcnn/points" &

    # echo "Initiating convert2pix script"
    # # start maskrcnn intermediary
    # cd  ${HOME}/catkin_ws/src/detectron2/scripts/
    # python convert_pixel_to_real_world_coords_point_cloud_threads.py

else
    #for training on local weights
    echo "Initiating Predictor network: TRAINING MODE"

    . ${CATKIN_WS}/devel/setup.bash
    cd  ${HOME}/catkin_ws/src/detectron2/samples/teats
    
    python faketeatsros.py train \
    --config=${REMOTE_WEIGHTS} \
    --dataset=${DATASET}

    # for training on remote weights
    # python faketeatsros.py train \
    #    --config=${REMOTE_WEIGHTS} \
    #    --dataset=${DATASET}

    # for training on local weights
    # python faketeatsros.py train \
    #    --weights=${DETECTRON_WEIGHTS} \
    #    --config="packed" \
    #    --dataset=${DATASET}
    echo "TRAINIG FINISHED. SAVE THE OUTPUT DIR."
fi
