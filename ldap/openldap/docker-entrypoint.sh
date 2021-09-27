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
  sed -i -e "s~secret~${LDAP_MANAGER_PASSWORD}~" ./add-configpw.ldif

  # 設定保存用ディレクトリ作成
  mkdir ./slapd.d

  # slaptset
  slaptest -f ./slapd.conf -F ./slapd.d
}

# slapd起動
start() {
  slapd -h "ldap:/// ldapi:///" -d 127 
}

# 起動後実行
lazyProcess() {

  # 初回のみ実行
  if [ ! -e '/check2' ]; then
    touch /check

    sleep 10
    
    # Manager 初期設定
    ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f /etc/openldap/manager.ldif
    # 運営メンバー追加
    ldapadd -x -D "cn=Manager,dc=local,dc=doornoc,dc=net" -w ${LDAP_MANAGER_PASSWORD} -f ./operator.ldif
    # マルチマスターレプリケーション用
    ldapadd -Y EXTERNAL -H ldapi:/// -f ./syncprov.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f ./master.ldif

    # config database 操作用
    ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ./add-configpw.ldif

  else
    echo "OK"
  fi

}

initialize &
start &
lazyProcess &

wait
