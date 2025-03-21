#!/bin/bash

podman run -d -e OUT_HOST=192.168.122.8 -e OUT_PORT=8443 quay.io/luisarizmendi/con-in:latest
