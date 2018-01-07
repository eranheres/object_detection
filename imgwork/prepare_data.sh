#!/usr/bin/env bash
if [ ! $# -eq 2 ]
  then
    echo "No argument supplied - usage "
    echo "prepare_data.sh <dest_folder> <script path>"
    exit
fi

pwd
mkdir -p $2/tmp
mkdir -p $1
cp dist/object_detection-0.1.tar.gz $1/.
cp slim/dist/slim-0.1.tar.gz $1/.
pwd
cd $2
pwd

if [ ! -f $1/train.record -o ! $1/eval.record ]; then
    mkdir $2/tmp
    python generate_images.py --background=background.png --foreground=box.png --amount=1000 --destpath=$2/tmp
    python split_dict_to_train_val.py --output_path=$2/tmp --dict=$2/tmp/dict.txt --ratio=70
    python create_tfrecord.py --output_path=$1/train.record --dict_path=$2/tmp/train.txt
    python create_tfrecord.py --output_path=$1/eval.record --dict_path=$2/tmp/eval.txt
    # rm -rf $2/tmp
else
    echo images folder exists, skipping download
fi

# download ready trained model from other project
if [ ! -f $1/model.ckpt.meta ]; then
    if [ -d cached_model ]; then
        cp cached_model/* $1/.
    else
        curl -O http://storage.googleapis.com/download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz
        tar -xvf faster_rcnn_resnet101_coco_11_06_2017.tar.gz
        rm faster_rcnn_resnet101_coco_11_06_2017.tar.gz
        cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* $1/.
        mkdir -p cached_model
        cp faster_rcnn_resnet101_coco_11_06_2017/model.ckpt.* cached_model/.
    fi
else
    echo premade model exists, skipping download
fi

# cp $2/object_detection/data/pet_label_map.pbtxt $1/.
cp cloud.yml $1/.
cp net.config $1/.
cp label_map.pbtxt $1/.

# getting object detection code and slim
# cp dist/object_detection-0.1.tar.gz $1/.
# cp slim/dist/slim-0.1.tar.gz $1/.

