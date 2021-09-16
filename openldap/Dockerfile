FROM alpine:latest

ENV LDAP_BASE_DN="dc=local,dc=doornoc,dc=net"
ENV LDAP_ADMIN_PASSWORD="password"

RUN apk add --no-cache --upgrade openldap openldap-clients openldap-back-mdb openssl cyrus-sasl

WORKDIR /etc/openldap
COPY ./slapd.conf .
COPY ./operator.ldif .
COPY ./docker-entrypoint.sh .

RUN mkdir slapd.d
RUN sed -i -e "s/dc=my-domain,dc=com/$LDAP_BASE_DN/g" ./slapd.conf && \
    export LDAP_ROOT_PW=`slappasswd -s ${LDAP_ADMIN_PASSWORD}` && \
    sed -i -e "s/secret/${LDAP_ROOT_PW}/" ./slapd.conf
#    slaptest -f ./slapd.conf -F ./slapd.d
#    slaptest -f ./slapd.conf -F ./slapd.d; exit 0

ENTRYPOINT [ "sh","./docker-entrypoint.sh" ]
