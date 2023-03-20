#!/usr/bin/env bash

# windows 平台的 git bash 安装 wget 命令
#
# 参考链接:
# https://blog.csdn.net/weixin_41010198/article/details/97142997


cd '/c/Program Files' || exit 1;
curl -R -O https://eternallybored.org/misc/wget/releases/old/wget-1.20.3-win64.zip
unzip wget-1.20.3-win64.zip
mv wget-1.20.3-win64/wget.exe '/c/Program Files/Git/mingw64/bin/wget.exe'
rm -rf wget-1.20.3-win64.zip wget-1.20.3-win64

