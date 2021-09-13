FROM node:14-buster-slim

ARG BUILD_DATE="2021/09/14"
ARG VERSION="0.1"
ARG HEDGEDOC_RELEASE="1.8.2"
LABEL build_version="doornoc.net version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="yoneyan"

RUN \
    echo "**** install build packages ****" && \
    apt-get update && \
    apt-get install -y g++ gcc git gnupg jq libssl-dev make curl fontconfig fonts-noto netcat-openbsd python
RUN  curl -o \
    /tmp/hedgedoc.tar.gz -L \
    "https://github.com/hedgedoc/hedgedoc/releases/download/${HEDGEDOC_RELEASE}/hedgedoc-${HEDGEDOC_RELEASE}.tar.gz" && \
    mkdir -p \
    /opt/hedgedoc && \
    tar xf /tmp/hedgedoc.tar.gz -C \
    /opt/hedgedoc --strip-components=1 && \
    cd /opt/hedgedoc && \
    bin/setup && \
    echo "**** cleanup ****" && \
    yarn cache clean && \
    apt-get -y purge g++ gcc git gnupg jq libssl-dev make curl &&\
    apt-get -y autoremove && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add local files
COPY config.json /opt/hedgedoc/config.json
COPY docker-entrypoint.sh /opt/hedgedoc/docker-entrypoint.sh

RUN echo '<script src="<%= process.env.GROWI_URI %>/_hackmd/load-styles"></script>' >> /opt/hedgedoc/public/views/hedgedoc/head.ejs && \
    echo '<script src="<%= process.env.GROWI_URI %>/_hackmd/load-agent" defer></script>' >> /opt/hedgedoc/public/views/hedgedoc/foot.ejs

# ports and volumes
EXPOSE 3000
ENTRYPOINT ["/opt/hedgedoc/docker-entrypoint.sh"]
