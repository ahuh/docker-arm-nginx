#!/bin/sh

# =======================================================================================
# Purge Docker image
#
# This script stops and removes all container based on the Docker image, before removing
# the Docker image itself
# =======================================================================================

# ------------------------------------------------------
# Common parameters

export IMAGE_NAME=arm-nginx

if [[ "$1" = "h" ]] || [[ "$1" = "help" ]] || [[ "$1" = "-h" ]] || [[ "$1" = "-help" ]] || [[ "$1" = "--h" ]] || [[ "$1" = "--help" ]]; then
    echo 'Remove a Docker image with all its Docker containers (automatically stops and removes them).'
    echo ''
    echo 'Usage:'    
    echo '  docker-purge-image.sh [IMAGE_NAME]'
    echo '  docker-purge-image.sh h | help | -h | -help | --h | --help'
    echo ''
    echo 'Options:'
    echo "  IMAGE_NAME   Name of the image [default: ${IMAGE_NAME}]"  
    echo ''
    exit 1
fi

if [[ $1 ]]; then
	IMAGE_NAME=$1
else
	echo "Using default image name: ${IMAGE_NAME}"
fi

# ------------------------------------------------------
# Commands

if [[ $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w ${IMAGE_NAME} | awk '{ print $1 }' | wc -l) != 0 ]] ; then
	# Stop all containers based on image
	echo "Stop all containers based on image"
	docker stop $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w ${IMAGE_NAME} | awk '{ print $1 }')
	RESULT=$?
	if [[ ${RESULT} != 0 ]] ; then
		exit 1
	fi
	
	# Remove all containers based on image
	echo "Remove all containers based on image"
	docker rm $(docker ps -a --no-trunc | awk '{ print $1,$2 }' | grep -w ${IMAGE_NAME} | awk '{ print $1 }')
	RESULT=$?
	if [[ ${RESULT} != 0 ]] ; then
		exit 1
	fi
fi
	
# Remove image
echo "Remove image: ${IMAGE_NAME}"
docker rmi ${IMAGE_NAME}
