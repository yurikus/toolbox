#!/bin/bash

export PATH=$PATH:/c/Program\ Files\ \(x86\)/VMware/VMware\ Workstation:/mnt/c/Program\ Files\ \(x86\)/VMware/VMware\ Workstation

trap '[ "$?" -eq 0 ] || popd > /dev/null; read -p "Looks like something went wrong in step $STEP... Press any key to continue..."' EXIT

VM=${DOCKER_MACHINE_NAME-default}
script_src=${BASH_SOURCE}
script_rel=$(realpath "${script_src}")
script_dir=$(dirname "${script_rel}")

pushd "${script_dir}" > /dev/null
DOCKER_MACHINE=./docker-machine.exe

BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ ! -f "${DOCKER_MACHINE}" ]; then
  echo "Docker Machine is not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

vmrun.exe list | grep "${VM}" &> /dev/null
VM_EXISTS_CODE=$?

set -e

STEP="Checking if machine $VM exists"
if [ $VM_EXISTS_CODE -eq 1 ]; then
    "${DOCKER_MACHINE}" start ${VM}
fi

STEP="Setting env"
eval "$(${DOCKER_MACHINE} env --shell=bash ${VM})"

STEP="Finalize"
clear
cat << EOF

                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/

EOF
echo -e "${BLUE}docker${NC} is configured to use the ${GREEN}${VM}${NC} machine with IP ${GREEN}$(${DOCKER_MACHINE} ip ${VM})${NC}"
echo "For help getting started, check out the docs at https://docs.docker.com"
echo
cd

docker () {
  MSYS_NO_PATHCONV=1 docker.exe "$@"
}
export -f docker

if [ $# -eq 0 ]; then
  echo "Start interactive shell"
  exec "$BASH" --login -i
else
  echo "Start shell with command"
  exec "$BASH" -c "$*"
fi