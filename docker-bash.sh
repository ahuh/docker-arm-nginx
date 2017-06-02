#!/bin/sh

# =======================================================================================
# Get a new instance of bash in running Docker container
#
# Use this command instead of 'docker attach' if you want to interact with the container while it's running
# =======================================================================================

# Parameters
if [[ $# != 1 ]] ; then
    echo ''
    echo 'Usage: docker-bash.sh <docker-container-name>'
    echo ''
    exit 1
fi

export CONTAINER_NAME=$1

# Commands
docker exec -it ${CONTAINER_NAME} /bin/bash