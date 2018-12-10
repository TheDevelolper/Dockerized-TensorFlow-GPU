FROM tensorflow/tensorflow:latest-gpu
ADD src /tensorflow-project/src
WORKDIR /tensorflow-project/src
