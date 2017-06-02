#!/bin/sh

. /etc/sickrage/userSetup.sh

echo "PREPARING NGINX CONFIG"
. /etc/nginx/prepareConfig.sh

echo "STARTING NGINX"
nginx -c ${NGINX_CONFIG_FILE}