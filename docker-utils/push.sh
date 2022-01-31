#!/bin/bash

set -x -e

CONTAINER_ID="${CONTAINER_ID:=update-packages}"

cleanup() {
    docker stop "${CONTAINER_ID}"
    docker rm "${CONTAINER_ID}"
}

trap 'exit=${?}; cleanup; exit ${exit}' 0 INT HUP TERM

docker commit -a "Israel Jacquez" -m "Update packages" "${CONTAINER_ID}" ijacquez/yaul:latest
docker push ijacquez/yaul:latest
