FROM seblucas/alpine-python3:1.1
MAINTAINER Sebastien Lucas <sebastien@slucas.fr>
LABEL Description="Home Assistant"

RUN mkdir /data && \
    apk add --no-cache --virtual=build-dependencies build-base linux-headers python3-dev && \
    pip install --no-cache-dir --trusted-host https://pypi.python.org homeassistant && \
    pip install --no-cache-dir --trusted-host https://pypi.python.org sqlalchemy==1.1.5 distro==1.0.2 aiohttp_cors==0.5.0 gTTS-token==1.1.1 astral==1.3.4 fuzzywuzzy==0.14.0 xmltodict==0.10.2 netdisco==0.8.2 jsonrpc-async==0.2 samsungctl==0.6.0 pychromecast==0.8.0 paho-mqtt==1.2 pwaqi==1.4 rxv==0.4.0 && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8123

VOLUME ["/data"]

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]

