#!/bin/bash
# -------------------------------------------------------------------------------------
#
# Tomcatコンテナ起動実行
#
# -------------------------------------------------------------------------------------

# ------------------------------------------------------------------
# Constants settings
# ------------------------------------------------------------------
readonly CATALINA_HOME=/var/tomcat

# ------------------------------------------------------------------
# Logic
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Tomcatの有効化
# ------------------------------------------------------------------
tomcat_enable(){
  local _is_enable=""
  _is_enable=`/usr/bin/systemctl list-unit-files --type=service | \
                    /bin/grep tomcat | \
                    /bin/awk '{print $2}'`

  if [ "_is_enable" != "enabled" ]; then
    /usr/bin/systemctl enable tomcat9
    /usr/bin/systemctl list-unit-files --type=service | grep tomcat
    echo " successed enable tomcat service."
  else
    echo " already enable tomcat service."
  fi

  echo ""
}

# ------------------------------------------------------------------
# systemdの起動
# ------------------------------------------------------------------
start_systemd(){
  exec /usr/sbin/init
  echo " successed start init."
  echo ""
}

# ------------------------------------------------------------------
# Main関数
# ------------------------------------------------------------------
main(){
  # Tomcatの有効化
  tomcat_enable
  # systemdの起動
  start_systemd
}

main "$@"
exit "$?"
