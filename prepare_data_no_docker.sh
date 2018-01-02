#!/usr/bin/env bash
if [ ! $# -eq 1 ]
  then
    echo "No argument supplied - usage "
    echo "prepare_data.sh <folder> <docker_name>"
    exit
fi

if [ ! -d $1 ]; then
    mkdir -p $1/processed
fi

if [ ! -d images ]; then
    wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz
    tar -xvf images.tar.gz
    rm images.tar.gz
else
    echo images folder exists, skipping download
fi

if [ ! -d annotations ]; then
    wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz
    tar -xvf annotations.tar.gz
    rm annotations.tar.gz
else
    echo annotations folder exists, skipping download
fi

# convert to tfrecord
echo converting to TFRecords...
if [ ! -f $1/processed/pet_train.record ]; then
    python object_detection/dataset_tools/create_pet_tf_record.py \
            --label_map_path=object_detection/data/pet_label_map.pbtxt \
            --data_dir=. \
            --output_dir=.
    cp pet_train_with_masks.record $1/processed/pet_train.record
    cp pet_val_with_masks.record $1/processed/pet_val.record
else
    echo TFRecords exists, skipping conversion
fi

# download ready trained model from other project
if [ ! -d faster_rcnn_resnet101_coco_11_06_2017 ]; then
    wget http://storage.googleapis.com/download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    tar -xvf faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    rm faster_rcnn_resnet101_coco_11_06_2017.tar.gz
else
    echo premade model exists, skipping download
fi
cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* $1/processed/.

cp object_detection/data/pet_label_map.pbtxt $1/processed/.
cp object_detection/samples/configs/faster_rcnn_resnet101_pets.config ./pets.config
cp object_detection/samples/cloud/cloud.yml $1/processed/.

cat object_detection/samples/configs/faster_rcnn_resnet101_pets.config | sed "s|PATH_TO_BE_CONFIGURED|gs://com-tabtale-objectdetectiontest-data/data|g" > $1/processed/gcs_pets.config

# getting object detection code and slim
cp dist/object_detection-0.1.tar.gz processed/.
cp slim/dist/slim-0.1.tar.gz processed/.

