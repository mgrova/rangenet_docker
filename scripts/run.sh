#!/bin/bash

# Get script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Check if nvidia-docker2 is already installed
REQUIRED_PKG="nvidia-container-toolkit"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    bash -c $SCRIPT_DIR"/install_nvidia-docker2.sh"
fi

# Check if image is already created
CONTAINER_EXISTS=$(docker images | grep rangenet_cuda)
if [ -z "$CONTAINER_EXISTS" ] 
then
    echo "Creating docker image ..."
    DOCKER_BUILDKIT=1 docker build -t rangenet_cuda -f $PARENT_DIR/test_infer.Dockerfile .
fi

# Create container
xhost +local: && \
docker container run -it --rm \
        --gpus all \
        --security-opt apparmor:unconfined \
        --ipc host \
        --network host \
        --env="DISPLAY=$DISPLAY" \
        --env QT_X11_NO_MITSHM=1 \
        --env XAUTHORITY=$XAUTH \
        --volume "$XAUTH:$XAUTH" \
        --volume "/tmp/.X11-unix:/tmp/.X11-unix" \
        --volume $PARENT_DIR/shared_folder:/home/user/shared_folder \
        rangenet_cuda
