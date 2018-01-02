# Object Detection
This project dockerizes then TensorBox object detection [demo](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_pets.md).

To run this project you first need to build the docker image from the docker file. Use the following to do so:

```
docker build -t tf .
```

After the docker file is ready to be used, you can execute the command

```
run <folder>
```

The script will download and convert all the required data and will execute tensorflow learning, validation.

