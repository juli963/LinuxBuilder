#!/bin/bash
Path=../../build/linux
DTS=gateway_stm32mp13
Line='dtb-$(CONFIG_ARCH_STM32) += '

cp -R gateway_mp1/* $Path
echo -e "$Line$DTS.dtb"  >> $Path/arch/arm/boot/dts/st/Makefile
