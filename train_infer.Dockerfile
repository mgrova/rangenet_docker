FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,display

ARG TENSORRTVER=cuda10.1-trt5.1.5.0-ga-20190427
ARG OSVER=ubuntu1804 

COPY nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb /root
RUN rm /etc/apt/sources.list.d/cuda.list && \
    dpkg -i /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/${OSVER}/x86_64/7fa2af80.pub && \
    apt-get update && \
    apt-get install -yqq libnvinfer-dev=5.1.5-1+cuda10.1 tensorrt && \
    rm /root/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb && \
    rm -r /var/nv-tensorrt-repo-${TENSORRTVER}

RUN apt-get install -yqq build-essential nano apt-utils git cmake wget sudo \
                         libboost-all-dev libyaml-cpp-dev libopencv-dev \
                         ninja-build unzip autoconf autogen libtool \
                         python-dev python3-dev python-pip python3-pip \
                         python-empy python3-pyqt5.qtopengl python3-numpy python3-wheel python3-tk \
                         mlocate zlib1g-dev libxft-dev ffmpeg \
                         software-properties-common openjdk-8-jdk libpng-dev && \
    updatedb && \
    sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create Default user and its password.
ARG USER=user
ARG PASS=rangenet

RUN useradd --create-home --shell /bin/bash ${USER} \
            -p "$(openssl passwd -1 ${PASS})"
USER ${USER}
WORKDIR /home/${USER}
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc

RUN git clone https://github.com/PRBonn/lidar-bonnetal.git && \
    cd lidar-bonnetal/train && \
    pip3 install -r requirements.txt

# Download rangenet++ infer and training pipelines
RUN git clone -b master https://github.com/mgrova/rangenet_lib.git && \
    cd rangenet_lib && mkdir build && cd build && \
    cmake .. && make -j4