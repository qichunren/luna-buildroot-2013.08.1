#!/bin/sh

set -xe

/usr/bin/xzcat /root/emmc.img.xz | dd of=/dev/mmcblk1 bs=1M

