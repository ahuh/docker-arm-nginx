#!/bin/sh

# =======================================================================================
# Purge Docker image
#
# This script stops and removes all container based on the Docker image, before removing
# the Docker image itself
# =======================================================================================

# Parameters
if [[ $# != 1 ]] ; then
    echo ''
    echo 'Usage: docker-purge-image.sh <docker-image-name>'
    echo ''
    exit 1
fi

export IMAGE_NAME=$1

# Commands
if [[ $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w $IMAGE_NAME | awk '{ print $1 }' | wc -l) != 0 ]] ; then
	# Stop all containers based on image
	docker stop $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w $IMAGE_NAME | awk '{ print $1 }')
	
	# Remove all containers based on image
	docker rm $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w $IMAGE_NAME | awk '{ print $1 }')
fi
	
# Remove image
docker rmi $IMAGE_NAME
