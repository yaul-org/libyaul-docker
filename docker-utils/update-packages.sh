#!/bin/bash

set -x -e

CONTAINER_ID="${CONTAINER_ID:=update-packages}"

cleanup() {
    docker stop "${CONTAINER_ID}"
    docker rm "${CONTAINER_ID}"
}

docker pull ijacquez/yaul:latest
docker run -t -d --name "${CONTAINER_ID}" ijacquez/yaul:latest

trap 'exit=${?}; cleanup; exit ${exit}' INT HUP TERM

cat <<EOF | docker exec -i "${CONTAINER_ID}" bash -xe
sudo pacman -Syy
pacman -Sl yaul-linux | \
    awk '/\[installed.*]/ { print \$2 }' | xargs sudo pacman --noconfirm -S
history -c
EOF
