#!/bin/bash
#flash led during upgrading
mount -t debugfs none /sys/kernel/debug



echo 7 >  /sys/kernel/debug/omap_mux/usb0_drvvbus
echo 7 >  /sys/kernel/debug/omap_mux/mcasp0_ahclkx

echo 117 > /sys/class/gpio/export
echo 18  > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio117/direction
echo out > /sys/class/gpio/gpio18/direction

while true; 
do
	echo 1 > /sys/class/gpio/gpio117/value
	echo 0 > /sys/class/gpio/gpio18/value

	sleep 3
	echo 0 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 1 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 0 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 1 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 0 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 1 > /sys/class/gpio/gpio117/value; usleep 40000
	echo 0 > /sys/class/gpio/gpio117/value; usleep 40000
done
