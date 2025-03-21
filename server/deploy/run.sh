#!/bin/bash

podman run -d -p 2223:2223 -p 8443:8443 -p 8089:8089 quay.io/luisarizmendi/con-out:latest
