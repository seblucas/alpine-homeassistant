FROM seblucas/alpine-python3:1.1
MAINTAINER Sebastien Lucas <sebastien@slucas.fr>
LABEL Description="Home Assistant"

RUN mkdir /data && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev && \
    pip install --no-cache-dir --trusted-host https://pypi.python.org homeassistant==0.45.1 && \
    pip install --no-cache-dir --trusted-host https://pypi.python.org sqlalchemy==1.1.9 distro==1.0.4 aiohttp_cors==0.5.3 jsonrpc-async==0.6 samsungctl==0.6.0 pychromecast==0.8.1 paho-mqtt==1.2.3 rxv==0.4.0 jsonrpc-websocket==0.5 wakeonlan==0.2.2 websocket-client && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

