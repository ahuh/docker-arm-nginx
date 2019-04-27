# Docker ARM NGINX
Docker image (ARMv7) hosting a NGINX server to secure SickChill, Transmission and qBittorrent. For each application, an HTTPS proxy is provided, with basic authentication (login / password).<br />
<br />
This project is based on an existing project, modified to work on ARMv7 WD My Cloud EX2 Ultra NAS.<br />
See GitHub repository: https://github.com/haugene/docker-transmission-openvpn<br />
<br />
This image is part of a Docker images collection, intended to build a full-featured seedbox, and compatible with WD My Cloud EX2 Ultra NAS (Docker v1.7.0):

Docker Image | GitHub repository | Docker Hub repository
------------ | ----------------- | -----------------
Docker image (ARMv7) hosting a Transmission torrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-transquidvpn | https://hub.docker.com/r/ahuh/arm-transquidvpn
Docker image (ARMv7) hosting a qBittorrent client with WebUI while connecting to OpenVPN | https://github.com/ahuh/docker-arm-qbittorrentvpn | https://hub.docker.com/r/ahuh/arm-qbittorrentvpn
Docker image (ARMv7) hosting SubZero with MKVMerge (subtitle autodownloader for TV shows) | https://github.com/ahuh/docker-arm-subzero | https://hub.docker.com/r/ahuh/arm-subzero
Docker image (ARMv7) hosting a SickChill server with WebUI | https://github.com/ahuh/docker-arm-sickchill | https://hub.docker.com/r/ahuh/arm-sickchill
Docker image (ARMv7) hosting a Jackett server with WebUI | https://github.com/ahuh/docker-arm-jackett | https://hub.docker.com/r/ahuh/arm-jackett
Docker image (ARMv7) hosting a NGINX server to secure SickChill, Transmission and qBittorrent | https://github.com/ahuh/docker-arm-nginx | https://hub.docker.com/r/ahuh/arm-nginx

## Installation

### Preparation
Before running container, you have to retrieve UID and GID for the user used to mount your tv shows directory:
* Get user UID:
```
$ id -u <user>
```
* Get user GID:
```
$ id -g <user>
```
The container will run impersonated as this user, in order to have read/write access to the tv shows directory.

### Run container in background
```
$ docker run --name nginx --restart=always \
		--add-host=dockerhost:<docker host IP> \
		--dns=<ip of dns #1> --dns=<ip of dns #2> \
		-d \
		-p <secured SickChill port to provide>:44481 \
		-p <secured qBittorrent port to provide>:44482 \
		-p <secured Transmission port to provide>:44491 \
		-v <path to NGINX configuration dir>:/config \
		-v <path to NGINX logs dir>:/logdir \
		-v <path to SSL cert and key files>:/ssldir \
		-v /etc/localtime:/etc/localtime:ro \
		-e "AUTHENTICATION_LOGIN=<login for authentication>" \
		-e "AUTHENTICATION_PASSWORD=<password for authentication>" \
		-e "SICKCHILL_PORT=<SickChill port to secure (leave empty to disable)>" \
		-e "QBITTORRENT_PORT=<qBittorrent port to secure (leave empty to disable)>" \
		-e "TRANSMISSION_PORT=<Transmission port to secure (leave empty to disable)>" \
		-e "SSL_CERT_FILE=<SSL cert file name>" \
		-e "SSL_KEY_FILE=<SSL key file name>" \
		-e "PUID=<user uid>" \
		-e "PGID=<user gid>" \
		ahuh/arm-nginx
```
or
```
$ ./docker-run.sh nginx ahuh/arm-nginx
```
(set parameters in `docker-run.sh` before launch, and generate a `docker-params.sh` to store secret OpenVPN parameters, as described in `docker-run.sh`)

### Configure NGINX
The container will use volumes directories to access SSL certificates, and to store logs and configuration files.<br />
<br />
You have to create these volume directories with the PUID/PGID user permissions, before launching the container:
```
/config
/logdir
/ssldir
```

The container will automatically create a `nginx.conf` file in the NGINX configuration dir.<br />
* WARNING : the `nginx.conf` file will be overwritten automatically at each start. Do not modify it: change parameters in `docker-run.sh` and `docker-params.sh` instead, and recreate the container.
* You have to generate a pair of SSL certificate files (.crt and .key) and store them in the `/ssldir` dir before starting the container.

## HOW-TOs

### Get a new instance of bash in running container
Use this command instead of `docker attach` if you want to interact with the container while it's running:
```
$ docker exec -it nginx /bin/bash
```
or
```
$ ./docker-bash.sh nginx
```

### Build image
```
$ docker build -t arm-nginx .
```
or
```
$ ./docker-build.sh arm-nginx
```
