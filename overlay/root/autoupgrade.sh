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
	reboot

	#if reboot cmd fails we should consider to use tps65910 reboot.
	# plz note this will not work with tps65217 (ariaboard and beaglebone)
	#sleep 2
	#echo "TPS65910 rebooting"
	#/usr/sbin/i2cset -f -y 1 0x2d 0x3f 0x71
fi
