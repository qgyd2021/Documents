#!/usr/bin/env bash

# 参考链接:
# https://www.runoob.com/redis/redis-install.html
# https://github.com/tporadowski/redis/releases


# windows 平台的 git bash 安装 wget 命令
#
# 参考链接:
# https://blog.csdn.net/weixin_41010198/article/details/97142997
#
#cd '/c/Program Files' || exit 1;
#curl -R -O https://eternallybored.org/misc/wget/releases/old/wget-1.20.3-win64.zip
#unzip wget-1.20.3-win64.zip
#mv wget-1.20.3-win64/wget.exe '/c/Program Files/Git/mingw64/bin/wget.exe'
#rm -rf wget-1.20.3-win64.zip wget-1.20.3-win64


# 参数:
system_version="windows";

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

echo "system_version: ${system_version}";

if [ ${system_version} = "windows" ]; then
  echo "system_version: ${system_version}";
  wget -P C:/Program20%Files https://github.com/tporadowski/redis/releases/download/v5.0.14.1/Redis-x64-5.0.14.1.zip
  cd C:/Program20%Files || exit 1;
  unzip -d Redis-x64-5.0.14.1 Redis-x64-5.0.14.1.zip
  rm -rf Redis-x64-5.0.14.1.zip
  "C:/Program20%Files/Redis-x64-5.0.14.1/redis-server.exe" "C:/Program20%Files/redis.windows.conf"

fi
