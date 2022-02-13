# cd ~/ultron/baseAgents/; ./train_visON.sh run68++100 5000 &
# cd ~/ultron/baseAgents/; ./train_visON.sh run61 5005 &

# cd ~/ultron/baseAgents/; ./train_visON_resume.sh run67 5000 &

# cd ~/ultron/openWorldBicycle/; ./train_visON.sh run63++050 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run66 5005 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run63++025 5005 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run65 5005 &

# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++100-oracle 5005 &
# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run61-voxel 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run62-4-pigeon 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run64 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON.sh run64 5005 &

# cd ~/ultron/configLoader_v4/scripts; ./train_visON_resume.sh run63++100-nospeed 5005  && \
# cd ~/ultron/configLoader_v4/scripts && ./train_visON_resume.sh run68++050 5010 &


# cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run68++050 5005 && \
    
#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON.sh run69-16-noTrainEntropy 5010 && \

    # cd ~/ultron/configLoader_v4/scripts     && \
    # ./train_visON_resume.sh run69-4-nolinger-noTrainEntropy 5015

    # cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
    # inf_o.run62-4  inf_o.run62-4 5010

    # cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
    # inf_o.run66 inf_o.run66 5015 run66 
# cd ~/ultron/configLoader_v4/scripts && ./inference_voxel_resume.sh \
# inf_o.run69-8 inf_v.run69-8 5010 run69-8


# cd ~/ultron/configLoader_v4/scripts && ./inference_octree_resume.sh \
# inf_o.run69-16-constrained inf_o.run69-16-constrained-no-init 5010 


    # cd ~/ultron/configLoader_v4/scripts     && \
    # ./train_visON_resume.sh run62-16-pathak-constrained-nospeed-nolinger 5010


    
# cd ~/ultron/configLoader_v4/scripts     && \
# ./train_visON.sh run63++100-nospeed-object-detector 5010


cd ~/ultron/configLoader_v4/scripts     && \
./train_visON.sh run62-4-pigeon-constrained-nospeed 5010
