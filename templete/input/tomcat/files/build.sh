#!/bin/bash
# -------------------------------------------------------------------------------------
#
# Tomcatコンテナビルド実行
#
# -------------------------------------------------------------------------------------

# ------------------------------------------------------------------
# Current path
# ------------------------------------------------------------------
readonly CURRENT_FULL_DIR=`/bin/readlink -f $0`
readonly CURRENT_DIR=`/usr/bin/dirname ${CURRENT_FULL_DIR}`

# ------------------------------------------------------------------
# Constants setting
# ------------------------------------------------------------------
readonly TOMCAT_NAME=tomcat
readonly WORK_DIR=/opt
readonly CATALINA_HOME=/var/${TOMCAT_NAME}

readonly TOMCAT_PACKAGE=apache-tomcat-9.0.64.tar.gz
readonly TOMCAT_FILE_NAME=`echo ${TOMCAT_PACKAGE} | /bin/sed -e 's/\.tar\.gz//'`
readonly TOMCAT_VERSION=`echo ${TOMCAT_FILE_NAME} | /bin/sed -e 's/apache-tomcat-//'`
readonly TOMCAT_MAJOR_VERSION=`echo ${TOMCAT_VERSION} | /bin/cut -f 1 -d "."`

readonly LIB_SYSTEMD_SYSTEM_DIR=/lib/systemd/system
readonly ETC_SYSTEMD_SYSTEM_DIR=/etc/systemd/system
readonly TOMCAT_SERVICE_FILE=tomcat9.service
readonly CATALINE_FILE=catalina.sh

# ------------------------------------------------------------------
# Logic
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# 全体アップデート
# ------------------------------------------------------------------
yum_update(){
  /bin/yum -y update
  echo " successed yum update."
  echo ""
}

# ------------------------------------------------------------------
# パッケージインストール
# ------------------------------------------------------------------
install_package(){
  /bin/yum -y install java
  echo " successed install java."
  echo ""
}

# ------------------------------------------------------------------
# systemdの整理
# ------------------------------------------------------------------
prepare_systemd(){
  cd ${LIB_SYSTEMD_SYSTEM_DIR}/sysinit.target.wants/

  for i in *; do \
    [ $i == systemd-tmpfiles-setup.service ] || /bin/rm -f $i;
  done

  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/multi-user.target.wants/*
  /bin/rm -f ${ETC_SYSTEMD_SYSTEM_DIR}/*.wants/*
  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/local-fs.target.wants/*
  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/sockets.target.wants/*udev*
  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/sockets.target.wants/*initctl*
  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/basic.target.wants/*
  /bin/rm -f ${LIB_SYSTEMD_SYSTEM_DIR}/anaconda.target.wants/*

  cd ${CURRENT_DIR}
  echo " successed prepare systemd."
  echo ""
}

# ------------------------------------------------------------------
# Tomcat設置
# ------------------------------------------------------------------
copy_tomcat(){
  /bin/mv -f ${WORK_DIR}/${TOMCAT_FILE_NAME} ${CATALINA_HOME}
  echo " successed copy tomcat."
  echo ""
}

# ------------------------------------------------------------------
# Tomcatユーザ追加
# ------------------------------------------------------------------
add_tomcatuser(){
  /sbin/useradd -M ${TOMCAT_NAME}
  /bin/id ${TOMCAT_NAME}
  echo ""

  /bin/chown ${TOMCAT_NAME}:${TOMCAT_NAME} -R ${CATALINA_HOME}
  /bin/ls -l /var | /bin/grep ${TOMCAT_NAME}
  echo " successed add tomcat user."
  echo ""
}

# ------------------------------------------------------------------
# Tomcatユニットファイル生成
# ------------------------------------------------------------------
add_tomcat_unitfile(){
  /bin/mv -f ${WORK_DIR}/${TOMCAT_SERVICE_FILE} ${ETC_SYSTEMD_SYSTEM_DIR}/${TOMCAT_SERVICE_FILE}
  /bin/chmod 755 ${ETC_SYSTEMD_SYSTEM_DIR}/${TOMCAT_SERVICE_FILE}
  echo " successed create unit file."
  echo ""
}

# ------------------------------------------------------------------
# Main関数
# ------------------------------------------------------------------
main(){
  # 全体アップデート
  yum_update
  # パッケージインストール
  install_package
  # systemdの整理
  prepare_systemd
  # Tomcat設置
  copy_tomcat
  # Tomcatユーザ追加
  add_tomcatuser
  # Tomcatユニットファイル生成
  add_tomcat_unitfile
}

main "$@"
exit "$?"
