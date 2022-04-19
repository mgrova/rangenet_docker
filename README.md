# RangeNet++ Docker

Docker container with all dependencies to be able to work with RangeNet++. This container have Ubuntu 10.04, cuda 10.1 and TensorRT 5.1.

## Dependencies

* [Docker](https://docs.docker.com/engine/install/ubuntu)

## Installation

[TensorRT 5.1](https://developer.nvidia.com/nvidia-tensorrt-5x-download) must be downloaded from the official NVIDIA website. The appropriate file is: *nv-tensorrt-repo-ubuntu1804-cuda10.1-trt5.1.5.0-ga-20190427_1-1_amd64.deb*. This file must be placed in this directory, along with the Dockerfile.

## Building

```
DOCKER_BUILDKIT=1 docker build -t rangenet_cuda .
```

## Usage

Once we have the image created, to start the container we will use the following command:

* Minimal configuration version

```
docker run --rm -it --gpus all \
-v `pwd`:/home/user/workdir \
rangenet_cuda
```

* Full configuration version
```
xhost +local: && \
docker run --gpus all -it --rm \
-v `pwd`:/home/user/workdir \
-v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
--net=host \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-e DISPLAY=$DISPLAY \
--privileged \
rangenet_cuda
```



