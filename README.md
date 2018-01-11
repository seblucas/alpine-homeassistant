# Home Assistant Docker Image

## Description

Small docker image with [home assistant](https://home-assistant.io/) based on [Alpine Linux](https://hub.docker.com/_/alpine/).

This image should be available (unless a problem happened on my side) for the following architectures :
 * amd64
 * armhf
 * arm64

I'm using a proper manifest so you can use the main tags directly (no need for amd64-X.X.X)

## Usage

```
docker run -d --name homeassistant -p 80:8123 seblucas/alpine-homeassistant:latest
```

### Configuration

It's recommended to map a directory into the container to configure home assistant.

```
-v /var/opt/docker/homeassistant:/data \
```

By default this container run as root but there is an embedded user with uid 1000 so you can start your image like that :

```
docker run -it --user 1000 --rm -v /var/opt/docker/homeassistant:/data seblucas/alpine-homeassistant
```

Of course you need to have a local user with uid 1000.

## License
This project is licensed under `GPLv2`.
