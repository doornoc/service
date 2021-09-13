FROM node:14-alpine
WORKDIR /opt

RUN apk --no-cache --virtual .del add curl git python make g++ wget openssl

RUN git clone https://github.com/weseek/growi -b v4.4.2 growi
WORKDIR /opt/growi

RUN yarn --network-timeout 1000000

RUN npm run build:prod

RUN apk del .del
EXPOSE 3000
ENTRYPOINT ["npm","run","server:prod"]
