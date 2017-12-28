FROM tensorflow/tensorflow
RUN apt-get update && apt-get install -y protobuf-compiler python-pil python-lxml python-tk git
RUN pip install jupyter matplotlib
RUN git clone https://github.com/tensorflow/models.git
WORKDIR models/research/
RUN mkdir /usr/mnt
RUN protoc object_detection/protos/*.proto --python_out=.
ENV PYTHONPATH=$PYTHONPATH:/notebooks/models/research:/notebooks/models/research/slim

