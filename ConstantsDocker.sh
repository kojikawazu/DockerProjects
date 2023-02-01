#!/bin/bash
# -------------------------------------------------------------------------------------
#
# 定数定義[Docker]
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# 二重呼び出し対策
if [ -n "${CONSTANTS_DOCKER_KEY}" ]; then
  return 0
fi
readonly CONSTANTS_DOCKER_KEY=ConstantsDocker

# ------------------------------------------------
#- Lib
# ------------------------------------------------
readonly CONSTANTS_DOCKER_MYSHELL=${CONSTANTS_DOCKER_KEY}.sh
readonly CONSTANTS_DOCKER_MYDIR=$(/usr/bin/find . -type f -name "${CONSTANTS_DOCKER_MYSHELL}" -print)
readonly CONSTANTS_DOCKER_DIR=$(cd $(/usr/bin/dirname ${CONSTANTS_DOCKER_MYDIR}) && pwd)
readonly COMMON_CONSTANTS_SHELL=CommonConstants.sh

if [ ! -e "${CONSTANTS_DOCKER_DIR}/common/${COMMON_CONSTANTS_SHELL}" ]; then
  exit 1
fi
source "${CONSTANTS_DOCKER_DIR}/common/${COMMON_CONSTANTS_SHELL}"

# ------------------------------------------------
# Constants
# ------------------------------------------------

# ------------------------------------------------
# Docker
# ------------------------------------------------
if [ -z "${NGINX_TOMCAT_COMPOSE_YML}" ]; then
  readonly NGINX_TOMCAT_COMPOSE_YML=nginx_tomcat_docker-compose.yml
fi

# ------------------------------------------------
# Docker Images
# ------------------------------------------------
if [ -z "${CENTOS_IMAGE_CONTAINER}" ]; then
  readonly CENTOS_IMAGE_CONTAINER=centos:7
fi

if [ -z "${NGINX_IMAGE_CONTAINER}" ]; then
  readonly NGINX_IMAGE_CONTAINER=nginx:latest
fi

if [ -z "${PYTHON_IMAGE_CONTAINER}" ]; then
  readonly PYTHON_IMAGE_CONTAINER=python:3.4-alpine
fi

if [ -z "${REDIS_IMAGE_CONTAINER}" ]; then
  readonly REDIS_IMAGE_CONTAINER=redis:alpine
fi

if [ -z "${TOMCAT_IMAGE_CONTAINER}" ]; then
  readonly TOMCAT_IMAGE_CONTAINER=tomcat:1
fi

if [ -z "${NGINX_TOMCAT_IMAGE_CONTAINER}" ]; then
  readonly NGINX_TOMCAT_IMAGE_CONTAINER=nginx-tomcat:1 
fi

# ------------------------------------------------
# Docker Container
# ------------------------------------------------
if [ -z "${TOMCAT_CONTAINER_NAME}" ]; then
  readonly TOMCAT_CONTAINER_NAME=tomcat-1
fi

if [ -z "${NGINX_CONTAINER_NAME}" ]; then
  readonly NGINX_CONTAINER_NAME=nginx-tomcat-1
fi

# ------------------------------------------------
# ShellScript Name
# ------------------------------------------------
if [ -z "${BUILD_SHELL_NAME}" ]; then
  readonly BUILD_SHELL_NAME=build.sh
fi

if [ -z "${START_SHELL_NAME}" ]; then
  readonly START_SHELL_NAME=start.sh
fi

# ------------------------------------------------
# Network
# ------------------------------------------------
if [ -z "${TOMCAT_NETWORK}" ]; then
  readonly TOMCAT_NETWORK=tomcat-network
fi

if [ -z "${LOCALHOST_NAME}" ]; then
  readonly LOCALHOST_NAME=localhost
fi

# ------------------------------------------------
# Port
# ------------------------------------------------
if [ -z "${TOMCAT_FROM_PORT}" ]; then
  readonly TOMCAT_FROM_PORT=8080
fi

if [ -z "${TOMCAT_TO_PORT}" ]; then
  readonly TOMCAT_TO_PORT=80
fi

if [ -z "${NGINX_FROM_PORT}" ]; then
  readonly NGINX_FROM_PORT=8081
fi

if [ -z "${NGINX_TO_PORT}" ]; then
  readonly NGINX_TO_PORT=3000
fi

# ------------------------------------------------
# Tomcat
# ------------------------------------------------
if [ -z "${TOMCAT_PACKAGE}" ]; then
  readonly TOMCAT_PACKAGE=apache-tomcat-9.0.64.tar.gz
fi

if [ -z "${TOMCAT_FILE_NAME}" ]; then
  readonly TOMCAT_FILE_NAME=`echo ${TOMCAT_PACKAGE} | /bin/sed -e 's/\.tar\.gz//'`
fi

if [ -z "${TOMCAT_VERSION}" ]; then
  readonly TOMCAT_VERSION=`echo ${TOMCAT_FILE_NAME} | /bin/sed -e 's/apache-tomcat-//'`
fi

if [ -z "${TOMCAT_MAJOR_VERSION}" ]; then
  readonly TOMCAT_MAJOR_VERSION=`echo ${TOMCAT_VERSION} | /bin/cut -f 1 -d "."`
fi

if [ -z "${TOMCAT_DOWNLOAD_URL}" ]; then
  #readonly TOMCAT_DOWNLOAD_URL=https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_PACKAGE}
  readonly TOMCAT_DOWNLOAD_URL=https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_PACKAGE}
fi

# ------------------------------------------------
# FLASK
# ------------------------------------------------
if [ -z "${FLASK_DIR}" ]; then
  readonly FLASK_DIR=flask
fi

if [ -z "${FLASK_APP_FILE}" ]; then
  readonly FLASK_APP_FILE=app.py
fi

if [ -z "${FLASK_REQUIRE_FILE}" ]; then
  readonly FLASK_REQUIRE_FILE=requirements.txt
fi
