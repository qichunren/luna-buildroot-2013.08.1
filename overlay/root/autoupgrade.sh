#!/bin/bash
echo  " " #empty line
echo  " " #empty line
echo  "=================LUNA UPGRADER==================" #title line
echo  "Upgrading in 3 seconds, press any key to cancel!"

/root/flash_led.sh &

if read -t 4 response; then
	echo "Cancelled!"
	/bin/login -f root
else
	echo "Upgrading"
	/boot/uboot/update_rootfs.sh
	/boot/uboot/change_boot2rootfs.sh
	reboot
fi

