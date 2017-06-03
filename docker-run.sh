#!/bin/sh

# =======================================================================================
# Run Docker container
#
# The container is launched in background as a daemon. It is configured to restart
# automatically, even after host OS restart, unless it is stopped manually with the
# 'docker stop' command 
# =======================================================================================

# Parameters

# Add a 'docker-params.sh' file to set the following variables:
# export E_AUTHENTICATION_LOGIN=XXX
# export E_AUTHENTICATION_PASSWORD=XXX
. docker-params.sh

export V_CONFIG=/shares/P2P/tools/nginx
export V_LOG_DIR=/shares/P2P/tools/nginx/logs
export V_SSL_DIR=/shares/P2P/tools/ssl

# Comment link var to remove docker link for this container
export L_SICKRAGE=" --link=sickrage:sickrage"
export L_TRANSMISSION=" --link=transmission:transmission"
#export L_QBITTORRENT=" --link=qbittorrent:qbittorrent"

# Comment source port var to remove NGINX configuration for this web app
export E_SICKRAGE_PORT=8081
export E_TRANSMISSION_PORT=9091
#export E_QBITTORRENT_PORT=8082
 
export P_SSL_SICKRAGE_PORT=44481
export P_SSL_QBITTORRENT_PORT=44482
export P_SSL_TRANSMISSION_PORT=44491

export E_SSL_CERT_FILE=ahuh.crt
export E_SSL_KEY_FILE=ahuh.key

export E_PUID=500
export E_PGID=1000

if [[ $# != 2 ]] ; then
    echo ''
    echo 'Usage: docker-run.sh <docker-container-name> <docker-image-name>'
    echo ''
    exit 1
fi

export CONTAINER_NAME=$1
export IMAGE_NAME=$2

# Commands
docker run --name ${CONTAINER_NAME} --restart=always${L_SICKRAGE}${L_TRANSMISSION}${L_QBITTORRENT} -d -p ${P_SSL_SICKRAGE_PORT}:44481 -p ${P_SSL_QBITTORRENT_PORT}:44482 -p ${P_SSL_TRANSMISSION_PORT}:44491 -v ${V_CONFIG}:/config -v ${V_LOG_DIR}:/logdir -v ${V_SSL_DIR}:/ssldir -v /etc/localtime:/etc/localtime:ro -e "AUTHENTICATION_LOGIN=${E_AUTHENTICATION_LOGIN}" -e "AUTHENTICATION_PASSWORD=${E_AUTHENTICATION_PASSWORD}" -e "SICKRAGE_PORT=${E_SICKRAGE_PORT}" -e "QBITTORRENT_PORT=${E_QBITTORRENT_PORT}" -e "TRANSMISSION_PORT=${E_TRANSMISSION_PORT}" -e "SSL_CERT_FILE=${E_SSL_CERT_FILE}" -e "SSL_KEY_FILE=${E_SSL_KEY_FILE}" -e "PUID=${E_PUID}" -e "PGID=${E_PGID}" ${IMAGE_NAME}
