#!/usr/bin/env bash
cd $1

gsutil rsync -r -d processed gs://com-tabtale-objectdetectiontest-data/data
gcloud ml-engine jobs submit training object_detection_`date +%s` \
    --job-dir=gs://com-tabtale-objectdetectiontest-data/data/train \
    --packages processed/object_detection-0.1.tar.gz,processed/slim-0.1.tar.gz \
    --module-name object_detection.train \
    --region us-central1 \
    --config processed/cloud.yml \
    -- \
    --train_dir=gs://com-tabtale-objectdetectiontest-data/train \
    --pipeline_config_path=gs://com-tabtale-objectdetectiontest-data/data/gcs_pets.config

