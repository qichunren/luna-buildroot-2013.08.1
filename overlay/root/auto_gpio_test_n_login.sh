#!/bin/sh

echo  "=================LUNA GPIO TESTER==================" #title line

source /root/am335x_gpio_test.sh

echo  "=================LUNA EMMC FLASHER==================" #title line
echo  "Press any key in 5 sec to drop to command prompt."


if read -t 5 response; then
        echo "Cancelled!"
        /bin/login -f root
else
	/root/auto_flash_emmc.sh
	echo "Done!"
fi

/bin/login -f root
