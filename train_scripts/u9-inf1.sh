# cd ~/ultron/configLoader_v4_random/scripts     && \
#     ./train_visON.sh runRandom 5005 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run65-pure-vision 5010

# env focused

# DISCARDED
# cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
#     inf_o.run62-4.fixedVolumeCount \
#     5015 inf_o.run62-4 && \


# cd ~/ultron/configLoader_v4/scripts     && \
# ./train_visON_resume.sh ev_sac.run69-8 5015   

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
inf_o.run69-8 inf_o.run69-8 5010 run69-8 && \

cd ~/ultron/configLoader_v4/scripts && ./inference_voxel.sh \
inf_o.run69-8 inf_v.run69-8 5015 run69-8 