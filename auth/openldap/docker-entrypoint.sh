#!/bin/sh

# slapd 初期化 
initialize() {

  # slapd.conf 初期設定
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./slapd.conf
  export LDAP_MANAGER_ROOT_PW=`slappasswd -s ${LDAP_MANAGER_PASSWORD}`
  sed -i -e "s~manager_secret~${LDAP_MANAGER_ROOT_PW}~" ./slapd.conf

  # master.ldif 初期設定
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./master.ldif
  sed -i -e "s~999~${LDAP_SERVER_ID}~" ./master.ldif
  sed -i -e "s~neighbor~${LDAP_NEIGHBOR_ADDRESS}~" ./master.ldif
  sed -i -e "s~secret~${LDAP_MANAGER_PASSWORD}~" ./master.ldif

  # add-configpw.ldif 初期設定
  sed -i -e "s~secret~${LDAP_MANAGER_ROOT_PW}~" ./add-configpw.ldif

  # admin.ldif 初期設定
  export LDAP_ADMIN_ROOT_PW=`slappasswd -s ${LDAP_ADMIN_PASSWORD}`
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./admin.ldif
  sed -i -e "s~admin_secret~${LDAP_ADMIN_ROOT_PW}~" ./admin.ldif

  # freeradius.ldif 初期設定
  export LDAP_FREERADIUS_ROOT_PW=`slappasswd -s ${LDAP_FREERADIUS_PASSWORD}`
  sed -i -e "s~radiusadmin_secret~${LDAP_FREERADIUS_ROOT_PW}~" ./freeradius.ldif
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./freeradius.ldif
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./radiusAdmin-access.ldif

  # access.ldif
  sed -i -e "s~dc=my-domain,dc=com~${LDAP_BASE_DN}~g" ./access.ldif

  # 設定保存用ディレクトリ作成
  # mkdir ./slapd.d

  # slaptset
  slaptest -f ./slapd.conf -F ./slapd.d
}

# slapd起動
start() {
  slapd -h "ldap:/// ldapi:///" -d 127 
}

# 起動後実行
lazyProcess() {

  # これがないとなぜか失敗する
  sleep 10

  # Manager 初期設定
  ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f /etc/openldap/manager.ldif

  # config database 操作用
  ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ./add-configpw.ldif

  # 運営メンバー追加
  ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f ./operator.ldif

  # allow.ldif
  ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ./allow.ldif

  # admin.ldif
  ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f ./admin.ldif

  # access.ldif
  ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ./access.ldif

  # freeradius 用
  ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f ./freeradius.ldif
  ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f ./radiusAdmin-access.ldif

  # マルチマスターレプリケーション用
  ldapadd -Y EXTERNAL -H ldapi:/// -f ./syncprov.ldif
  ldapadd -Y EXTERNAL -H ldapi:/// -f ./master.ldif
}

if [ ! -e /var/lib/openldap/openldap-data/initialized ]; then
  initialize &
fi

start &

if [ ! -e /var/lib/openldap/openldap-data/initialized ]; then
  lazyProcess &
  touch /var/lib/openldap/openldap-data/initialized
fi

wait
