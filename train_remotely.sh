#!/usr/bin/env bash

cat $1/net.config | sed "s|PATH_TO_BE_CONFIGURED|$2/job|g" > $1/gcs_net.config
gsutil rsync $1 $2/job
gcloud ml-engine jobs submit training object_detection_`date +%s` \
    --job-dir=$2/job \
    --packages $1/object_detection-0.1.tar.gz,$1/slim-0.1.tar.gz \
    --module-name object_detection.train \
    --region us-central1 \
    --config $1/cloud.yml \
    -- \
    --train_dir=$2/model/train \
    --pipeline_config_path=$2/job/gcs_net.config

