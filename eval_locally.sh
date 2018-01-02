#!/usr/bin/env bash
cd $1

docker run -v `pwd`:/mnt $2 \
    python object_detection/eval.py \
        --logtostderr \
        --pipeline_config_path=/mnt/processed/docker_pets.config \
        --checkpoint_dir=/mnt/model/train \
        --eval_dir=/mnt/model/eval