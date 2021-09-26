FROM node:14-alpine
WORKDIR /opt

RUN apk --no-cache --virtual .del add curl git python make g++ wget openssl

RUN git clone https://github.com/weseek/growi -b v4.4.6 growi

WORKDIR /opt/growi

RUN npx lerna bootstrap

RUN yarn app:build

RUN apk del .del

RUN apk add tini su-exec

COPY docker-entrypoint.sh .
RUN chmod 700 docker-entrypoint.sh

VOLUME data
EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "-e", "143", "--", "docker-entrypoint.sh"]
CMD ["yarn", "app:server"]