FROM alpine:3.7
LABEL maintainer="Sebastien Lucas <sebastien@slucas.fr>"
LABEL Description="Home Assistant"

ARG TIMEZONE=Europe/Paris
ARG UID=1000
ARG GUID=1000

RUN apk add --no-cache git python3 ca-certificates && \
    addgroup -g ${GUID} hass && \
    adduser -h /data -D -G hass -s /bin/sh -u ${UID} hass && \
    pip3 install --upgrade --no-cache-dir pip && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev tzdata && \
    cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && echo "${TIMEZONE}" > /etc/timezone && \
    pip3 install --no-cache-dir homeassistant==0.59.2 && \
    pip3 install --no-cache-dir home-assistant-frontend==20171204.0 user-agents==1.1.0 sqlalchemy==1.1.15 distro==1.1.0 aiohttp_cors==0.5.3 jsonrpc-async==0.6 samsungctl==0.6.0 pychromecast==0.8.2 paho-mqtt==1.3.1 rxv==0.5.1 jsonrpc-websocket==0.5 wakeonlan==0.2.2 websocket-client==0.37.0 && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

