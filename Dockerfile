# NGINX
#
# Version 1.0

FROM resin/rpi-raspbian:jessie
LABEL maintainer "ahuh"

# Volume config: contains nginx.conf file (generated at each start)
VOLUME /config
# Volume logdir: contains nginx log files
VOLUME /logdir
# Volume ssldir: contains SSL certificate and key files to use for enabling HTTPS
VOLUME /ssldir
# Volume userhome: home directory for execution user
VOLUME /userhome

# Set environment variables
# - Set WebUIs ports, authentication login and password, certificates for enabling HTTPS, and execution user (PUID/PGID)
ENV SICKRAGE_PORT=\
	TRANSMISSION_PORT=\
	QBITTORRENT_PORT=\
	AUTHENTICATION_LOGIN=\
	AUTHENTICATION_PASSWORD=\
	SSL_CERT_FILE=\
	SSL_KEY_FILE=\
	PUID=\
    PGID=
# - Set xterm for nano and iftop
ENV TERM xterm

# Remove previous apt repos
RUN rm -rf /etc/apt/preferences.d* \
	&& mkdir /etc/apt/preferences.d \
	&& rm -rf /etc/apt/sources.list* \
	&& mkdir /etc/apt/sources.list.d \
	&& mkdir /root/tmp

# Copy custom bashrc to root (ll aliases)
COPY root/ /root/
# Copy apt config for jessie (stable) and stretch (testing) repos
COPY preferences.d/ /etc/apt/preferences.d/
COPY sources.list.d/ /etc/apt/sources.list.d/

# Update packages and install software
RUN apt-get update \
	&& apt-get install -y nano iftop \
	&& apt-get install -y ca-certificates nginx apache2-utils \
	&& apt-get install -y dumb-init -t stretch \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create and set user & group for impersonation
RUN groupmod -g 1000 users \
    && useradd -u 911 -U -d /userhome -s /bin/false abc \
    && usermod -G users abc
	
# Copy configuration and scripts
COPY common/ /etc/common/
COPY nginx/ /etc/nginx/

# Fix execution permissions after copy 
RUN chmod +x /etc/common/*.sh \
    && chmod +x /etc/nginx/*.sh

# Expose ports
EXPOSE 44482 44481 44491

# Launch NGINX at container start
CMD ["dumb-init", "/etc/nginx/start.sh"]
