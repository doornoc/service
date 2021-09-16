FROM alpine:latest

ENV LDAP_BASE_DN="dc=local,dc=doornoc,dc=net"
ENV LDAP_ADMIN_PASSWORD="password"

RUN apk add --no-cache --upgrade openldap openldap-clients openldap-back-mdb openssl cyrus-sasl

COPY ./slapd.conf /etc/openldap/slapd.conf
COPY ./operator.ldif /etc/openldap/operator.ldif

RUN cd /etc/openldap && \
    sed -i -e "s/dc=my-domain,dc=com/$LDAP_BASE_DN/g" ./slapd.conf && \
    export LDAP_ROOT_PW=`slappasswd -s ${LDAP_ADMIN_PASSWORD}` && \
    sed -i -e "s/secret/${LDAP_ROOT_PW}/" ./slapd.conf && \
    mkdir slapd.d && \
    slaptest -f ./slapd.conf -F ./slapd.d; exit 0 && \
    ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_ADMIN_PASSWORD} -f ./operator.ldif

CMD ["slapd", "-d", "1"]

# CMD ["tail", "-f", "/dev/null"]
