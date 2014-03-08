#!/bin/sh

cd /opt

rm -rf gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz

wget https://launchpad.net/linaro-toolchain-binaries/trunk/2013.04/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz

tar -xf gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz

echo 'export PATH=${PATH}:/opt/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux/bin' >> /root/.bashrc

apt-get install -y mercurial bc

