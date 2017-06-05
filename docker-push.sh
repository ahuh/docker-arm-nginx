#!/bin/sh

# =======================================================================================
# Push image in Docker Hub
#
# This script runs a login to Docker Hub, adds a tag to the local image, and pushes the
# image online
# =======================================================================================

# ------------------------------------------------------
# Common parameters

export IMAGE_NAME=arm-nginx

if [[ ! $1 ]] || [[ "$1" = "h" ]] || [[ "$1" = "help" ]] || [[ "$1" = "-h" ]] || [[ "$1" = "-help" ]] || [[ "$1" = "--h" ]] || [[ "$1" = "--help" ]]; then
    echo 'Push a Docker image to Docker Hub (with login and tagging).'
    echo ''
    echo 'Usage:'    
    echo '  docker-push.sh DOCKER_HUB_USERNAME [IMAGE_NAME]'
    echo '  docker-push.sh h | help | -h | -help | --h | --help'
    echo ''
    echo 'Options:'
    echo "  DOCKER_HUB_USERNAME  Login for Docker Hub"
    echo "  IMAGE_NAME           Name of the image [default: ${IMAGE_NAME}]"
    echo ''
    exit 1
fi

DOCKER_ID_USER=$1
if [[ $2 ]]; then
	IMAGE_NAME=$2
else
	echo "Using default image name: ${IMAGE_NAME}"
fi

# ------------------------------------------------------
# Commands

echo "Login to Docker Hub as user: ${DOCKER_ID_USER}"
docker login -u=${DOCKER_ID_USER}
RESULT=$?
if [[ ${RESULT} != 0 ]] ; then
	exit 1
fi

echo "Tag image: ${IMAGE_NAME}"
docker tag -f ${IMAGE_NAME} ${DOCKER_ID_USER}/${IMAGE_NAME}
RESULT=$?
if [[ ${RESULT} != 0 ]] ; then
	exit 1
fi

echo "Push image to: ${DOCKER_ID_USER}/${IMAGE_NAME}"
docker push ${DOCKER_ID_USER}/${IMAGE_NAME}
