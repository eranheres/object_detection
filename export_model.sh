#!/usr/bin/env bash

# From tensorflow/models/research/
python object_detection/export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path $1/pipeline.config \
    --trained_checkpoint_prefix $1 \
    --output_directory $1/output_inference_graph.pb