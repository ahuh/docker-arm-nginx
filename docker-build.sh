#!/bin/sh

# =======================================================================================
# Build Docker image
#
# This scripts builds the Docker image for ARMv7 processors
# =======================================================================================

# ------------------------------------------------------
# Common parameters

export IMAGE_NAME=arm-nginx

if [[ "$1" = "h" ]] || [[ "$1" = "help" ]] || [[ "$1" = "-h" ]] || [[ "$1" = "-help" ]] || [[ "$1" = "--h" ]] || [[ "$1" = "--help" ]]; then
    echo 'Build a Docker image.'
    echo ''
    echo 'Usage:'    
    echo '  docker-build.sh [IMAGE_NAME]'
    echo '  docker-build.sh h | help | -h | -help | --h | --help'
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

echo "Build image: ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .
