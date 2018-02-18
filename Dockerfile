FROM alpine:3.7
LABEL maintainer="Sebastien Lucas <sebastien@slucas.fr>"
LABEL Description="Home Assistant"

ARG TIMEZONE=Europe/Paris
ARG UID=1000
ARG GUID=1000

RUN apk add --no-cache git python3 ca-certificates glib && \
    addgroup -g ${GUID} hass && \
    adduser -h /data -D -G hass -s /bin/sh -u ${UID} hass && \
    pip3 install --upgrade --no-cache-dir pip && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev tzdata glib-dev && \
    cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && echo "${TIMEZONE}" > /etc/timezone && \
    pip3 install --no-cache-dir homeassistant==0.62.1 && \
    pip3 install --no-cache-dir home-assistant-frontend==20180130.0 user-agents==1.1.0 \
        sqlalchemy==1.2.1 distro==1.2.0 aiohttp_cors==0.6.0 jsonrpc-async==0.6 samsungctl==0.6.0 \
        pychromecast==1.0.3 paho-mqtt==1.3.1 rxv==0.5.1 jsonrpc-websocket==0.5 wakeonlan==0.2.2 \
        websocket-client==0.37.0 bluepy==1.1.4 warrant==0.6.1 && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

