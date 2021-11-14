mlagents-learn config/$1.yaml --env build/agent --run-id=$1 \
    --width=1080 --height=684 --time-scale=50 --num-envs=5 --resume --base-port=$2 \
    > $1.log

