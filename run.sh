#!/bin/bash

docker container run --rm -it \
    --group-add=sudo --group-add=video \
    -u $(id -u):$(id -g) \
    -v $(pwd):/home/${USER}/workdir \
    --shm-size=32g \
    --gpus=all \
    -p 8003:8003 \
    -p 8004:8004 \
    ${USER}_label-studio

# http://localhost:8003
