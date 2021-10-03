#!/bin/sh

# radius 初期化 
initialize() {

  # mods-available/ldap 初期設定
  sed -i -e "s~cn=Manager,dc=my-domain,dc=com~${LDAP_IDENTITY}~g" ./mods-available/ldap
  sed -i -e "s~manager_secret~${LDAP_MANAGER_PASSWORD}~g" ./mods-available/ldap
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./mods-available/ldap

}

# radius起動
start() {
  sleep 10
  radiusd -X
  # tail -f /dev/null
}


if [ ! -e /etc/raddb/mods-available/initialized ]; then
  initialize &
  touch /etc/raddb/mods-available/initialized
fi

start &

wait
