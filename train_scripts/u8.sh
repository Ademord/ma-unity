# cd ~/ultron/baseAgents/; ./train_visON.sh run64 5000 &


# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run64 5000 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run68++100 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run64 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run64 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++050 5000 &

# cd ~/ultron/run81_bicycle/scripts; ./inference.sh run68++050 5000 
# cd ~/ultron/run81_bicycle/scripts; ./inference.sh run64 5000 
# cd ~/ultron/run81_bicycle/scripts; ./inference.sh run63++100 5000 
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-8 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run63++050 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run65-pure 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run65-pure-vision 5005 &

# cd ~/ultron/configLoader_v4/scripts && ./train_visON.sh run68++100-oracle-nospeed 5010 &


# cd ~/ultron/configLoader_v4_random/scripts     && \
#     ./train_visON.sh runRandom 5005 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run65-pure-vision 5010


cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run66 5010