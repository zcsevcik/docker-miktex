FROM debian:stretch-slim

LABEL Description="Dockerized MiKTeX, Debian 9" Vendor="Radek Sevcik" Version="2.9.6840"

RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        dirmngr \
        wget \
        build-essential \
        && \        
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889 && \
    echo "deb http://ftp.cvut.cz/tex-archive/systems/win32/miktex/setup/deb/ stretch universe" | tee /etc/apt/sources.list.d/miktex.list && \
    apt-get update && apt-get install --no-install-recommends -y \
        miktex \
        perl \
        && \
    initexmf --admin --verbose --force --mklinks && \
    mpm --admin --verbose --install=amsfonts || ( cat /var/log/miktex/mpmcli_admin.log; exit 1 ) && \
    initexmf --admin --verbose --mkmaps && \
    initexmf --admin --verbose --update-fndb && \
    useradd -md /miktex miktex && \
    mkdir /miktex/work && chown -R miktex /miktex/work && \
    mkdir /miktex/.miktex && chown -R miktex /miktex/.miktex && \
    su - miktex -c "mpm --verbose \
        --install=acronym \
        --install=arabi \
        --install=babel-czech \
        --install=babel-english \
        --install=beamer \
        --install=bigfoot \
        --install=cbfonts-fd \
        --install=cbgreek \
        --install=cmap \
        --install=dirtree \
        --install=ec \
        --install=enumitem \
        --install=eso-pic \
        --install=geometry-de \
        --install=geometry \
        --install=graphics-cfg \
        --install=graphics-def \
        --install=graphics \
        --install=greek-fontenc \
        --install=greek-inputenc \
        --install=hyperref \
        --install=ifxetex \
        --install=listings \
        --install=lm \
        --install=ltxbase \
        --install=mmap \
        --install=mptopdf \
        --install=oberdiek \ 
        --install=pdfpages \
        --install=sectsty \
        --install=tools \
        --install=url \
        --install=xcolor \
        --install=xstring \       
        || ( cat /var/log/miktex/mpmcli_admin.log; exit 1 )" && \
    wget -r --tries=10 http://ftp.linux.cz/pub/tex/local/cstug/olsak/vlna/vlna-1.5.tar.gz -O /tmp/vlna-1.5.tar.gz && \
    ( cd /tmp; tar xvf /tmp/vlna-1.5.tar.gz ) && \
    ( cd /tmp/vlna-1.5; ./configure --prefix=/usr && make && make install ) && \
    apt-get purge -y \
        apt-transport-https \
        gnupg \
        dirmngr \
        wget \
        build-essential \
        && \
    apt-get -y autoremove && \
    apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/*
    
USER miktex
WORKDIR /miktex/work
