#!/bin/bash

STIME=100000
ONVAL=0
OFFVAL=1
PINMUX_STATE=7

function set_gpio(){
        echo $PINMUX_STATE > /sys/kernel/debug/omap_mux/${1}
        echo ${1} > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${1}/direction
}

function pin_on(){
        echo $ONVAL > /sys/class/gpio/gpio${1}/value
}

function pin_off(){
        echo $OFFVAL > /sys/class/gpio/gpio${1}/value
}

function flash_once(){
        pin_on $1
        usleep $STIME
        pin_off $1
}

function flash(){
        while true; do flash_once $1; sleep 1; done
}

function gpio_to_pin(){
        expr $1 \* 32 + $2
}

function test_pin(){
        gpio_num=`gpio_to_pin $1 $2`
        set_gpio $gpio_num $3
        flash_once $gpio_num
}

mount -t debugfs none /sys/kernel/debug

test_pin 3 21 'mcasp0_ahclkx'
test_pin 0 18 'usb0_drvvbus'
test_pin 2 0  'gpmc_csn3'
test_pin 0 31 'gpmc_wpn'
test_pin 0 30 'gpmc_wait0'
test_pin 3 5  'i2c0_sda'
test_pin 2 24 'lcd_pclk'
test_pin 2 22 'lcd_vsync'
test_pin 2 23 'lcd_hsync'
test_pin 1 14 'gpmc_ad14'
test_pin 0 27 'gpmc_ad11'
test_pin 0 22 'gpmc_ad8'
test_pin 1 12 'gpmc_ad12'
test_pin 0 23 'gpmc_ad9'
test_pin 2 4  'gpmc_wen'
test_pin 2 5  'gpmc_ben0_cle'
test_pin 2 2  'gpmc_advn_ale'
test_pin 3 8  'emu1'
test_pin 3 7  'emu0'
test_pin 1 8  'uart0_ctsn'
test_pin 1 9  'uart0_rtsn'
test_pin 0 14 'uart1_rxd'
test_pin 0 15 'uart1_txd'
test_pin 0 2  'spi0_sclk'
test_pin 0 3  'spi0_d0'
test_pin 0 4  'spi0_d1'
test_pin 0 5  'spi0_cs0'
test_pin 0 12 'uart1_ctsn'
test_pin 0 13 'uart1_rtsn'
test_pin 0 20 'xdma_event_intr1'
test_pin 0 29 'rmii1_refclk'
test_pin 2 1  'gpmc_clk'
test_pin 3 13 'usb1_drvvbus'
test_pin 3 18 'mcasp0_aclkr'
test_pin 3 19 'mcasp0_fsr'
test_pin 1 15 'gpmc_ad15'
test_pin 1 13 'gpmc_ad13'
test_pin 0 26 'gpmc_ad10'
test_pin 1 28 'gpmc_ben1'
test_pin 3 17 'mcasp0_ahclkr'
test_pin 2 6  'lcd_data0'
test_pin 2 7  'lcd_data1'
test_pin 2 8  'lcd_data2'
test_pin 2 11 'lcd_data5'
test_pin 2 10 'lcd_data4'
test_pin 2 9  'lcd_data3'
test_pin 2 12 'lcd_data6'
test_pin 2 13 'lcd_data7'
test_pin 2 14 'lcd_data8'
test_pin 2 15 'lcd_data9'
test_pin 2 16 'lcd_data10'
test_pin 2 17 'lcd_data11'
test_pin 0 8  'lcd_data12'
test_pin 0 9  'lcd_data13'
test_pin 0 10 'lcd_data14'
test_pin 0 11 'lcd_data15'