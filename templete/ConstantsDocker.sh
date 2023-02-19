#!/bin/bash
# -------------------------------------------------------------------------------------
#
# 定数定義[Docker]
#
# since: 2023/01/26
#
# -------------------------------------------------------------------------------------

# ------------------------------------------------
# 二重呼び出し対策
# ------------------------------------------------
if [ -n "${CONSTANTS_DOCKER_KEY}" ]; then
  return 0
fi
readonly CONSTANTS_DOCKER_KEY=ConstantsDocker

# ------------------------------------------------
#- Libs
# ------------------------------------------------
readonly CONSTANTS_DOCKER_MYSHELL=${CONSTANTS_DOCKER_KEY}.sh
readonly CONSTANTS_DOCKER_MYDIR=$(/usr/bin/find $(cd $(/usr/bin/dirname $0) && pwd) -maxdepth 1 -type f -name "${CONSTANTS_DOCKER_MYSHELL}" -print)
readonly CONSTANTS_DOCKER_DIR=$(cd $(/usr/bin/dirname ${CONSTANTS_DOCKER_MYDIR}) && pwd)

if [ -z "${COMMON_CONSTANTS_SHELL}" ]; then
  readonly COMMON_CONSTANTS_SHELL=CommonConstants.sh
fi
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
readonly NGINX_TOMCAT_COMPOSE_YML=nginx_tomcat_docker-compose.yml

# ------------------------------------------------
# Docker Images
# ------------------------------------------------
readonly CENTOS_IMAGE_CONTAINER=centos:7
readonly NGINX_IMAGE_CONTAINER=nginx:latest
readonly PYTHON_IMAGE_CONTAINER=python:3.4-alpine
readonly REDIS_IMAGE_CONTAINER=redis:alpine
readonly TOMCAT_IMAGE_CONTAINER=tomcat:1
readonly NGINX_TOMCAT_IMAGE_CONTAINER=nginx-tomcat:1 

# ------------------------------------------------
# Docker Container
# ------------------------------------------------
readonly TOMCAT_CONTAINER_NAME=tomcat-1
readonly NGINX_CONTAINER_NAME=nginx-tomcat-1

# ------------------------------------------------
# ShellScript Name
# ------------------------------------------------
readonly BUILD_SHELL_NAME=build.sh
readonly START_SHELL_NAME=start.sh

# ------------------------------------------------
# Network
# ------------------------------------------------
readonly TOMCAT_NETWORK=tomcat-network

# ------------------------------------------------
# Port
# ------------------------------------------------
readonly TOMCAT_FROM_PORT=8080
readonly TOMCAT_TO_PORT=80
readonly NGINX_FROM_PORT=8081
readonly NGINX_TO_PORT=3000

# ------------------------------------------------
# Tomcat
# ------------------------------------------------
readonly TOMCAT_PACKAGE=apache-tomcat-9.0.64.tar.gz
readonly TOMCAT_FILE_NAME=`echo ${TOMCAT_PACKAGE} | /bin/sed -e 's/\.tar\.gz//'`
readonly TOMCAT_VERSION=`echo ${TOMCAT_FILE_NAME} | /bin/sed -e 's/apache-tomcat-//'`
readonly TOMCAT_MAJOR_VERSION=`echo ${TOMCAT_VERSION} | /bin/cut -f 1 -d "."`
#readonly TOMCAT_DOWNLOAD_URL=https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_PACKAGE}
readonly TOMCAT_DOWNLOAD_URL=https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_PACKAGE}


# ------------------------------------------------
# FLASK
# ------------------------------------------------
readonly FLASK_DIR=flask
readonly FLASK_APP_FILE=app.py
readonly FLASK_REQUIRE_FILE=requirements.txt
