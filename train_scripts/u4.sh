# cd ~/ultron/baseAgents/; ./train_visON.sh run68++100 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run61 5005 &

# cd ~/ultron/baseAgents/; ./train_visON_resume.sh run67 5000 &

# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++050 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run66 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run65 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++100-oracle 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-voxel 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-4-pigeon 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run64 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run64 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63++100-nospeed 5005  && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68++050 5010 &


cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON_resume.sh run68++050 5005 && \
    
    cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run69-16-noTrainEntropy 5010 && \

    cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run69-4-nolinger-noTrainEntropy 5015
