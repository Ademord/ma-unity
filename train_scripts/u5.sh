# cd ~/ultron/baseAgents/; ./train_visON.sh run62 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run63 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++050 5000 &
# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run67 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run63++050 5000 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63++050 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run66 5000 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-voxel-constrained 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-4-pigeon-pathak 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run64+vision 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run64+vision-nospeed 5005 && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68++100 5010 &

cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run63++100-nospeed-nolinger-pigeon-oracle-8 5010 && \
    
    cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run63++100-nospeed-nolinger-oracle-8 5015