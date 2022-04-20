FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
ARG TENSORRTVER=cuda10.1-trt5.1.5.0-ga-20190427
ARG OSVER=ubuntu1804 
ARG WKDIR=/home/user
WORKDIR ${WKDIR}

COPY nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb /root 
RUN dpkg -i /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-${TENSORRTVER}/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libnvinfer-dev=5.1.5-1+cuda10.1 tensorrt && \
    rm /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb

RUN rm -r /var/nv-tensorrt-repo-${TENSORRTVER}

RUN apt-get install -yqq build-essential python-dev python-pip python-empy nano \
                         apt-utils git cmake libboost-all-dev libyaml-cpp-dev libopencv-dev && \
    sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

RUN pip install catkin_tools trollius numpy

WORKDIR ${WKDIR}
RUN mkdir -p rangenet_ws/src && cd rangenet_ws/src && \
    git clone https://github.com/PRBonn/rangenet_lib.git && \
    git clone https://github.com/ros/catkin.git && \
    cd .. && catkin init && \
    catkin build rangenet_lib


