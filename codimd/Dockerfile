FROM node:11-alpine as builder

RUN mkdir /app
WORKDIR /
RUN apk update && \
    apk add git
RUN git clone https://github.com/hackmdio/codimd -b 2.4.1 app
WORKDIR /app
RUN npm install && \
    npm run build

FROM node:11-alpine

WORKDIR /app
COPY --from=builder /app .
COPY ./docker-entrypoint.sh .
RUN npm install --production && \
    npm cache clean --force && \
    rm -rf /tmp/{core-js-banners,phantomjs}
EXPOSE 3000
ENTRYPOINT ["/app/docker-entrypoint.sh"]
