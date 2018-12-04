FROM alpine:3.8
LABEL maintainer="Sebastien Lucas <sebastien@slucas.fr>"
LABEL Description="Home Assistant"

ARG TIMEZONE=Europe/Paris
ARG UID=1000
ARG GUID=1000
ARG MAKEFLAGS=-j4
ARG VERSION=0.83.3
ARG PLUGINS="frontend|pyotp|PyQRCode|sqlalchemy|distro|http|nmap|weather|uptimerobot|rxv|wakeonlan|websocket|paho-mqtt|samsungctl[websocket]|pychromecast|aiohttp_cors|jsonrpc-websocket|jsonrpc-async"

ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt" /tmp

RUN apk add --no-cache git python3 ca-certificates libffi-dev libressl-dev nmap iputils && \
    addgroup -g ${GUID} hass && \
    adduser -h /data -D -G hass -s /bin/sh -u ${UID} hass && \
    pip3 install --upgrade --no-cache-dir pip && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev tzdata && \
    cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && echo "${TIMEZONE}" > /etc/timezone && \
    sed '/^$/q' /tmp/requirements_all.txt > /tmp/requirements_core.txt && \
    sed '1,/^$/d' /tmp/requirements_all.txt > /requirements_plugins.txt && \
    egrep -e "${PLUGINS}" /requirements_plugins.txt | grep -v '#' > /tmp/requirements_plugins_filtered.txt && \
    pip3 install --no-cache-dir -r /tmp/requirements_core.txt && \
    pip3 install --no-cache-dir -r /tmp/requirements_plugins_filtered.txt && \
    pip3 install --no-cache-dir homeassistant=="${VERSION}" && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

