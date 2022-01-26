# cd ~/ultron/baseAgents/; ./train_visON.sh run63++025 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run63++050 5005 &

# CHANGE CONFIG to adapt to this world.
# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++025 5000 &
# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++050 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++075 5000 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run68 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run63++075 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63++075 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run67 5000 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run62-16 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63++100-nospeed-nolinger-oracle 5000 && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68++100-nospeed 5005 &

# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run68++100-nospeed 5005 && \
    
#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-8-nolinger-noTrainEntropy 5010 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-16-nolinger-noTrainEntropy 5015

cd ~/ultron/configLoader_v4_bigscanner/scripts     && \
./train_visON_resume.sh ev_bigscanner.run69-8 5025    && \

# >> PENDING until it finishes training
# cd ~/ultron/configLoader_v4_bigscanner/scripts     && \
# ./inference_octree.sh inf_o.ev_bigscanner.run69-8 inf_o.ev_bigscanner.run69-8 5030 ev_bigscanner.run69-8  

# cd ~/ultron/configLoader_v4_bigscanner/scripts     && \
# ./inference_voxel.sh inf_o.ev_bigscanner.run69-8 inf_v.ev_bigscanner.run69-8 5030 ev_bigscanner.run69-8  


cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
inf_o.run68++100-nospeed  inf_o.run68++100-nospeed 5015 run68++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
inf_o.run68++100-nospeed  inf_v.run68++100-nospeed 5015 run68++100-nospeed