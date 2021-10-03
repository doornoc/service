FROM alpine:latest

RUN apk add --no-cache --upgrade freeradius freeradius-ldap freeradius-radclient

WORKDIR /etc/raddb/
COPY ./root/etc/raddb/mods-available/ldap ./mods-available/ldap
COPY ./root/etc/raddb/sites-enabled/default ./sites-enabled/default
COPY ./root/etc/raddb/clients.conf .
COPY ./root/etc/raddb/dictionary .
COPY ./root/etc/raddb/users .
COPY ./docker-entrypoint.sh .

ENTRYPOINT [ "sh","./docker-entrypoint.sh" ]
