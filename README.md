# Home Assistant Docker Image

## Description

[![Docker cloud build](https://img.shields.io/docker/cloud/build/kurapov/alpine-homeassistant?logo=docker&logoColor=white)](https://hub.docker.com/r/kurapov/alpine-homeassistant/builds)

Small docker image with [home assistant](https://home-assistant.io/) based on [Alpine Linux](https://hub.docker.com/_/alpine/).

This image should be available (unless a problem happened on my side) for the following architectures :
 * amd64
 * armhf
 * arm64

I'm using a proper manifest so you can use the main tags directly (no need for amd64-X.X.X).

If you want to learn more about multi-architecture docker images, please read [my blog](https://blog.slucas.fr/series/multi-architecture-docker-image/)

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

### Plugins

Please check the [Dockerfile](Dockerfile) for the list on dependencies embedded. any other will be downloaded automatically by Home Assistant.

### Customizing this image

You can easily use this image as a base and build your own with additionnal plugins. For example with this `Dockerfile` you use my image as a base and add Homekit plugin, change user & group ID of `hass` user and modify an ENTRYPOINT :

```
FROM seblucas/alpine-homeassistant:latest

ARG UID="1001"
ARG GUID="1001"
ARG PLUGINS="HAP-python"

RUN apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev shadow && \
    egrep -e "${PLUGINS}" /requirements_plugins.txt | grep -v '#' > /tmp/requirements_plugins_filtered.txt && \
    pip3 install --no-cache-dir -r /tmp/requirements_plugins_filtered.txt && \
    usermod -u ${UID} hass && groupmod -g ${GUID} hass && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 51827

ENTRYPOINT ["hass", "--config=/data"]
```

The only thing you have to change is the content of `PLUGINS` and add your plugins separated by `|`. Depending on your plugin complexity you may even skip the compiler / headers installation.

## License
This project is licensed under `GPLv2`.
