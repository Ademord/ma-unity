if [ ! -d "logs_train" ]
then
     mkdir "logs_train"
else
     echo "Directory exists"
fi

echo "training run $1"
mlagents-learn ../config/$1.yaml --env ../build/agent --run-id=$1 \
    --width=1080 --height=684 --time-scale=20 --num-envs=3 --force --base-port=$2 \
    > logs_train/$1.log

echo "exiting 'training run $1'"
