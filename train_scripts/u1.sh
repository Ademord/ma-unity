# cd ~/ultron/baseAgents/; ./train_visON.sh run65 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run65-pure 5005 &

# cd ~/ultron/baseAgents/; ./train_visON_resume.sh run65 5000 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run61 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run64+vision 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run61 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run61 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run64+vision 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-4 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-4-pathak 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run63++075 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run62-4-pathak 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run62-16-constrained-pigeon 5005  && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run66 5010 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run68++100 5005  && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68++100-oracle-nospeed 5010 &


# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run68++100 5005 && \
    
#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run63++100-nospeed-oracle-8-pigeon 5010 && \

# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run69-16 5015 && \
    

cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    inf_o.run63++025 inf_o.run63++025 5005 run63++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    inf_o.run63++100-nospeed-nolinger inf_o.run63++100-nospeed-nolinger 5005 run63++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    inf_o.run63++100-nospeed inf_o.run63++100-nospeed 5005 run63++100-nospeed

# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-4-nolinger 5005