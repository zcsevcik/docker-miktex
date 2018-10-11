FROM debian:stretch-slim

LABEL Description="Dockerized MiKTeX, Debian 9" Vendor="Radek Sevcik" Version="2.9.6850"

RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && apt-get install --no-install-recommends -y \
        apt-transport-https \
        gnupg && \        
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889 && \
    echo "deb http://miktex.org/download/debian stretch universe" | sudo tee /etc/apt/sources.list.d/miktex.list && \
    apt-get update && apt-get install --no-install-recommends -y \
        miktex \
        perl && \
    initexmf --admin --force --mklinks && \
    mpm --admin --install amsfonts && \
    initexmf --admin --mkmaps && \
    initexmf --admin --update-fndb && \
    useradd -md /miktex miktex && \
    mkdir /miktex/work && chown miktex /miktex/work && \
    mkdir /miktex/.miktex && chown miktex /miktex/.miktex
    
USER miktex
WORKDIR /miktex/work
