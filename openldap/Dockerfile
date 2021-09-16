FROM alpine:latest

ENV LDAP_BASE_DN="dc=local,dc=doornoc,dc=net"
ENV LDAP_ADMIN_PASSWORD="password"

RUN apk add --no-cache --upgrade --virtual for-ldap openldap openldap-back-mdb openssl cyrus-sasl

COPY ./slapd.conf /etc/openldap/slapd.conf

RUN cd /etc/openldap && \
    sed -i -e "s/dc=my-domain,dc=com/$LDAP_BASE_DN/g" ./slapd.conf && \
    export LDAP_ROOT_PW=`slappasswd -s ${LDAP_ADMIN_PASSWORD}` && \
    sed -i -e "s/secret/${LDAP_ROOT_PW}/" ./slapd.conf && \
    mkdir slapd.d && \
    mkdir /var/lib/openldap/run && \
    slaptest -f ./slapd.conf -F ./slapd.d -u

CMD ["/usr/sbin/slapd"]
