FROM alpine:latest
LABEL maintainer="Sebastien Lucas <sebastien@slucas.fr>"
LABEL Description="Home Assistant"

ARG TIMEZONE=Europe/Paris
ARG UID=1000
ARG GUID=1000
ARG MAKEFLAGS=-j4
ARG VERSION=0.79.1
ARG PLUGINS="frontend|otp|QR|sqlalchemy|netdisco|distro|xmltodict|mutagen|warrant|hue|xiaomi|fritz|hole|http|google|psutil|weather|musiccast|nmap|webpush|unifi|uptimerobot|speedtest|rxv|gTTS|wakeonlan|websocket|paho-mqtt"

ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt" /tmp

RUN apk add --no-cache git python3 ca-certificates libffi-dev libressl-dev nmap ffmpeg mariadb-client mariadb-connector-c-dev && \
    chmod u+s /bin/ping && \
    addgroup -g ${GUID} hass && \
    adduser -h /data -D -G hass -s /bin/sh -u ${UID} hass && \
    pip3 install --upgrade --no-cache-dir pip && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev tzdata && \
    cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && echo "${TIMEZONE}" > /etc/timezone && \
    sed '/^$/q' /tmp/requirements_all.txt > /tmp/requirements_core.txt && \
    sed '1,/^$/d' /tmp/requirements_all.txt > /tmp/requirements_plugins.txt && \
    egrep -e "${PLUGINS}" /tmp/requirements_plugins.txt | grep -v '#' > /tmp/requirements_plugins_filtered.txt && \
    pip3 install --no-cache-dir -r /tmp/requirements_core.txt && \
    pip3 install --no-cache-dir -r /tmp/requirements_plugins_filtered.txt && \
    pip3 install --no-cache-dir mysqlclient && \
    pip3 install --no-cache-dir homeassistant=="${VERSION}" && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]
