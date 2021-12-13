# cd ~/ultron/baseAgents/; ./train_visON.sh run64 5000 &


# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run64 5000 &

# cd ~/ultron/openWorldBicycle/scripts; ./train_visON.sh run68++100 5005 &
# cd ~/ultron/openWorldBicycle/scripts; ./train_visON_resume.sh run64 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run64 5000 &
# cd ~/ultron/run81_bicycle/scripts; ./train_visON.sh run68++050 5000 &

# cd ~/ultron/run81_bicycle/scripts; ./inference.sh run68++050 5000 
# cd ~/ultron/run81_bicycle/scripts; ./inference.sh run64 5000 
cd ~/ultron/run81_bicycle/scripts; ./inference.sh run63++100 5000 