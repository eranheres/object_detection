#!/usr/bin/env bash
if [ ! $# -eq 2 ]
  then
    echo "No argument supplied - usage "
    echo "prepare_data.sh <folder> <docker_name>"
    exit
fi

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
if [ ! -f processed/pet_train.record ]; then
    docker run -v `pwd`:/mnt $2 \
        python object_detection/dataset_tools/create_pet_tf_record.py \
            --label_map_path=object_detection/data/pet_label_map.pbtxt \
            --data_dir=/mnt \
            --output_dir=/mnt
    cp pet_train_with_masks.record processed/pet_train.record
    cp pet_val_with_masks.record processed/pet_val.record
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
cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* processed/.

docker run -v `pwd`:/mnt $2 \
    cp object_detection/data/pet_label_map.pbtxt /mnt/processed/.
docker run -v `pwd`:/mnt $2 \
    cp object_detection/samples/configs/faster_rcnn_resnet101_pets.config /mnt/pets.config
docker run -v `pwd`:/mnt $2 \
    cp object_detection/samples/cloud/cloud.yml /mnt/processed/.
cat pets.config | sed "s|PATH_TO_BE_CONFIGURED|/mnt/processed|g" > processed/docker_pets.config
cat pets.config | sed "s|PATH_TO_BE_CONFIGURED|gs://com-tabtale-objectdetectiontest-data/data|g" > processed/gcs_pets.config

# getting object detection code and slim
docker run -v `pwd`:/mnt $2 \
    cp dist/object_detection-0.1.tar.gz /mnt/processed/.
docker run -v `pwd`:/mnt $2 \
    cp slim/dist/slim-0.1.tar.gz /mnt/processed/.

