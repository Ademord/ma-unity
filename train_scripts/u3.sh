# cd ~/ultron/baseAgents/; ./train_visON.sh run68 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run68++050 5005 &

# cd ~/ultron/baseAgents/; ./train_visON_resume.sh run68 5000 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run65 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run63 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run68++100-nospeed 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run65-pure 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++100-nospeed 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-explore-constrained 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-explore-constrained 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run62-16-pathak 5005 &


# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63++100-nospeed-nolinger 5005  && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68 5010 &



# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run63++100-nospeed-oracle-4 5005 && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON.sh run63++100-nospeed-oracle-8 50010 &



# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run63++100-nospeed-oracle-8 5005 && \
    
#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-4-noTrainEntropy 5010 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-8-noTrainEntropy 5015


# cd ~/ultron/configLoader_v4/scripts         && ./inference_octree_resume.sh \
#     inf_o.run62-16-constrained-pigeon-nospeed \
#     5005 && \

    # cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    #     inf_o.run62-4-constrained-pigeon-nospeed 5005 inf_o.run62-4


cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
    inf_o.run63++025 inf_v.run63++025 5005 run63++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
    inf_o.run63++100-nospeed-nolinger inf_v.run63++100-nospeed-nolinger 5005 run63++100-nospeed && \

cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
    inf_o.run63++100-nospeed inf_v.run63++100-nospeed 5005 run63++100-nospeed
