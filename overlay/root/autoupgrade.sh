#!/bin/bash
echo  " " #empty line
echo  " " #empty line
echo  "=================NOVOTECH UPGRADER==================" #title line
echo  "Upgrading in 3 seconds, press any key to cancel!"

#/root/flash_led.sh &

if read -t 4 response; then
	echo "Cancelled!"
	/bin/login -f root
else
	echo "Upgrading"
	/root/update_rootfs.sh
	/root/change_boot2rootfs.sh

	sync
        # Reboot: send cmd to stm32 core, request power off for 2 seconds, then power up
        stty -F /dev/ttyO1 speed 115200 raw
        echo -en '\xa5\x01\x81\x0d\x00\x03\x00\x2b\x00\x01\xe7\xc4\x5a' > /dev/ttyO1
	#if reboot cmd fails we should consider to use tps65910 reboot.
	# plz note this will not work with tps65217 (ariaboard and beaglebone)
	#sleep 2
	#echo "TPS65910 rebooting"
	#/usr/sbin/i2cset -f -y 1 0x2d 0x3f 0x71
fi
