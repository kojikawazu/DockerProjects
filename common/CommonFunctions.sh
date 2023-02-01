#!/bin/bash
# -------------------------------------------------------------------------------------
#
# 関数定義[共通部]
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# 二重呼び出し対策
if [ -n "${COMMON_FUNCTIONS_KEY}" ]; then
  return 0
fi
readonly COMMON_FUNCTIONS_KEY=CommonFunctions

# ------------------------------------------------
#- Lib
# ------------------------------------------------
readonly COMMON_FUNCTIONS_MYSHELL=${COMMON_FUNCTIONS_KEY}.sh
readonly COMMON_FUNCTIONS_MYDIR=$(/usr/bin/find . -type f -name "${COMMON_FUNCTIONS_MYSHELL}" -print)
readonly COMMON_FUNCTIONS_DIR=$(cd $(/usr/bin/dirname ${COMMON_FUNCTIONS_MYDIR}) && pwd)

if [ ! -e "${COMMON_FUNCTIONS_DIR}/${COMMON_FUNCTIONS_MYSHELL}" ]; then
  exit 1
fi
source "${COMMON_FUNCTIONS_DIR}/${COMMON_FUNCTIONS_MYSHELL}"

# ------------------------------------------------
# Constants
# ------------------------------------------------

# ------------------------------------------------
# Logic
# ------------------------------------------------

# ----------------------------------------------------------------
# 改行ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
line_log(){
  echo ""
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# 開始ログ
# [input] 
# - ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
start_log(){
  local _start="[Start]"
  local _log="$1"
  if [ -z "${_log}" ]; then
    return ${COM_RESULT_SUCCESSED}
  fi

  echo " ${_start} ${_log}..."
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# 終了ログ
# [input] 
# - ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
end_log(){
  local _end="[End  ]"
  local _log="$1"
  if [ -z "${_log}" ]; then
    return ${COM_RESULT_SUCCESSED}
  fi

  echo " ${_end} ${_log}"
  line_log
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# エラーログ
# [input] 
# - ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
error_log(){
  local _error="[error]"
  local _log="$1"
  if [ -z "${_log}" ]; then
    return ${COM_RESULT_SUCCESSED}
  fi

  echo " ${_error} ${_log}">&2
  line_log
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# コマンドログ
# [input] 
# - ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
command_log(){
  local _log="$1"
  if [ -z "${_log}" ]; then
    return ${COM_RESULT_SUCCESSED}
  fi

  echo "  [${_log}...]"
  return ${COM_RESULT_SUCCESSED}
}

# ----------------------------------------------------------------
# コマンド完了ログ
# [Return]
# - 正常終了
# ----------------------------------------------------------------
command_end_log(){
  echo "  [done.]"
  echo ""
  return ${COM_RESULT_SUCCESSED}
}
