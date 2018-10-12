FROM debian:stretch-slim

LABEL Description="Dockerized MiKTeX, Debian 9" Vendor="Radek Sevcik" Version="2.9.6840"

RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        dirmngr \
        && \        
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889 && \
    echo "deb http://ftp.cvut.cz/tex-archive/systems/win32/miktex/setup/deb/ stretch universe" | tee /etc/apt/sources.list.d/miktex.list && \
    apt-get update && apt-get install --no-install-recommends -y \
        miktex \
        perl \
        && \
    initexmf --admin --verbose --force --mklinks && \
    mpm --admin --verbose --install amsfonts || ( cat /var/log/miktex/mpmcli_admin.log; exit 1 ) && \
    initexmf --admin --verbose --mkmaps && \
    initexmf --admin --verbose --update-fndb && \
    useradd -md /miktex miktex && \
    mkdir /miktex/work && chown miktex /miktex/work && \
    mkdir /miktex/.miktex && chown miktex /miktex/.miktex && \
    apt-get clean && rm -fr /var/lib/apt/lists/*
    
USER miktex
WORKDIR /miktex/work
