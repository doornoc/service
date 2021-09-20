FROM alpine:latest

RUN apk add --no-cache --upgrade openldap openldap-clients openldap-backend-all openldap-overlay-all openssl cyrus-sasl

WORKDIR /etc/openldap
COPY ./slapd.conf .
COPY ./ldif/manager.ldif .
COPY ./ldif/operator.ldif .
COPY ./ldif/syncprov.ldif .
COPY ./ldif/master.ldif .
COPY ./docker-entrypoint.sh .

RUN mkdir /var/lib/openldap/run

ENTRYPOINT [ "sh","./docker-entrypoint.sh" ]
