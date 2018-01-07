#!/usr/bin/env bash


# Create data locally using docker (run from img work path)
docker run -v `pwd`:/mnt/ tf1-4-0 /mnt/prepare_data.sh /mnt/data /mnt

# Train remotely (run from script folder)
./train_remotely.sh imgwork/data gs://com-tabtale-objectdetectiontest-data/imgwork

# Eval remotely (run from script folder)
./eval_remotely.sh imgwork/data gs://com-tabtale-objectdetectiontest-data/imgwork

# run tensorboard
tensorboard --logdir=gs://com-tabtale-objectdetectiontest-data/imgwork/model
