#! /bin/bash

# Import template function
. /etc/common/template.sh

# Prepare password file
NGINX_HTPASSWD_FILE=/etc/nginx/.htpasswd
echo "${AUTHENTICATION_PASSWORD}" | htpasswd -i -c ${NGINX_HTPASSWD_FILE} ${AUTHENTICATION_LOGIN}
chown ${RUN_AS}:${RUN_AS} ${NGINX_HTPASSWD_FILE}
export NGINX_HTPASSWD_FILE

# Prepare log files
NGINX_LOG_ACCESS_FILE=/logdir/access.log
NGINX_LOG_ERROR_FILE=/logdir/error.log
touch ${NGINX_LOG_ACCESS_FILE}
touch ${NGINX_LOG_ERROR_FILE}
chown ${RUN_AS}:${RUN_AS} ${NGINX_LOG_ACCESS_FILE}
chown ${RUN_AS}:${RUN_AS} ${NGINX_LOG_ERROR_FILE}
export NGINX_LOG_ACCESS_FILE
export NGINX_LOG_ERROR_FILE

# Prepare config file
NGINX_CONFIG_FILE=/config/nginx.conf
CS=
CT=
CQ=
if [[ ! "${L_SICKRAGE}" ]]; then
	# No SickRage port specified in env var: disable SickRage in NGINX
	CS=#
fi
if [[ ! "${L_TRANSMISSION}" ]]; then
	# No Transmission port specified in env var: disable Transmission in NGINX
	CT=#
fi
if [[ ! "${L_QBITTORRENT}" ]]; then
	# No qBittorrent port specified in env var: disable qBittorrent in NGINX
	CQ=#
fi
template /etc/nginx/nginx.conf.tmpl > ${NGINX_CONFIG_FILE}
chown ${RUN_AS}:${RUN_AS} ${NGINX_CONFIG_FILE}

export NGINX_CONFIG_FILE
