# Dockerfile

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG TENSORRT=nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb

COPY nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb /root
RUN dpkg -i /root/nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y tensorrt && \
    rm /root/nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb

RUN rm -r /var/nv-tensorrt-repo-cuda10.1-trt5.1.5.0-ga-20190427

RUN apt-get install -yqq  build-essential python3-dev python3-pip apt-utils git cmake libboost-all-dev libyaml-cpp-dev libopencv-dev python-empy

RUN pip install catkin_tools trollius numpy
