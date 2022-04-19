FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
ARG TENSORRTVER=cuda10.1-trt5.1.5.0-ga-20190427
ARG WKDIR=/home/user
WORKDIR ${WKDIR}

COPY nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb /root 
RUN dpkg -i /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-${TENSORRTVER}/7fa2af80.pub && \
    apt-get update && \
    apt-get install -y libnvinfer-dev=5.1.5-1+cuda10.1 tensorrt && \
    rm /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb

RUN rm -r /var/nv-tensorrt-repo-${TENSORRTVER}
