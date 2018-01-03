#!/usr/bin/env bash
cd $1

gcloud ml-engine jobs submit training object_detection_eval_`date +%s` \
    --job-dir=gs://com-tabtale-objectdetectiontest-data/data/train \
    --packages processed/object_detection-0.1.tar.gz,processed/slim-0.1.tar.gz \
    --module-name object_detection.eval \
    --region us-central1 \
    --scale-tier BASIC_GPU \
    -- \
    --checkpoint_dir=gs://com-tabtale-objectdetectiontest-data/data/train \
    --eval_dir=gs://com-tabtale-objectdetectiontest-data/data/eval \
    --pipeline_config_path=gs://com-tabtale-objectdetectiontest-data/data/gcs_pets.config

