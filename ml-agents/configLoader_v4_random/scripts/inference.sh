# if [ ! -d "inference_logs" ]
# then
#      mkdir "inference_logs"
# else
#      echo "Directory exists"
# fi
mlagents-learn ../config/$1.yaml --env ../build/agent --run-id=inference.$1 --initialize-from=$1 \
    --width=1080 --height=684 --time-scale=5 --num-envs=1 --force --base-port=$2 > inference_logs/$1-inference.log
