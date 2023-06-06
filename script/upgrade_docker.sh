#!/usr/bin/env bash


docker_repo=http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#docker_repo=https://download.docker.com/linux/centos/docker-ce.repo

docker_version=19.03.0-3.el7

# parse options
while true; do
  [ -z "${1:-}" ] && break;  # break if there are no arguments
  case "$1" in
    --*) name=$(echo "$1" | sed s/^--// | sed s/-/_/g);
      eval '[ -z "${'"$name"'+xxx}" ]' && echo "$0: invalid option $1" 1>&2 && exit 1;
      old_value="(eval echo \\$$name)";
      if [ "${old_value}" == "true" ] || [ "${old_value}" == "false" ]; then
        was_bool=true;
      else
        was_bool=false;
      fi

      # Set the variable to the right value-- the escaped quotes make it work if
      # the option had spaces, like --cmd "queue.pl -sync y"
      eval "${name}=\"$2\"";

      # Check that Boolean-valued arguments are really Boolean.
      if $was_bool && [[ "$2" != "true" && "$2" != "false" ]]; then
        echo "$0: expected \"true\" or \"false\": $1 $2" 1>&2
        exit 1;
      fi
      shift 2;
      ;;

    *) break;
  esac
done


# remove old
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# yum-utils 提供了命令 yum-config-manager, device-mapper-persistent-data 和 lvm2 由需要 device mapper 存储驱动程序.
yum install -y yum-utils device-mapper-persistent-data lvm2

# yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum-config-manager --add-repo "${docker_repo}"

yum makecache

# list versions
yum list docker-ce --showduplicates | sort -r

# yum install -y docker-ce-19.03.0-3.el7 docker-ce-cli-19.03.0-3.el7 containerd.io
yum install -y docker-ce-${docker_version} docker-ce-cli-${docker_version} containerd.io

yum install -y docker-ce docker-ce-cli containerd.io


# docker data root
#cat << EOF >> /etc/docker/daemon.json
#{
#  "data-root": "/data/lib/docker"
#}
#EOF

# echo -e "{\n\"graph\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json
echo -e "{\n\"data-root\": \"/data/lib/docker\"\n}\n" > /etc/docker/daemon.json

systemctl start docker

