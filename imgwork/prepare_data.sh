#!/usr/bin/env bash
if [ ! $# -eq 2 ]
  then
    echo "No argument supplied - usage "
    echo "prepare_data.sh <dest_folder> <script path>"
    exit
fi

mkdir -p $2/tmp
pwd
cd $2
pwd
ls -a $2/tmp

if [ ! -f $1/pet_train.record -o ! $1/pet_val.record ]; then
    mkdir $2/tmp
    python generate_images.py --background=stinkbug.png --foreground=box.png --amount=10 --destpath=$2/tmp
    python split_dict_to_train_val.py --output_path=$2/tmp --dict=$2/tmp/dict.txt --ratio=70
    python create_tfrecord.py --output_path=$1/pet_train.record --dict_path=$2/tmp/train.txt
    python create_tfrecord.py --output_path=$1/pet_val.record --dict_path=$2/tmp/eval.txt
    # rm -rf $2/tmp
else
    echo images folder exists, skipping download
fi

# download ready trained model from other project
if [ ! -f $1/model.ckpt.meta ]; then
    wget http://storage.googleapis.com/download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    tar -xvf faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    rm faster_rcnn_resnet101_coco_11_06_2017.tar.gz
    cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* $1/.
else
    echo premade model exists, skipping download
fi

# cp $2/object_detection/data/pet_label_map.pbtxt $1/.
cp cloud.yml $1/.
cp net_pets.config $1/net_pets.config
# cat pets.config | sed "s|PATH_TO_BE_CONFIGURED|gs://com-tabtale-objectdetectiontest-data/data|g" > processed/gcs_pets.config

# getting object detection code and slim
# cp dist/object_detection-0.1.tar.gz $1/.
# cp slim/dist/slim-0.1.tar.gz $1/.

