#!/bin/bash
# -------------------------------------------------------------------------------------
#
# Tomcatコンテナビルド ＆ 起動
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
# Tomcatコンテナビルド
# [Return]
# - 0: (正常終了)
# ------------------------------------------------------------------------------
build_tomcat_container(){
  local -r _tomcat_dir=${SHELLNAME}/${TOMCAT_NAME}

  start_log "build tomcat container"

  # --------------------------------------------------
  # Tomcatイメージビルド
  # --------------------------------------------------
  command_log "Docker build tomcat"
  ${CMD_PUSHD} ${_tomcat_dir} > /dev/null
  ${CMD_DOCKER} build -t ${TOMCAT_IMAGE_CONTAINER} .
  command_end_log
  ${CMD_DOCKER} images
  echo ""
  ${CMD_POPD} > /dev/null

  end_log "Successed build tomcat container."
  return ${COM_RESULT_SUCCESSED}
}

# ------------------------------------------------------------------------------
# Tomcatコンテナ起動
# [Return]
# - 0: (正常終了)
# - 1: (異常終了)
# ------------------------------------------------------------------------------
run_tomcat_container(){
  local _result=${COM_RESULT_SUCCESSED}
  start_log "Docker run tomcat container..."

  # --------------------------------------------------
  # Tomcatコンテナ & イメージ削除
  # --------------------------------------------------
  stop_and_delete_container "${TOMCAT_CONTAINER_NAME}"
  _result=$?
  if [ ${_result} -eq ${COM_RESULT_FAILED} ]; then
    return ${_result}
  fi

  # --------------------------------------------------
  # Tomcatコンテナ起動
  # --------------------------------------------------
  command_log "docker run tomcat container"
  ${CMD_DOCKER} run -it -d \
    --name ${TOMCAT_CONTAINER_NAME} \
    --tmpfs ${ROOT_TMP_DIR} \
    --tmpfs ${ROOT_RUN_DIR} \
    -v ${CGROUP_DIR}:${CGROUP_DIR}:ro \
    -p ${NGINX_FROM_PORT}:${TOMCAT_FROM_PORT} \
    ${TOMCAT_IMAGE_CONTAINER}
  command_end_log

  # --------------------------------------------------
  # Tomcatコンテナ確認
  # --------------------------------------------------
  command_log "${CMD_DOCKER} ps -a"
  ${CMD_DOCKER} ps -a
  echo ""
  command_log "${CMD_DOCKER} logs ${TOMCAT_CONTAINER_NAME}"
  ${CMD_DOCKER} logs ${TOMCAT_CONTAINER_NAME}
  echo ""

  end_log "Successed run tomcat container."
  return ${_result}
}

# ------------------------------------------------------------------------------
# Main関数
# [Return]
# - 0: (正常終了)
# - 1: (異常終了 - exitで終了)
# ------------------------------------------------------------------------------
main(){
  local _result=0

  # NAT用NICへ変更
  change_nic

  # Tomcatコンテナ準備
  pre_tomcat_container
  _result=$?
  check_result "${_result}"
  # Tomcatコンテナビルド
  build_tomcat_container
  _result=$?
  check_result "${_result}"
  # Tomcatコンテナ起動
  run_tomcat_container
  _result=$?
  check_result "${_result}"

  # NIC戻す
  back_nic

  return ${COM_RESULT_SUCCESSED}
}

main "$@"
exit "$?"