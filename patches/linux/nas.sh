#!/bin/bash
Path=../../build/linux
DTS=nas-rk3568_lp4
Line='dtb-$(CONFIG_ARCH_ROCKCHIP) += '

cp -R nas/* $Path
echo -e "$Line$DTS.dtb"  >> $Path/arch/arm64/boot/dts/rockchip/Makefile
