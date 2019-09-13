# Docker image for nvPY
nvPY is a simplenote-syncing note-taking tool.
The main purpose of this image is to build Python interpreter with UCS-4 support to work nvPY perfectly.

## Installation
```bash
$ sudo rm -rf /opt/nvpy/
$ docker run yuuki0xff/nvpy get-tarball |sudo tar xvC /
$ /opt/nvpy/bin/python3 -m pip install --user -U 'git+https://github.com/cpbotha/nvpy.git#egg=nvpy'
$ rehash
$ nvpy
```
