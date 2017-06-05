#!/bin/sh

# =======================================================================================
# Get a new instance of bash in running Docker container
#
# Use this command instead of 'docker attach' if you want to interact with the container while it's running
# =======================================================================================

# ------------------------------------------------------
# Common parameters

export CONTAINER_NAME=nginx

if [[ "$1" = "h" ]] || [[ "$1" = "help" ]] || [[ "$1" = "-h" ]] || [[ "$1" = "-help" ]] || [[ "$1" = "--h" ]] || [[ "$1" = "--help" ]]; then
    echo 'Bash into a Docker container.'
    echo ''
    echo 'Usage:'    
    echo '  docker-bash.sh [CONTAINER_NAME]'
    echo '  docker-bash.sh h | help | -h | -help | --h | --help'
    echo ''
    echo 'Options:'
    echo "  CONTAINER_NAME   Name of the container [default: ${CONTAINER_NAME}]"  
    echo ''
    exit 1
fi

if [[ $1 ]]; then	
	CONTAINER_NAME=$1
else
	echo "Using default container name: ${CONTAINER_NAME}"
fi

# ------------------------------------------------------
# Commands

echo "Bash into container: ${CONTAINER_NAME}"
docker exec -it ${CONTAINER_NAME} /bin/bash
