#!/bin/sh

# =======================================================================================
# Run Docker container
#
# The container is launched in background as a daemon. It is configured to restart
# automatically, even after host OS restart, unless it is stopped manually with the
# 'docker stop' command 
# =======================================================================================

# ------------------------------------------------------
# Custom parameters

# Add a 'docker-params.sh' file to set the following variables:
# export E_AUTHENTICATION_LOGIN=XXX
# export E_AUTHENTICATION_PASSWORD=XXX
. docker-params.sh

export DOCKERHOST=$(ip route | grep docker | awk '{print $NF}')
export DNS_1=8.8.8.8
export DNS_2=8.8.4.4

export V_CONFIG=/shares/P2P/tools/nginx
export V_LOG_DIR=/shares/P2P/tools/nginx/logs
export V_SSL_DIR=/shares/P2P/tools/ssl

export P_SSL_SICKCHILL_PORT=44481
export P_SSL_QBITTORRENT_PORT=44482
export P_SSL_JACKETT_PORT=44483
export P_SSL_TRANSMISSION_PORT=44491

# Comment source port var to remove NGINX configuration for this web app
export E_SICKCHILL_PORT=8081
export E_TRANSMISSION_PORT=9091
export E_JACKETT_PORT=9117
#export E_QBITTORRENT_PORT=8082

export E_SSL_CERT_FILE=ahuh.crt
export E_SSL_KEY_FILE=ahuh.key
export E_PUID=500
export E_PGID=1000

# ------------------------------------------------------
# Common parameters

export CONTAINER_NAME=nginx
export IMAGE_NAME_1=arm-nginx
export IMAGE_NAME_2=ahuh/arm-nginx
export IMAGE_NAME=

if [[ "$1" = "h" ]] || [[ "$1" = "help" ]] || [[ "$1" = "-h" ]] || [[ "$1" = "-help" ]] || [[ "$1" = "--h" ]] || [[ "$1" = "--help" ]]; then
    echo 'Run a Docker container.'
    echo ''
    echo 'Usage:'    
    echo '  docker-run.sh [CONTAINER_NAME] [IMAGE_NAME]'
    echo '  docker-run.sh h | help | -h | -help | --h | --help'
    echo ''
    echo 'Options:'
    echo "  CONTAINER_NAME  Name of the container [default: ${CONTAINER_NAME}]"
    echo "  IMAGE_NAME      Name of the image [default: ${IMAGE_NAME_1} (if exists), ${IMAGE_NAME_2} (otherwise)]"
    echo ''
    exit 1
fi

if [[ $1 ]]; then
	CONTAINER_NAME=$1
else
	echo "Using default container name: ${CONTAINER_NAME}"
fi
if [[ $2 ]]; then
	IMAGE_NAME=$2
else
	if [[ $(docker images | awk '{ print $1,$3 }' | grep -E "^${IMAGE_NAME_1}\s" | wc -l) != 0 ]] ; then
		IMAGE_NAME=${IMAGE_NAME_1}
	else
		IMAGE_NAME=${IMAGE_NAME_2}
	fi
	echo "Using default image name: ${IMAGE_NAME}"
fi

# ------------------------------------------------------
# Common commands

if [[ $(docker ps -f name=${CONTAINER_NAME} -f status=running | grep ${CONTAINER_NAME} | wc -l) != 0 ]] ; then
	# Container already running: stop it
	echo "Stop running container: ${CONTAINER_NAME}"
	docker stop ${CONTAINER_NAME}
	RESULT=$?
	if [[ ${RESULT} != 0 ]] ; then
		exit 1
	fi
fi

if [[ $(docker ps -a -f name=${CONTAINER_NAME} | grep ${CONTAINER_NAME} | wc -l) != 0 ]] ; then
	# Container already exists: remove it
	echo "Remove existing container: ${CONTAINER_NAME}"
	docker rm ${CONTAINER_NAME}
	RESULT=$?
	if [[ ${RESULT} != 0 ]] ; then
		exit 1
	fi
fi

# ------------------------------------------------------
# Custom commands

echo "Run container: ${CONTAINER_NAME}"
docker run --name ${CONTAINER_NAME} --restart=always --add-host=dockerhost:${DOCKERHOST} --dns=${DNS_1} --dns=${DNS_2} -d -p ${P_SSL_SICKCHILL_PORT}:44481 -p ${P_SSL_QBITTORRENT_PORT}:44482 -p ${P_SSL_JACKETT_PORT}:44483 -p ${P_SSL_TRANSMISSION_PORT}:44491 -v ${V_CONFIG}:/config -v ${V_LOG_DIR}:/logdir -v ${V_SSL_DIR}:/ssldir -v /etc/localtime:/etc/localtime:ro -e "AUTHENTICATION_LOGIN=${E_AUTHENTICATION_LOGIN}" -e "AUTHENTICATION_PASSWORD=${E_AUTHENTICATION_PASSWORD}" -e "SICKCHILL_PORT=${E_SICKCHILL_PORT}" -e "QBITTORRENT_PORT=${E_QBITTORRENT_PORT}" -e "JACKETT_PORT=${E_JACKETT_PORT}" -e "TRANSMISSION_PORT=${E_TRANSMISSION_PORT}" -e "SSL_CERT_FILE=${E_SSL_CERT_FILE}" -e "SSL_KEY_FILE=${E_SSL_KEY_FILE}" -e "PUID=${E_PUID}" -e "PGID=${E_PGID}" ${IMAGE_NAME}
