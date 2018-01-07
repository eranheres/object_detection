#!/usr/bin/env bash
gcloud ml-engine jobs submit training object_detection_eval_`date +%s` \
    --job-dir=$2/job \
    --packages $1/object_detection-0.1.tar.gz,$1/slim-0.1.tar.gz \
    --module-name object_detection.eval \
    --region us-central1 \
    --scale-tier BASIC_GPU \
    -- \
    --checkpoint_dir=$2/model/train \
    --eval_dir=$2/model/eval \
    --pipeline_config_path=$2/job/gcs_net.config

