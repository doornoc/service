FROM openjdk:11.0.12-jre-slim-bullseye

ARG UID=${UID}
ARG GID=${GID}


RUN groupadd -g ${GID} elasticsearch
RUN useradd -u ${UID} -g ${GID} -s /bin/bash -m elasticsearch

# install elasticsearch
RUN apt update && apt install -y wget gnupg gnupg2
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-6.x.list
RUN apt update && apt install -y elasticsearch 

RUN echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml \
    && echo "discovery.type: single-node" >> /etc/elasticsearch/elasticsearch.yml \
    && echo "xpack.ml.enabled: false" >> /etc/elasticsearch/elasticsearch.yml \
    && sed -i "/path.data/d" /etc/elasticsearch/elasticsearch.yml \
    && echo "path.data: /data" >> /etc/elasticsearch/elasticsearch.yml
RUN sed "s/Xms1g/Xms256m/" /etc/elasticsearch/jvm.options > /etc/elasticsearch/jvm.options \
    && sed "s/Xmx1g/Xmx256m/" /etc/elasticsearch/jvm.options > /etc/elasticsearch/jvm.options

# install plugin
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
RUN mkdir /data
RUN chown -R ${UID}:${GID} /data

RUN apt remove -y wget gnupg gnupg2

USER elasticsearch
CMD [ "/usr/share/elasticsearch/bin/elasticsearch" ]