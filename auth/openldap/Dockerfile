FROM alpine:latest

RUN apk add --no-cache --upgrade openldap openldap-clients openldap-backend-all openldap-overlay-all

WORKDIR /etc/openldap
COPY ./config/slapd.conf .
# COPY ./config/ldif/manager.ldif .
# COPY ./config/ldif/operator.ldif .
# COPY ./config/ldif/syncprov.ldif .
# COPY ./config/ldif/master.ldif .
# COPY ./config/ldif/add-configpw.ldif .
# COPY ./config/ldif/freeradius.ldif .
# COPY ./config/ldif/radiusAdmin-access.ldif .
COPY ./config/ldif/* ./
COPY ./docker-entrypoint.sh .

RUN mkdir /var/lib/openldap/run

ENTRYPOINT [ "sh","./docker-entrypoint.sh" ]
