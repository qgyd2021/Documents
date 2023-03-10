#!/bin/sh
# apt-get install -y dos2unix
# apt-get install -y lrzsz

system_version="centos";

if [ ${system_version} = "centos" ]; then
  yum uninstall docker
  yum install -y docker

  setenforce 0

  mkdir -p /data/lib/docker

  # echo -e "{\n\"graph\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json
  echo -e "{\n\"root-path\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json

  systemctl start docker
elif [ ${system_version} = "ubuntu" ]; then
  apt-get remove docker
  apt-get install -y docker

  mkdir -p /data/lib/docker

  # echo -e "{\n\"graph\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json
  echo -e "{\n\"root-path\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json

  systemctl start docker
fi

