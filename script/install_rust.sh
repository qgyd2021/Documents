#!/usr/bin/env bash

# 参考链接:
# https://code84.com/2322.html

export profile="default"

rustc -v

mkdir -p /data/dep
cd /data/dep || exit 0;

yum -y update
yum -y install curl

# echo | curl https://sh.rustup.rs -sSf | sh
curl https://sh.rustup.rs -sSf > temp_rustup.sh
bash temp_rustup.sh -y
rm -rf temp_rustup.sh

source "$HOME/.cargo/env"

rustc --version
