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


# cd ~/ultron/configLoader_v4/scripts     && \
#    ./train_visON_resume.sh run66 5010  && \

# cd ~/ultron/configLoader_v4_smallcam/scripts     && \
#     ./train_visON_resume.sh ev_smallcam.run69-8 5020 


# cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
# inf_o.run69-8 inf_o.run69-8 5010 run69-8


# cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
# inf_o.run69-16-nolinger inf_v.run69-16-nolinger 5010





