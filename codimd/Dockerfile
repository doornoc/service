FROM node:11-alpine as builder

RUN mkdir /app
WORKDIR /
RUN apk update && \
    apk add git
RUN git clone https://github.com/hackmdio/codimd -b 2.4.1 app
WORKDIR /app
COPY ./config.json .
RUN cp .sequelizerc.example .sequelizerc && \
    echo '<script src="<%= process.env.GROWI_URI %>/_hackmd/load-styles"></script>' >> /app/public/views/codimd/head.ejs && \
    echo '<script src="<%= process.env.GROWI_URI %>/_hackmd/load-agent" defer></script>' >> /app/public/views/codimd/foot.ejs && \
    sed -i -e 's/CodiMD</doornocMD</' /app/public/views/index/body.ejs
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
