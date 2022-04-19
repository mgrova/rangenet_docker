# rangenet_docker
Docker container with all dependencies to be able to work with RangeNet++

## Dependencias

* Docker

* TensorRT 5.1


## Instalación

Es importante descargar el TensorRT de la página oficial de NVIDIA y colocarlo en éste directorio, junto al fichero Dockerfile.

## USO

```
DOCKER_BUILDKIT=1 docker build -t rangenet_cuda .
```

Una vez tengamos la imagen creada, para iniciar el contenedor emplearemos el siguiente comando:

* Versión mínima

```
docker run --rm -it --gpus all \
-v `pwd`:/home/user/workdir \
rangenet_cuda
```

* Version con configuración completa
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
