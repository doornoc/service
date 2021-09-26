## [参考] https://qiita.com/temple1026/items/6a70e372d7ce70ad59ee
FROM arm64v8/openjdk:8-alpine

ENV ES_HOME=/opt/elasticsearch
ENV VER_ELASTICSEARCH 6.8.18

WORKDIR /opt
RUN apk add --no-cache --virtual .del wget bash \
    && wget --no-check-certificate https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VER_ELASTICSEARCH}.tar.gz \
    && tar xvzf elasticsearch-${VER_ELASTICSEARCH}.tar.gz \
    && mv elasticsearch-${VER_ELASTICSEARCH} ${ES_HOME} \
    && rm elasticsearch-${VER_ELASTICSEARCH}.tar.gz
RUN echo "network.host: 0.0.0.0" >> ${ES_HOME}/config/elasticsearch.yml \
   && echo "discovery.type: single-node" >> ${ES_HOME}/config/elasticsearch.yml \
   && echo "xpack.ml.enabled: false" >> ${ES_HOME}/config/elasticsearch.yml
RUN sed "s/Xms1g/Xms256m/" ${ES_HOME}/config/jvm.options > ${ES_HOME}/config/jvm.options \
    && sed "s/Xmx1g/Xmx256m/" ${ES_HOME}/config/jvm.options > ${ES_HOME}/config/jvm.options

RUN adduser -D elasticsearch -h ${ES_HOME}
RUN mkdir ${ES_HOME}/data
RUN chown -R elasticsearch:elasticsearch ${ES_HOME}/*

USER elasticsearch
ENV PATH="${PATH}:${ES_HOME}/bin/"

WORKDIR ${ES_HOME}
RUN sh bin/elasticsearch-plugin install analysis-kuromoji
RUN sh bin/elasticsearch-plugin install analysis-icu

USER root
RUN apk del .del

USER elasticsearch
WORKDIR ${ES_HOME}