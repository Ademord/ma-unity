# cd ~/ultron/baseAgents/; ./train_visON.sh run66 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run67 5005 &

# cd ~/ultron/baseAgents/; ./train_visON_resume.sh run66 5000 &

# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run62 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run65-pure 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run62 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run64-nospeed 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run62 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run64-nospeed 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++100 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-explore 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run62-8-pathak 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run63++100 5005 &



# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63++100 5005 && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run67 50010 &

# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run67 5005 && \
    
#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-8-nolinger 5010 && \

    cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON_resume.sh run69-16-nolinger 5015 && \

   cd ~/ultron/configLoader_v4/scripts     && \
    ./train_visON.sh run61-explore-constrained-nospeed-pathak 5010