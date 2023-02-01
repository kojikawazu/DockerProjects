#!/bin/bash
# -------------------------------------------------------------------------------------
#
# MGINX & Tomcatコンテナビルド ＆ 起動
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# ------------------------------------------------
#- Lib
# ------------------------------------------------
SHELLNAME=$(cd $(/usr/bin/dirname $0) && pwd)

if [ ! -e "${SHELLNAME}/ConstantsDocker.sh" ] ||
   [ ! -e "${SHELLNAME}/FunctionsDocker.sh" ]; then
  exit 1
fi
source "${SHELLNAME}/ConstantsDocker.sh"
source "${SHELLNAME}/FunctionsDocker.sh"

# ------------------------------------------------
#- Logic
# ------------------------------------------------

# ------------------------------------------------------------------------------
# 処理結果判定
# [Return]
# - 0: (正常終了)
# - 1: (異常終了 - exitで終了)
# ------------------------------------------------------------------------------
check_result(){
  local _result=$1
  if [ -z "${_result}" ] || [ ${_result} -eq 1 ]; then
    back_nic
    exit ${COM_RESULT_FAILED}
  fi
  
  return ${COM_RESULT_SUCCESSED}
}

# ------------------------------------------------------------------------------
# docker-compose.ymlの準備
# [Return]
# - 0: (正常終了)
# - 1: (異常終了)
# ------------------------------------------------------------------------------
pre_docker_compose_yml(){
  local -r _input_dir=${SHELLNAME}/${INPUT_NAME}
  local -r _compose_dir=${_input_dir}/${COMPOSE_NAME}
  local -r _nginx_tomcat_compose=${NGINX_TOMCAT_COMPOSE_YML}

  start_log "Create docker compose yml file..."

  # --------------------------------------------------
  # Composeディレクトリデプロイ
  # --------------------------------------------------
  if [ ! -e "${_compose_dir}/${_nginx_tomcat_compose}" ]; then
    error_log "[build_docker compose]"
    return ${COM_RESULT_FAILED}
  fi
  command_log "Deploy docker compose"
  ${CMD_CP} -afp ${_compose_dir}/${_nginx_tomcat_compose} ${SHELLNAME}/${DOCKER_COMPOSE_YML}
  command_end_log

  end_log "Create docker compose yml file."
  return ${COM_RESULT_SUCCESSED}
}

# ------------------------------------------------------------------------------
# compose起動
# [Return]
# - 0: (正常終了)
# - 1: (異常終了 - exitで終了)
# ------------------------------------------------------------------------------
compose_up(){

  start_log "Docker run container..."

  # ------------------------------------------------------------
  # compose起動
  # ------------------------------------------------------------
  ${CND_DOCKER_COMPOSE} up -d --build

  # ------------------------------------------------------------
  # コンテナ確認
  # ------------------------------------------------------------
  command_log "${CMD_DOCKER} ps -a"
  ${CND_DOCKER_COMPOSE} ps -a
  echo ""
  command_log "${CMD_DOCKER} logs"
  ${CMD_DOCKER} logs ${TOMCAT_CONTAINER_NAME}
  echo ""
  ${CMD_DOCKER} logs ${NGINX_CONTAINER_NAME}
  echo ""

  end_log "Successed run container."
  return ${COM_RESULT_SUCCESSED}
}

# ------------------------------------------------------------------------------
# Main関数
# [Return]
# - 0: (正常終了)
# ------------------------------------------------------------------------------
main(){
  local _result=0

  # NAT用NICへ変更
  change_nic

  # Tomcatコンテナ準備
  pre_tomcat_container
  _result=$?
  check_result "${_result}"
  # NGINXコンテナ準備
  pre_nginx_container
  _result=$?
  check_result "${_result}"
  # docker-compose.ymlの準備
  pre_docker_compose_yml
  _result=$?
  check_result "${_result}"
  # compose起動
  compose_up
  _result=$?
  check_result "${_result}"

  # NIC戻す
  back_nic

  return ${COM_RESULT_SUCCESSED}
}

main "$@"
exit "$?"