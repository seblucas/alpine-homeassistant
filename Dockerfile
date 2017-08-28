FROM seblucas/alpine-python3:3.6.1
MAINTAINER Sebastien Lucas <sebastien@slucas.fr>
LABEL Description="Home Assistant"

RUN mkdir /data && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev && \
    pip3 install --no-cache-dir homeassistant==0.50.2 && \
    pip3 install --no-cache-dir sqlalchemy==1.1.12 distro==1.0.4 aiohttp_cors==0.5.3 jsonrpc-async==0.6 samsungctl==0.6.0 pychromecast==0.8.2 paho-mqtt==1.3.0 rxv==0.4.0 jsonrpc-websocket==0.5 wakeonlan==0.2.2 websocket-client==0.37.0 && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

