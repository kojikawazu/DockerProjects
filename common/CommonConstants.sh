#!/bin/bash
# -------------------------------------------------------------------------------------
#
# 定数定義[共通部]
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# 二重呼び出し対策
if [ -n "${COMMON_CONSTANTS_KEY}" ]; then
  return 0
fi
readonly COMMON_CONSTANTS_KEY=CommonConstants

# ------------------------------------------------
# Constants
# ------------------------------------------------

# ------------------------------------------------
# Command
# ------------------------------------------------
if [ -z "${CMD_GREP}" ]; then
  readonly CMD_GREP=/bin/grep
fi

if [ -z "${CMD_AWK}" ]; then
  readonly CMD_AWK=/bin/awk
fi

if [ -z "${CMD_CP}" ]; then
  readonly CMD_CP=/bin/cp
fi

if [ -z "${CMD_CHMOD}" ]; then
  readonly CMD_CHMOD=/bin/chmod
fi

if [ -z "${CMD_MKDIR}" ]; then
  readonly CMD_MKDIR=/bin/mkdir
fi

if [ -z "${CMD_WGET}" ]; then
  readonly CMD_WGET=/bin/wget
fi

if [ -z "${CMD_MV}" ]; then
  readonly CMD_MV=/bin/mv
fi

if [ -z "${CMD_PUSHD}" ]; then
  readonly CMD_PUSHD=pushd
fi

if [ -z "${CMD_POPD}" ]; then
  readonly CMD_POPD=popd
fi

if [ -z "${CMD_DOCKER}" ]; then
  readonly CMD_DOCKER=/usr/bin/docker
fi

if [ -z "${CND_DOCKER_COMPOSE}" ]; then
  readonly CND_DOCKER_COMPOSE=/usr/local/bin/docker-compose
fi

# ------------------------------------------------
# Docker
# ------------------------------------------------
if [ -z "${DOCERFILE_NAME}" ]; then
  readonly DOCERFILE_NAME=Dockerfile
fi

if [ -z "${DOCKER_COMPOSE_YML}" ]; then
  readonly DOCKER_COMPOSE_YML=docker-compose.yml
fi

# ------------------------------------------------
# Return status
# ------------------------------------------------
if [ -z "${COM_RESULT_SUCCESSED}" ]; then
  readonly COM_RESULT_SUCCESSED=0
fi

if [ -z "${COM_RESULT_FAILED}" ]; then
  readonly COM_RESULT_FAILED=1
fi

if [ -z "${COM_RESULT_ALREADY}" ]; then
  readonly COM_RESULT_ALREADY=2
fi

# ------------------------------------------------
# Name
# ------------------------------------------------
if [ -z "${TOMCAT_NAME}" ]; then
  readonly TOMCAT_NAME=tomcat
fi

if [ -z "${NGINX_NAME}" ]; then
  readonly NGINX_NAME=nginx
fi

if [ -z "${INPUT_NAME}" ]; then
  readonly INPUT_NAME=input
fi

if [ -z "${COMPOSE_NAME}" ]; then
  readonly COMPOSE_NAME=compose
fi

# ------------------------------------------------
# Dir
# ------------------------------------------------
if [ -z "${DOCKER_FROM_DIR}" ]; then
  readonly DOCKER_FROM_DIR=files
fi

if [ -z "${DOCKER_TO_DIR}" ]; then
  readonly DOCKER_TO_DIR=/opt
fi

if [ -z "${ROOT_TMP_DIR}" ]; then
  readonly ROOT_TMP_DIR=/tmp
fi

if [ -z "${ROOT_RUN_DIR}" ]; then
  readonly ROOT_RUN_DIR=/run
fi

if [ -z "${ROOT_ETC_DIR}" ]; then
  readonly ROOT_ETC_DIR=/etc
fi

if [ -z "${NGING_DIR}" ]; then
  readonly NGING_DIR=${ROOT_ETC_DIR}/nginx
fi

if [ -z "${NGING_CONF_DIR}" ]; then
  readonly NGING_CONF_DIR=${NGING_DIR}/conf.d/
fi

# ------------------------------------------------
# File Permission
# ------------------------------------------------
if [ -z "${PERMISSION_SUPER}" ]; then
  readonly PERMISSION_SUPER=777
fi

# ------------------------------------------------
# Network
# ------------------------------------------------
if [ -z "${LOCALHOST_NAME}" ]; then
  readonly LOCALHOST_NAME=localhost
fi

# ------------------------------------------------
# Volume
# ------------------------------------------------
if [ -z "${CGROUP_DIR}" ]; then
  readonly CGROUP_DIR=/sys/fs/cgroup
fi

# ------------------------------------------------
# NGINX
# ------------------------------------------------
if [ -z "${TOMCAT_CONF}" ]; then
  readonly TOMCAT_CONF=tomcat.conf
fi

if [ -z "${NGINX_CONF}" ]; then
  readonly NGINX_CONF=nginx.conf
fi
