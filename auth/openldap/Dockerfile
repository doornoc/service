FROM alpine:latest

RUN apk add --no-cache --upgrade openldap openldap-clients openldap-backend-all openldap-overlay-all
RUN wget -P /etc/openldap/schema https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/openssh-lpk/openssh-lpk_openldap.schema

WORKDIR /etc/openldap
COPY ./config/slapd.conf .
COPY ./config/ldif/* ./
COPY ./docker-entrypoint.sh .

RUN mkdir /var/lib/openldap/run

ENTRYPOINT [ "sh","./docker-entrypoint.sh" ]
