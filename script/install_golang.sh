#!/usr/bin/env bash
#参考链接
#https://golang.google.cn/
#https://blog.csdn.net/weixin_43529465/article/details/122784828
#下载页面
#https://golang.google.cn/dl/
#
#将go命令添加到PATH
#参考链接: https://blog.csdn.net/weixin_42738495/article/details/124405846


# 参数:
system_version="centos";


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


yum install -y wget


if [ "$(uname -m)" == x86_64 ]; then

  mkdir -p /data/dep
  cd /data/dep || exit 1;
  if [ ! -e go1.18.10.linux-amd64.tar.gz ]; then
    wget -P /data/dep https://golang.google.cn/dl/go1.18.10.linux-amd64.tar.gz
  fi

  cd /data/dep || exit 1;
  if [ ! -d go ]; then
    tar -zxvf go1.18.10.linux-amd64.tar.gz
  fi

  /data/dep/go/bin/go version;

  cat ~/.bashrc
  echo "PATH=$PATH:/data/dep/go/bin" >> /root/.bashrc
  source ~/.bashrc

  go version;
fi
