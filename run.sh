#!/bin/sh

xhost +local:
exec docker run --rm -it --user=$(id -u) --net=host -e DISPLAY=$DISPLAY -e HOME=/data -v $HOME:/data -v /tmp:/tmp yuuki0xff/docker-nvpy
