if [ ! -d "logs_train" ]
then
     mkdir "logs_train"
else
     echo "Directory exists"
fi

# rm -rf ../results/*
# rm ../*.log

mv *.log logs_train/