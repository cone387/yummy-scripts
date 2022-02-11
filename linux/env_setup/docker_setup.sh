#!/bin/bash


function install_docker() {
    # 使用测试版本的docker
  # $ curl -fsSL test.docker.com -o get-docker.sh

  # 使用正式版本得docker --mirror指定源
  $ curl -fsSL get.docker.com -o get-docker.sh
  $ sudo sh get-docker.sh --mirror Aliyun
  # $ sudo sh get-docker.sh --mirror AzureChinaCloud

}

function start_docker_service() {
  sudo systemctl enable docker
  sudo systemctl start docker
}


function main() {
  install_docker
  start_docker_service
}