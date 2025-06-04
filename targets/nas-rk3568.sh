#!/bin/bash

#export Rootfs=$PWD/../distro/debian_arm64.img
export BUILDCORES=24
export create_debpkg=true

## For Rockchip Platforms define DDRBinary (TPL) and BL31
ROCKCHIP_DDR_FNAME=nas_rk3568_lpddr4_1560MHz_v1.23
export sBoard=nas-rk3568
export DT=nas-rk3568_lp4
export VEN=rockchip
export linuxARCH=arm64

ROCKCHIP_DDR_TOOL=${PWD}/../build/rkbin/tools/ddrbin_tool.py
ROCKHIP_DDR_CONFIG_PATH=${PWD}/../build/rkbin/configs/
ROCKHIP_DDR_BIN_PATH=${PWD}/../build/rkbin/bin/rk35/

# Activate this line if we need to adjust DDR Configuration
#python3 ${ROCKCHIP_DDR_TOOL} rk3568 ${ROCKHIP_DDR_CONFIG_PATH}${ROCKCHIP_DDR_FNAME}.txt ${ROCKHIP_DDR_BIN_PATH}${ROCKCHIP_DDR_FNAME}.bin

export ROCKCHIP_TPL=${ROCKHIP_DDR_BIN_PATH}${ROCKCHIP_DDR_FNAME}.bin
export BL31=${ROCKHIP_DDR_BIN_PATH}rk3568_bl31_v1.44.elf

## Create and Setup Docker Image
source ../tools/docker/setup.sh
docker_setup

cd ../tools/$VEN/
./build_system.sh

## Create extlinux file
Line="
label nas-kernel
    kernel /Image
    fdt /${DT}.dtb
    append earlyprintk rw root=/dev/mmcblk0p4 rootwait rootfstype=ext4 init=/sbin/init
"
touch ../../build/output/$sBoard/extlinux.conf
echo -e "$Line"  >> ../../build/output/$sBoard/extlinux.conf

## Create SDCardImage with extlinux bootflow
./create_sd_extlinux_image.sh
