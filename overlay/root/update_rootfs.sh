#!/bin/bash

set -xe

DIR=`pwd`
MMC_DEV=/dev/mmcblk0
BOOTFS_PART=${MMC_DEV}p1
ROOTFS_PART=${MMC_DEV}p2
VARDIR_PART=${MMC_DEV}p4

BOOTFS_PATH=/tmp/bootfs
ROOTFS_PATH=/tmp/rootfs
VARDIR_PATH=/tmp/vardir


mount_parts(){
  ## make dir if missing
  mkdir -p ${BOOTFS_PATH}
  mkdir -p ${ROOTFS_PATH}
  mkdir -p ${VARDIR_PATH}

  ## mount to correct dir
  mount ${BOOTFS_PART} ${BOOTFS_PATH}
  mount ${VARDIR_PART} ${VARDIR_PATH} #we don't need update var!
}

update_parts(){
  ##get parts
  if [ -f ${VARDIR_PATH}/dl/rootfs.tar.xz ]; then
    echo "Already dl'ed."
  else
    echo "No update packages, skipping."
  fi

  #flash parts
  mkfs.ext4 ${ROOTFS_PART}
  mount ${ROOTFS_PART} ${ROOTFS_PATH}

  cd ${ROOTFS_PATH}
  xzcat ${VARDIR_PATH}/dl/rootfs.tar.xz | tar xv
  
  if [ -f ${VARDIR_PATH}/dl/kmods.tar.xz ]; then
    xzcat ${VARDIR_PATH}/dl/kmods.tar.xz | tar xv
  fi
 
  #we don't need update var!
  cd ${ROOTFS_PATH}/var 
  rm -rf *

  if [ -f ${VARDIR_PATH}/dl/uImage ]; then
    cp ${VARDIR_PATH}/dl/uImage ${BOOTFS_PATH}/uImage
  fi
}

cleaning(){
  rm ${VARDIR_PATH}/dl/rootfs.tar.xz || true
  rm ${VARDIR_PATH}/dl/kmods.tar.xz || true
  rm ${VARDIR_PATH}/dl/uImage || true
}

verify(){
  sed -i "s/mmcblk0p3/mmcblk0p2/g" ${BOOTFS_PATH}/uEnv.txt
  sed -i "s/{mmcrescuefs}/{mmcrootfs}/g" ${BOOTFS_PATH}/uEnv.txt
}

umount_parts(){
  cd ${DIR}
  umount ${BOOTFS_PART} || true
  umount ${ROOTFS_PART} || true
  umount ${VARDIR_PART} || true #we don't need update var!
}

#do the job
umount_parts
mount_parts
update_parts
#verify
cleaning
umount_parts
