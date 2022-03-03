echo "inference on <<run $2>>"
mlagents-learn ../config/$1.yaml --env ../build_demo_voxel/agent --run-id=$2 \
    --width=1080 --height=648 --time-scale=20 --base-port=$3 --num-envs=3 --resume --inference \
    >> logs_train/$2.log

echo "exiting 'inference on <<run $2>>'"




