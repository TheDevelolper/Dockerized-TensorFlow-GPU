FROM tensorflow/tensorflow:1.12.0-devel-gpu-py3
ADD src /tensorflow-project/src
WORKDIR /tensorflow-project/src
RUN pip3 install -r requirements.txt