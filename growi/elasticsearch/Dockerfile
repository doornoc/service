FROM openjdk:8-slim-buster

ARG UID=${UID}
ARG GID=${GID}

RUN groupadd -g ${GID} elasticsearch
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m elasticsearch

ENV ES_HOME=/opt/elasticsearch
ENV VER_ELASTICSEARCH 6.8.10

# install elasticsearch
# RUN apt update && apt install -y wget gnupg gnupg2
# RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
# RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
# RUN apt update && apt install -y elasticsearch 
RUN apt update && apt install -y wget bash
WORKDIR /opt
RUN wget --no-check-certificate https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VER_ELASTICSEARCH}.tar.gz \
    && tar xvzf elasticsearch-${VER_ELASTICSEARCH}.tar.gz \
    && mv elasticsearch-${VER_ELASTICSEARCH} ${ES_HOME} \
    && rm elasticsearch-${VER_ELASTICSEARCH}.tar.gz



RUN echo "network.host: 0.0.0.0" >> ${ES_HOME}/elasticsearch.yml \
    && echo "discovery.type: single-node" >> ${ES_HOME}/elasticsearch.yml \
    && echo "xpack.ml.enabled: false" >> ${ES_HOME}/elasticsearch.yml \
    && sed -i "/path.data/d" ${ES_HOME}/elasticsearch.yml \
    && echo "path.data: /data" >> ${ES_HOME}/elasticsearch.yml
RUN sed "s/Xms1g/Xms256m/" ${ES_HOME}/jvm.options > ${ES_HOME}/jvm.options \
    && sed "s/Xmx1g/Xmx256m/" ${ES_HOME}/jvm.options > ${ES_HOME}/jvm.options

RUN mkdir /data
RUN chown -R ${UID}:${GID} /data

WORKDIR ${ES_HOME}
RUN chown -R ${UID}:${GID} ${ES_HOME}


USER elasticsearch
RUN sh bin/elasticsearch-plugin install analysis-kuromoji
RUN sh bin/elasticsearch-plugin install analysis-icu

EXPOSE 9200 9300

CMD [ "bin/elasticsearch" ]