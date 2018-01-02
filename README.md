# Home Assistant Docker Image

## Description

Small docker image with [home assistant](https://home-assistant.io/) based on [Alpine Linux](https://hub.docker.com/_/alpine/).

This image is available for many architectures : Amd64 and Armhf (and soon Arm64)

## Usage

```
docker run -d --name homeassistant -p 80:8123 seblucas/alpine-homeassistant:latest
```

### Configuration

It's recommended to map a directory into the container to configure home assistant. 
For now this container run as root

```
-v /var/opt/docker/homeassistant:/data \
```
 
## License
This project is licensed under `GPLv2`.
