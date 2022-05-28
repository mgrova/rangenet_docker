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
    rm -r /var/nv-tensorrt-repo-${TENSORRTVER} && \
    rm /etc/apt/sources.list.d/nv-tensorrt-${TENSORRTVER}.list 

RUN apt-get install -yqq build-essential nano apt-utils git cmake wget sudo \
                         libboost-all-dev libyaml-cpp-dev libopencv-dev \
                         ninja-build unzip autoconf autogen libtool \
                         python-dev python3-dev python-pip python3-pip \
                         python-empy python3-pyqt5.qtopengl python3-numpy python3-wheel python3-tk \
                         mlocate zlib1g-dev libxft-dev ffmpeg tmux \
                         software-properties-common openjdk-8-jdk libpng-dev && \
    updatedb && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create Default user and its password.
ARG USER=user
ARG PASS=rangenet

RUN useradd --create-home --shell /bin/bash ${USER} \
            -p "$(openssl passwd -1 ${PASS})" && \
	    usermod -aG sudo ${USER}
USER ${USER}
WORKDIR /home/${USER}
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc

# All these python packages is the requeriments.txt from lidar_bonnetal, but due 
# to a bug in protobuf it is necessary to install each package individually and 
# install tensorflow and tensorflow without their additional dependencies.
RUN pip3 install --no-cache-dir torchvision==0.2.2.post3 \
                                matplotlib==2.2.3 \
                                scipy==1.5.4 \
                                vispy==0.5.3 \
                                opencv_python==4.1.0.25 \
                                opencv_contrib_python==4.1.0.25 \
                                protobuf==3.6.1 \
                                PyYAML==5.1.1 \
                                absl-py==1.0.0 \ 
                                gast==0.5.3 \
                                astor==0.8.1 \
                                termcolor==1.1.0 \
                                keras_applications==1.0.8 \ 
                                keras_preprocessing==1.1.2 \
                                google_auth_oauthlib==0.5.1 \
                                werkzeug==2.0.3 \
                                markdown==3.3.7 \
                                grpcio==1.46.3 && \  
    pip3 install --no-deps tensorflow==1.13.1 tensorboard==2.9.0

RUN git clone https://github.com/PRBonn/lidar-bonnetal.git
#    pip3 install --no-cache-dir -r requirements.txt

# Download rangenet++ infer and training pipelines
RUN git clone -b master https://github.com/mgrova/rangenet_lib.git && \
    cd rangenet_lib && mkdir build && cd build && \
    cmake .. && make -j4
