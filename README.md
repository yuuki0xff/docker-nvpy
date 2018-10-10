# Docker image for nvPY
nvPY is a simplenote-syncing note-taking tool.
The main purpose of this image is to build the nvPY and related softwares for support emoji (pictograms).

## Installation
```bash
$ sudo rm -rf /opt/nvpy/
$ docker run yuuki0xff/nvpy get-tarball |sudo tar xvC /
```
