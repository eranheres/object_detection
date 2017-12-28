#!/usr/bin/env bash

if [ ! -d $1 ]; then
    mkdir $1
    mkdir -p $1/processed
fi
cd $1
pwd

if [ ! -d images ]; then
    wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz
    tar -xvf images.tar.gz
    rm images.tar.gz
fi

if [ ! -d annotations ]; then
    wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz
    tar -xvf annotations.tar.gz
    rm annotations.tar.gz
fi

# convert to tfrecord
echo converting to TFRecords...
if [ ! -f pet_train.record ]; then
    docker run -v `pwd`:/mnt tf \
        python object_detection/dataset_tools/create_pet_tf_record.py \
            --label_map_path=object_detection/data/pet_label_map.pbtxt \
            --data_dir=/mnt \
            --output_dir=/mnt
    cp pet_train_with_masks.record processed/pet_train.record
    cp pet_val_with.masks.record processed/pet_val.record
fi

# download ready trained model from other project
if [ ! -d faster_rcnn_resnet101_coco_11_06_2017 ]; then
    wget http://storage.googleapis.com/download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    tar -xvf faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    rm faster_rcnn_resnet101_coco_11_06_2017.tar.gz
fi
cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* processed/.


# run eval
# python object_detection/eval.py --logtostderr --pipeline_config_path=/Users/eranh/Project/object_detection/pet_data/models/model/pet_model.config --checkpoint_dir=/Users/eranh/Project/object_detection/pet_data/models/model/train --eval_dir=/Users/eranh/Project/object_detection/pet_data/models/model/eval

# run tensorboard
# tensorboard --logdir=/Users/eranh/Project/object_detection/pet_data/models/model/
cd ..
