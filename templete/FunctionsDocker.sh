#!/bin/bash
# -------------------------------------------------------------------------------------
#
# 関数定義[Docker]
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# 二重呼び出し対策
if [ -n "${FUNCTIONS_DOCKER_KEY}" ]; then
  return 0
fi
readonly FUNCTIONS_DOCKER_KEY=FunctionsDocker

# ------------------------------------------------
#- Lib
# ------------------------------------------------
readonly FUNCTIONS_DOCKER_MYSHELL=${FUNCTIONS_DOCKER_KEY}.sh
readonly FUNCTIONS_DOCKER_MYDIR=$(/usr/bin/find . -type f -name "${FUNCTIONS_DOCKER_MYSHELL}" -print)
readonly FUNCTIONS_DOCKER_DIR=$(cd $(/usr/bin/dirname ${FUNCTIONS_DOCKER_MYDIR}) && pwd)
readonly COMMON_CONSTANTS_SHELL=CommonConstants.sh
readonly COMMON_FUNCTIONS_SHELL=CommonFunctions.sh
readonly CONSTANTS_DOCKER_SHELL=ConstantsDocker.sh

if [ ! -e "${FUNCTIONS_DOCKER_DIR}/common/${COMMON_CONSTANTS_SHELL}" ] || 
   [ ! -e "${FUNCTIONS_DOCKER_DIR}/common/${COMMON_FUNCTIONS_SHELL}" ] || 
   [ ! -e "${FUNCTIONS_DOCKER_DIR}/${CONSTANTS_DOCKER_SHELL}" ]; then
  exit 1
fi

source "${FUNCTIONS_DOCKER_DIR}/common/${COMMON_CONSTANTS_SHELL}"
source "${FUNCTIONS_DOCKER_DIR}/common/${COMMON_FUNCTIONS_SHELL}"
source "${FUNCTIONS_DOCKER_DIR}/${CONSTANTS_DOCKER_SHELL}"

# ------------------------------------------------
# Constants
# ------------------------------------------------

# ------------------------------------------------
# Logic
# ------------------------------------------------

# ----------------------------------------------------------------
# NAT用NICへ変更
# [Return]
# - 正常終了
# ----------------------------------------------------------------
change_nic(){
  ifdown ens33
  ifup ens34
  echo ""
}

# ----------------------------------------------------------------
# NIC戻す
# [Return]
# - 正常終了
# ----------------------------------------------------------------
back_nic(){
  ifdown ens34
  ifup ens33
  echo ""
}

# ----------------------------------------------------------------
# コンテナの停止 & 削除
# [input]
#  - コンテナ名
# [return]
#  - 0(成功)
#  - 1(異常)
# ----------------------------------------------------------------
stop_and_delete_container(){
  local _target=$1
  local _search=""

  if [ -z "${_target}" ]; then
    error_log "Argument error."
    return ${COM_RESULT_FAILED}
  fi

  _search=$(${CMD_DOCKER} ps -a | \
    ${CMD_GREP} -E "\s${_target}$" | \
    ${CMD_AWK} '{print $1}')
  if [ -z "${_search}" ]; then
    echo "None docker container."
    return ${COM_RESULT_SUCCESSED}
  fi

  echo "  Docker stop and delete ID: [${_search}]..."
  ${CMD_DOCKER} stop ${_search}
  ${CMD_DOCKER} rm ${_search}
  echo "  done."
  echo ""

  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# Tomcatコンテナ準備
# [return]
#  - 0(成功)
#  - 1(異常)
# ----------------------------------------------------------------
pre_tomcat_container(){
  local -r _input_dir=${FUNCTIONS_DOCKER_DIR}/${INPUT_NAME}
  local -r _tomcat_dir=${FUNCTIONS_DOCKER_DIR}/${TOMCAT_NAME}
  local -r _tomcat_from_dir=${_tomcat_dir}/${DOCKER_FROM_DIR}

  start_log "pre tomcat container..."

  # --------------------------------------------------
  # Tomcatディレクトリデプロイ
  # --------------------------------------------------
  if [ ! -e "${_input_dir}/${TOMCAT_NAME}" ]; then
    error_log "[build_tomcat_container]"
    return ${COM_RESULT_FAILED}
  fi
  command_log "Deploy tomcat directory"
  ${CMD_CP} -arfp ${_input_dir}/${TOMCAT_NAME} ${FUNCTIONS_DOCKER_DIR}
  ${CMD_CHMOD} ${PERMISSION_SUPER} ${_tomcat_dir}
  command_end_log

  if [ ! -f "${_tomcat_from_dir}/${TOMCAT_PACKAGE}" ]; then
    # ------------------------------------------------------------
    # tomcatダウンロード
    # ------------------------------------------------------------
    ${CMD_MKDIR} -p -m ${PERMISSION_SUPER} ${_tomcat_from_dir}
    ${CMD_WGET} ${TOMCAT_DOWNLOAD_URL}
    ${CMD_MV} -f ${TOMCAT_PACKAGE} ${_tomcat_from_dir}/
  fi

  end_log "Create tomcat docker files."
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# NGINXコンテナ準備
# [return]
#  - 0(成功)
#  - 1(異常)
# ----------------------------------------------------------------
pre_nginx_container(){
  local -r _input_dir=${FUNCTIONS_DOCKER_DIR}/${INPUT_NAME}
  local -r _nginx_dir=${FUNCTIONS_DOCKER_DIR}/${NGINX_NAME}
  local -r _nginx_from_dir=${_nginx_dir}/${DOCKER_FROM_DIR}

   start_log "pre nginx container..."

  # --------------------------------------------------
  # nginxディレクトリデプロイ
  # --------------------------------------------------
  if [ ! -e "${_input_dir}/${NGINX_NAME}" ]; then
    error_log "[build_nginx_container]"
    return ${COM_RESULT_FAILED}
  fi
  command_log "Deploy nginx directory"
  ${CMD_CP} -arfp ${_input_dir}/${NGINX_NAME} ${FUNCTIONS_DOCKER_DIR}
  ${CMD_CHMOD} ${PERMISSION_SUPER} ${_nginx_dir}
  command_end_log

  end_log "Create nginx docker files."
  return ${COM_RESULT_SUCCESSED}
}
