#!/bin/bash

export PATH=$PATH:/c/Program\ Files\ \(x86\)/VMware/VMware\ Workstation:/mnt/c/Program\ Files\ \(x86\)/VMware/VMware\ Workstation

VM=${DOCKER_MACHINE_NAME-default}
script_src=${BASH_SOURCE}
script_rel=$(realpath "${script_src}")
script_dir=$(dirname "${script_rel}")

pushd "${script_dir}" > /dev/null
DOCKER_MACHINE=./docker-machine.exe

if [ ! -f "${DOCKER_MACHINE}" ]; then
  echo "Docker Machine is not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

VMX_FILE=~/.docker/machine/machines/${VM}/${VM}.vmx

if [[ -f ${VMX_FILE} ]]; then
    vmrun list | grep "${VM}" &> /dev/null
    ret_code=$?

    if [[ $ret_code ]]; then
        "${DOCKER_MACHINE}" start ${VM}
    fi
else
    "${DOCKER_MACHINE}" create \
          --driver vmwareworkstation \
          --vmwareworkstation-cpu-count 2 \
          --vmwareworkstation-disk-size 120000 \
          --vmwareworkstation-memory-size 8192 \
          "${VM}"
fi
