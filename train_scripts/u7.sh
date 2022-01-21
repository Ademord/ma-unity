# cd ~/ultron/baseAgents/; ./train_visON.sh run63++075 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run63++100 5005 &

# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++075 5000 &
# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++100 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++100 5000 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run68++050 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run63++100 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63++100 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68 5000 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-16-constrained 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run65 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-16-constrained-pigeon-pathak 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run68++100-oracle 5005 &

cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run69-4 5010 && \

    cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run69-8 5015
