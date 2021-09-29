#!/usr/bin/env bash

# Copyright 2020 Authors of Arktos.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Convenience script to setup a fresh Linux installation for Arktos developers.

function set_profile_path {
  echo export PATH=$PATH:/usr/local/go/bin\ >> ~/.profile
  source ~/.profile
}

function install_dockerio {
  sudo apt -y update
  sudo apt -y install docker.io
}

function install_make {
  sudo apt -y update
  sudo apt -y install make
}

function install_gcc {
  sudo apt -y update
  sudo apt -y install gcc
}

function install_jq {
  sudo apt -y update
  sudo apt -y install jq
}

function install_golang {
  GOLANG_VERSION=${GOLANG_VERSION:-"1.13.9"}
  wget https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz -P /tmp
  sudo tar -C /usr/local -xzf /tmp/go${GOLANG_VERSION}.linux-amd64.tar.gz
  rm -rf /tmp/go${GOLANG_VERSION}.linux-amd64.tar.gz
  set_profile_path
}

function check_installed_dependencies {
  echo "Check if docker is installed"
  if ! [ -x "$(command -v docker -v)" ]; then
    echo 'Error: docker is not installed.' >&2
    install_dockerio
  else
    echo "docker is installed"
  fi

  echo "Check if golang 1.13.9 is installed"
  if ! [ -x "$(command -v go version)" ]; then
    echo 'Error: go is not installed.' >&2
    install_golang
  else
    go_version=$(go version | cut -d' ' -f3 | cut -d'o' -f2)
    major_version=$(echo $go_version | cut -d'.' -f1)
    major_sub_version=$(echo $go_version | cut -d'.' -f2)
    minor_sub_version=$(echo $go_version | cut -d'.' -f3)

    if [[ "$major_version" == "1" ]] && [[ "$major_sub_version" == "13" ]] && [[ "$minor_sub_version" == "9" ]]; then
      echo "golang 1.13.9 is installed"
    else
      echo "Error: golang 1.13.9 is NOT installed"
      sudo rm -rf /usr/local/go
      install_golang
    fi
  fi

  echo "Check if make & gcc & jq are installed"
  if ! [ -x "$(command -v make)" ]; then
    echo "Error: make is not installed"
    install_make
  else
    echo "make is installed"
  fi
  if ! [ -x "$(command -v gcc)" ]; then
    echo "Error: gcc is not installed"
    install_gcc
  else
    echo "gcc is installed"
  fi
  if ! [ -x "$(command -v jq)" ]; then
    echo "Error: jq is not installed"
    install_jq
  else
    echo "jq is installed"
  fi
}

check_installed_dependencies