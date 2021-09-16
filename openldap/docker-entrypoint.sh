#!/bin/sh

# slapd
startSlapd() {
    # slapd起動
    slapd -d 1
}

# 初期実行
initProcess() {
    if [ ! -e '/check' ]; then
        touch /check
        # ldapadd
        sleep 10
        ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_ADMIN_PASSWORD} -f ./operator.ldif
    else
        echo "OK"
    fi
}

startSlapd &
initProcess &

wait
