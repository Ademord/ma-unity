# cd ~/ultron/configLoader_v4_random/scripts     && \
#     ./train_visON.sh runRandom 5005 && \

#     cd ~/ultron/configLoader_v4/scripts     && \
#     ./train_visON_resume.sh run65-pure-vision 5010


cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run62-16-constrained \
    5005 run62-16-constrained-pigeon-pathak

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run62-16-constrained-pigeon \
    5005 run62-16-constrained-pigeon-pathak

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run62-4 \
    5005 run62-16-constrained-pigeon-pathak

# obj focused

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63++025 \
    5005 run63++100-nospeed

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63++100-nospeed-nolinger \
    5005 run63++100-nospeed

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63++100-nospeed \
    5005 run63++100-nospeed


# oracle runs

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63\
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run63 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run64 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run65 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run66 \
    5005 run66

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run67 \
    5005 run67

# mixed runs

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run68 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run68 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run69 \
    5005 run67

cd ~/ultron/configLoader_v4/scripts && ./inference_octree.sh \
    inf_o.run69 \
    5005 run67