if [ ! -d "logs_inference" ]
then
     mkdir "logs_inference"
else
     echo "Directory exists"
fi
mlagents-learn ../config/$1.yaml --env ../build_inference_octree/agent --run-id=$1 --initialize-from=$3 \
    --width=1080 --height=684 --time-scale=20 --num-envs=5 --force --base-port=$2 > logs_inference/$1-inference.log
