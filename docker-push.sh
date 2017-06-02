#!/bin/sh

# =======================================================================================
# Push image in Docker Hub
#
# This script runs a login to Docker Hub, adds a tag to the local image, and pushes the
# image online
# =======================================================================================

# Parameters
if [[ $# != 2 ]] ; then
    echo ''
    echo 'Usage: docker-push.sh <docker-hub-username> <docker-image-name>'
    echo ''
    exit 1
fi

export DOCKER_ID_USER=$1
export IMAGE_NAME=$2

# Commands
docker login
RESULT=$?
if [[ $RESULT != 0 ]] ; then
	exit 1
fi

docker tag -f $IMAGE_NAME $DOCKER_ID_USER/$IMAGE_NAME
RESULT=$?
if [[ $RESULT != 0 ]] ; then
	exit 1
fi

docker push $DOCKER_ID_USER/$IMAGE_NAME
RESULT=$?
if [[ $RESULT != 0 ]] ; then
	exit 1
fi
