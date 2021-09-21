FROM alpine:latest

RUN apk add --no-cache --upgrade nginx phpldapadmin

WORKDIR /etc/phpldapadmin
COPY ./config/config.php .

ENTRYPOINT ["sh", "./docker-entrypoint.sh"]
