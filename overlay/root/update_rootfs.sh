#!/bin/bash

set -xe

DIR=`pwd`
MMC_DEV=/dev/mmcblk0
ROOTFS_PART=${MMC_DEV}p2
VARDIR_PART=${MMC_DEV}p4

ROOTFS_PATH=/tmp/rootfs
VARDIR_PATH=/tmp/vardir


mount_parts(){
  ## make dir if missing
  mkdir -p ${ROOTFS_PATH}
  mkdir -p ${VARDIR_PATH}

  ## mount to correct dir
  mount ${ROOTFS_PART} ${ROOTFS_PATH}
  mount ${VARDIR_PART} ${VARDIR_PATH}
}

update_parts(){
  ##get parts
  if [ -f ${VARDIR_PATH}/dl/rootfs.tar.xz ]; then
    echo "Already dl'ed."
  else
    echo "No update packages, skipping."
  fi

  #flash parts 
  cd ${ROOTFS_PATH}
  rm -rf *
  xzcat ${ROOTDIR_PATH}/dl/rootfs.tar.xz | tar xv

  cd ${ROOTFS_PATH}/var
  rm -rf *

}

cleaning(){
  rm ${VARDIR_PATH}/dl/rootfs.tar.xz || true
}

verify(){
  sed -i "s/mmcblk0p3/mmcblk0p2/g" ${BOOTFS_PATH}/uEnv.txt
}

umount_parts(){
  cd ${DIR}
  umount ${ROOTFS_PART} || true
  umount ${VARDIR_PART} || true
}

#do the job
umount_parts
mount_parts
update_parts
#verify
cleaning
umount_parts
