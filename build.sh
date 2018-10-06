#!/bin/bash
eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env toolbox-build)
./script/build-windows
eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env default)

