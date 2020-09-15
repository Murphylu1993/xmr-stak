#!/bin/bash -uex

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ -d xmr-stak ]; then
  git -C xmr-stak clean -fd
else
  git clone https://github.com/Murphylu1993/xmr-stak.git
fi

wget -c https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
chmod a+x cuda_*_linux-run


########################
# Ubuntu (17.04)
########################
docker run --rm -it -v $PWD:/mnt ubuntu:17.04 /bin/bash -c "
set -x ;
echo \"deb http://old-releases.ubuntu.com/ubuntu disco main universe multiverse restricted\" >  /etc/apt/sources.list ;:
apt update -qq ;
apt install -y -qq libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev ;
cd /mnt/xmr-stak ;
/mnt/cuda_*_linux-run --silent --toolkit ;
cmake -DCUDA_ENABLE=ON -DOpenCL_ENABLE=OFF . ;
make ;
"

test -d ubuntu_17.10 || mkdir ubuntu_17.10
mv xmr-stak/bin/* ubuntu_17.10
git -C xmr-stak clean -fd



########################
# CentOS 7
########################
# CUDA is not going to work on CentOS/RHEL beacuse it's only support gcc-4 in these distributions: http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
#docker run --rm -it -v $PWD:/mnt centos:7 /bin/bash -c "
#set -x ;
#yum install -y -q centos-release-scl epel-release ;
#yum install -y -q cmake3 devtoolset-7-gcc* hwloc-devel libmicrohttpd-devel make openssl-devel perl ;
#scl enable devtoolset-7 - << EOF
#cd /mnt/xmr-stak ;
#cmake3 -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF . ;
#make ;
#EOF
#"

#test -d centos_7 || mkdir centos_7
#mv xmr-stak/bin/* centos_7
#git -C xmr-stak clean -fd


