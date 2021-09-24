FROM node:14-alpine
WORKDIR /opt

RUN apk --no-cache --virtual .del add curl git python make g++ wget openssl

RUN git clone https://github.com/weseek/growi -b v4.4.5 growi
WORKDIR /opt/growi

RUN npx lerna bootstrap

RUN yarn app:build

RUN apk del .del
EXPOSE 3000
CMD ["yarn", "app:server"]
