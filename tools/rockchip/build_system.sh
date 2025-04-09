#!/bin/bash
mkdir -p ../../build/output
mkdir -p ../../build/output/$sBoard

# Create U-Boot + TPL + SPL
cd ../../build/u-boot

make ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- ${sBoard}_defconfig
(($? != 0)) && { printf '%s\n' "Writing U-Boot Config Failed"; exit 1; }
make ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- -j$BUILDCORES
(($? != 0)) && { printf '%s\n' "Compiling U-Boot failed"; exit 1; }

cp u-boot-rockchip.bin ../output/$sBoard/u-boot-$VEN.bin

# Create Linux Image and Devicetree
cd ../linux
make ARCH=$linuxARCH CROSS_COMPILE=aarch64-linux-gnu- ${sBoard}_linux_defconfig
(($? != 0)) && { printf '%s\n' "Writing Linux Config Failed"; exit 1; }
make ARCH=$linuxARCH CROSS_COMPILE=aarch64-linux-gnu- -j$BUILDCORES
(($? != 0)) && { printf '%s\n' "Compiling Linux failed"; exit 1; }

cp arch/arm64/boot/Image ../output/$sBoard/Image_linux
cp arch/arm64/boot/dts/rockchip/$DT.dtb ../output/$sBoard/$DT.dtb

cd ../../tools/${VEN}

