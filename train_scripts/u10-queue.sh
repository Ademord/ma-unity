# cd ~/ultron/configLoader_v4_random/scripts     && \
#     ./train_visON.sh runRandom 5005 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run65-pure-vision 5010


# env focused CONFIGS MUST CREATE


    cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    inf_o.run63++100-nospeed inf_o.run63++100-nospeed 5005 run63++100-nospeed



1 = config
2 = id
3 = port
4 = initialize

# obj focused >> only spins around an object
# cd ~/ultron/configLoader_v4/scripts && ./inference_voxel.sh \
#     inf_o.run63++025 \
#     5005 run63++100-nospeed && \

# cd ~/ultron/configLoader_v4/scripts && ./inference_voxel.sh \
#     inf_o.run63++100-nospeed-nolinger \
#     5005 run63++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63++100-nospeed \
    5005 run63++100-nospeed && \

# baseline/oracle runs ONLY TRAIN FOR 5M IN VOXEL


# cd ~/ultron/configLoader_v4/scripts && ./inference_voxel.sh \
#     inf_o.run66 \
#     5005 run66 && \


# baseline/oracle runs
cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63\
    5005 run63

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63 \
    5005 run63

# mixed runs
cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run68++100-nospeed \
    5005 run68++100-nospeed

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run69-8 \
    5005 run69-8