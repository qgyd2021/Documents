#!/usr/bin/env bash

#在以下路径找到对应版本, 获得安装命令.
#https://developer.nvidia.com/cuda-toolkit-archive
#
#参考链接:
#https://www.cnblogs.com/yuezc/p/12937239.html
#
#[root@nlp dep]# sh cuda_10.2.89_440.33.01_linux.run --override
#===========
#= Summary =
#===========
#
#Driver:   Installed
#Toolkit:  Installed in /usr/local/cuda-10.2/
#Samples:  Installed in /home/admin/, but missing recommended libraries
#
#Please make sure that
# -   PATH includes /usr/local/cuda-10.2/bin
# -   LD_LIBRARY_PATH includes /usr/local/cuda-10.2/lib64, or, add /usr/local/cuda-10.2/lib64 to /etc/ld.so.conf and run ldconfig as root
#
#To uninstall the CUDA Toolkit, run cuda-uninstaller in /usr/local/cuda-10.2/bin
#To uninstall the NVIDIA Driver, run nvidia-uninstall
#
#Please see CUDA_Installation_Guide_Linux.pdf in /usr/local/cuda-10.2/doc/pdf for detailed information on setting up CUDA.
#Logfile is /var/log/cuda-installer.log


yum install -y wget rpm
sudo yum install epel-release

wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-rhel7-11-7-local-11.7.0_515.43.04-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel7-11-7-local-11.7.0_515.43.04-1.x86_64.rpm
sudo yum clean all
sudo yum -y install nvidia-driver-latest-dkms cuda
sudo yum -y install cuda-drivers

nvidia-smi
