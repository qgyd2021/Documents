#!/usr/bin/env bash
# 参考链接:
# https://m.runoob.com/lua/lua-environment.html
#
curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
tar zxf lua-5.3.0.tar.gz
cd lua-5.3.0
make linux test
make install