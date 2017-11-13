#!/bin/bash

set -x

DIR=`pwd`
PRODUCT_TYPE="Paigo" # Default product type is "Paigo"
MMC_DEV=/dev/mmcblk0
BOOTFS_PART=${MMC_DEV}p1
ROOTFS_PART=${MMC_DEV}p2
VARDIR_PART=${MMC_DEV}p4

BOOTFS_PATH=/tmp/bootfs
ROOTFS_PATH=/tmp/rootfs
VARDIR_PATH=/tmp/vardir

if [ ! -f "/tmp/paigo-gpio.tmp" ]; then
    echo "56" >/sys/class/gpio/export
    echo "out" >/sys/class/gpio/gpio56/direction
    echo "1" >/sys/class/gpio/gpio56/value

    echo "65" >/sys/class/gpio/export
    echo "out" >/sys/class/gpio/gpio65/direction 
    echo "1" >/sys/class/gpio/gpio65/value

    echo "48" >/sys/class/gpio/export
    echo "out" >/sys/class/gpio/gpio48/direction
    echo "1" >/sys/class/gpio/gpio48/value


    echo "55" > /sys/class/gpio/export
    echo "in" >/sys/class/gpio/gpio55/direction 

    echo "49" > /sys/class/gpio/export
    echo "in" >/sys/class/gpio/gpio49/direction 

    echo "50" > /sys/class/gpio/export
    echo "out" >/sys/class/gpio/gpio50/direction 

    echo "51" > /sys/class/gpio/export
    echo "out" >/sys/class/gpio/gpio51/direction

    touch "/tmp/paigo-gpio.tmp"
fi

/usr/bin/amixer sset 'Left Line Mixer Line2L Bypass' off || true
/usr/bin/amixer sset 'Left Line Mixer Line2R Bypass' mute || true
/usr/bin/amixer sset 'PCM' 100% || true
/usr/bin/amixer sset 'Line DAC' 100% || true
/usr/bin/amixer sset 'Line' on || true

mount_parts(){
  ## make dir if missing
  mkdir -p ${BOOTFS_PATH}
  mkdir -p ${ROOTFS_PATH}
  mkdir -p ${VARDIR_PATH}

  ## mount to correct dir
  mount ${BOOTFS_PART} ${BOOTFS_PATH}
  mount ${VARDIR_PART} ${VARDIR_PATH} #we don't need update var!
  
  ## Get product_type info, get /boot/uboot/product_type file first line content
  product_type=$(head -n 1 ${BOOTFS_PATH}/product_type 2>/dev/null)
}

update_parts(){
  ##get parts
  if [ -f ${VARDIR_PATH}/dl/rootfs.tar.xz ]; then
    echo "Detected rootfs package, flashing rootfs..."
    #flash parts
    mkfs.ext4 ${ROOTFS_PART}

    if [ $? != "0" ]; then
        if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-cn.wav" ! decodebin ! alsasink || true
        elif [ "$product_type" = "Augie" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-en.wav" ! decodebin ! alsasink || true
        fi
        exit 1
    fi

    mount ${ROOTFS_PART} ${ROOTFS_PATH}
    if [ $? != "0" ]; then
        if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-cn.wav" ! decodebin ! alsasink || true
        elif [ "$product_type" = "Augie" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-en.wav" ! decodebin ! alsasink || true
        fi
        exit 2
    fi

    cd ${ROOTFS_PATH}
    xzcat ${VARDIR_PATH}/dl/rootfs.tar.xz | tar xv
    if [ $? != "0" ]; then
        if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-cn.wav" ! decodebin ! alsasink || true
        elif [ "$product_type" = "Augie" ]; then
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
            /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-en.wav" ! decodebin ! alsasink || true
        fi
        exit 3
    fi
  
    if [ -f ${VARDIR_PATH}/dl/kmods.tar.xz ]; then
      xzcat ${VARDIR_PATH}/dl/kmods.tar.xz | tar xv
      if [ $? != "0" ]; then
	if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
	    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
	    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-cn.wav" ! decodebin ! alsasink || true
	elif [ "$product_type" = "Augie" ]; then
	    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
	    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-en.wav" ! decodebin ! alsasink || true
	fi
	exit 4
      fi
      cp ${VARDIR_PATH}/dl/kmods.tar.xz ${BOOTFS_PATH}/latest-kmods.tar.xz
    else
      if [ -f ${BOOTFS_PATH}/latest-kmods.tar.xz ]; then
        xzcat ${BOOTFS_PATH}/latest-kmods.tar.xz | tar xv
        if [ $? != "0" ]; then
		if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
		    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
		    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-cn.wav" ! decodebin ! alsasink || true
		elif [ "$product_type" = "Augie" ]; then
		    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrade-failed.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
		    /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrade-failed-en.wav" ! decodebin ! alsasink || true
		fi
	        exit 5
         fi
      fi
    fi
 
    #we don't need update var!
    rm ${ROOTFS_PATH}/var/* -rf
  else
    echo "No update packages, skipping."
  fi

  if [ -f ${VARDIR_PATH}/dl/uImage ]; then
    echo "Detected kernel uImage, updating kernel..."  
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

if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgrading.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrading-cn.wav" ! decodebin ! alsasink || true
elif [ "$product_type" = "Augie" ]; then
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgrading.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgrading-en.wav" ! decodebin ! alsasink || true
fi

update_parts
#verify
cleaning
umount_parts

if [ "$product_type" = "" ] || [ "$product_type" = "Paigo" ]; then
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/cn/paigo-upgraded.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgraded-cn.wav" ! decodebin ! alsasink || true
elif [ "$product_type" = "Augie" ]; then
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/images/en/paigo-upgraded.png" ! pngdec ! videoconvert ! fbdevsink device="/dev/fb0" || true
  /usr/bin/gst-launch-1.0 filesrc location="/usr/share/sounds/system-upgraded-en.wav" ! decodebin ! alsasink || true
fi
