#!/bin/bash

#export Rootfs=$PWD/../distro/debian_arm64.img
export BUILDCORES=24

export sBoard=gateway_mp1
export DT=gateway_stm32mp13
export VEN=stm32mp1
export linuxARCH=arm


cd ../tools/$VEN/
./build_system.sh

## Create extlinux
Line="
label gateway-kernel
    kernel /Image
    fdt /${DT}.dtb
    append earlyprintk rw root=/dev/mmcblk0p3 rootwait rootfstype=ext4 init=/sbin/init
"
touch ../../build/output/$sBoard/extlinux.conf
echo -e "$Line"  >> ../../build/output/$sBoard/extlinux.conf

## Create SDCardImage with extlinux bootflow
./create_sd_extlinux_image.sh
