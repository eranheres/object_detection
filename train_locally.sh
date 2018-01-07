#!/usr/bin/env bash

cat $1/net_pets.config | sed "s|PATH_TO_BE_CONFIGURED|$1|g" > $1/net.config
python object_detection/train.py \
        --logtostderr \
        --pipeline_config_path=$1/net.config \
        --train_dir=$1