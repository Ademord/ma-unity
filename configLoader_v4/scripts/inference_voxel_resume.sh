if [ ! -d "logs_inference" ]
then
     mkdir "logs_inference"
else
     echo "Directory exists"
fi
echo "resuming <voxel inference> on run <$2> with config <$1>"
mlagents-learn ../config/$1.yaml --env ../build_inference_voxel/agent --run-id=$2 \
    --width=1080 --height=684 --time-scale=20 --num-envs=3 --resume --base-port=$3 > logs_inference/$2-inference.log
echo "exiting 'resuming <voxel inference> on run <$2>"
