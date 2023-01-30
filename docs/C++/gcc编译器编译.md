## gcc编译器编译


```text
参考链接: 
https://github.com/gcc-mirror/gcc/tags


```


启动容器
```text
docker run --name gcc-11.1.0 -itd daocloud.io/centos:7 /bin/bash
mkdir -p /data/tianxing
cd /data/tianxing

yum install -y which
yum install -y wget
yum install -y git
yum install -y zip unzip
yum install -y lrzsz
yum install -y tmux
yum install -y bzip2

```



安装 cmake
```text
# CentOS 7 安装 cmake
# cmake 下载
# https://cmake.org/download/
# https://cmake.org/files/

cd /data/tianxing/
wget https://cmake.org/files/v3.24/cmake-3.24.2-linux-x86_64.tar.gz

tar -zxvf cmake-3.24.2-linux-x86_64.tar.gz

cd cmake-3.24.2-linux-x86_64

# usr/bin/cmake
/data/tianxing/cmake-3.24.2-linux-x86_64/bin/cmake --version
cmake version 3.24.2

# 软链接
ln -s /data/tianxing/cmake-3.24.2-linux-x86_64/bin/cmake /usr/bin/cmake
ln -s /data/tianxing/cmake-3.24.2-linux-x86_64/bin/ccmake /usr/bin/ccmake

cmake --version
ccmake --version

```



安装 gcc
```text

wget https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-11.1.0.zip

unzip gcc-11.1.0.zip

cd gcc-releases-gcc-11.1.0/

./contrib/download_prerequisites

ls | grep tar

tar -xf gmp-6.1.0.tar.bz2
tar -xf isl-0.18.tar.bz2
tar -xf mpc-1.0.3.tar.gz
tar -xf mpfr-3.1.4.tar.bz2

ln -sf gmp-6.1.0 gmp
ln -sf isl-0.18 isl
ln -sf mpc-1.0.3 mpc
ln -sf mpfr-3.1.4 mpfr

# 检查基础依赖
yum install -y gcc automake autoconf libtool make
yum install -y m4
yum install -y glibc-headers
yum install -y gcc-c++
yum install -y flex
yum install -y zlib zlib-devel



创建 build 目录
mkdir build && cd build

配置
../configure \
--prefix=/usr \
--enable-bootstrap \
--enable-languages=c,c++,fortran,lto \
--enable-shared \
--enable-threads=posix \
--enable-checking=release \
--enable-multilib \
--with-system-zlib \
--enable-__cxa_atexit \
--disable-libunwind-exceptions \
--enable-gnu-unique-object \
--enable-linker-build-id \
--with-gcc-major-version-only \
--with-linker-hash-style=gnu \
--with-default-libstdcxx-abi=gcc4-compatible \
--enable-plugin \
--enable-initfini-array \
--disable-libmpx \
--enable-gnu-indirect-function \
--with-tune=generic \
--with-arch_32=x86-64 \
--build=x86_64-redhat-linux


安装32位兼容包
yum install -y glibc-devel.i686

查看cpu核数
export THREADS=$(grep -c ^processor /proc/cpuinfo)

安装
make -j $THREADS
make install -j $THREADS


```


