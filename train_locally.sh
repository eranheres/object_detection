#!/usr/bin/env bash
cd $1

mkdir -p model/train
mkdir -p model/eval

docker run -v `pwd`:/mnt $2 \
    python object_detection/train.py \
        --logtostderr \
        --pipeline_config_path=/mnt/processed/docker_pets.config \
        --train_dir=/mnt/model