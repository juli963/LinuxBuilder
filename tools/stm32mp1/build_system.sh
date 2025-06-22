#!/bin/bash
mkdir -p ../../build/output
mkdir -p ../../build/output/$sBoard
set -e

# Create U-Boot + TPL + SPL
echo "Start Building U-Boot"
cd ../../build/u-boot

#make clean
#make distclean
#make mrproper

#make ARCH=arm LOG_LEVEL=7 CROSS_COMPILE=arm-linux-gnueabihf- -j $BUILDCORES ${sBoard}_defconfig all
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j $BUILDCORES ${sBoard}_defconfig all
(($? != 0)) && { printf '%s\n' "Configuring and Compiling U-Boot Failed"; exit 1; }

## Create Optee
echo "Start Building OPTee OS"
cd ../optee_os
#rm -r out
#make clean
#make CFG_TEE_CORE_LOG_LEVEL=3 CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm CROSS_COMPILE_core=arm-linux-gnueabihf- CROSS_COMPILE_ta_arm32=arm-linux-gnueabihf- -j $BUILDCORES STM32MP1_OPTEE_IN_SYSRAM=1 PLATFORM=stm32mp1-${sBoard}
make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm CROSS_COMPILE_core=arm-linux-gnueabihf- CROSS_COMPILE_ta_arm32=arm-linux-gnueabihf- -j $BUILDCORES STM32MP1_OPTEE_IN_SYSRAM=1 PLATFORM=stm32mp1-${sBoard}

## Create ATF
echo "Start Building TF-A"
cd ../arm-trusted-firmware
#make clean
#make distclean

#make ARM_ARCH_MAJOR=7 ARCH=aarch32 PLAT=stm32mp1 AARCH32_SP=optee LOG_LEVEL=50 LCROSS_COMPILE=arm-none-eabi- -j$BUILDCORES \
make ARM_ARCH_MAJOR=7 ARCH=aarch32 PLAT=stm32mp1 AARCH32_SP=optee LCROSS_COMPILE=arm-none-eabi- -j$BUILDCORES \
DTB_FILE_NAME=${DT}.dtb STM32MP_SDMMC=1 STM32MP1_OPTEE_IN_SYSRAM=1

## Create FIP
echo "Start Building FIP"
#make ARM_ARCH_MAJOR=7 ARCH=aarch32 PLAT=stm32mp1 AARCH32_SP=optee LOG_LEVEL=50 CROSS_COMPILE=arm-none-eabi- -j$BUILDCORES \
make ARM_ARCH_MAJOR=7 ARCH=aarch32 PLAT=stm32mp1 AARCH32_SP=optee CROSS_COMPILE=arm-none-eabi- -j$BUILDCORES \
STM32MP1_OPTEE_IN_SYSRAM=1 \
BL32=../optee_os/out/arm-plat-stm32mp1/core/tee-header_v2.bin \
BL32_EXTRA1=../optee_os/out/arm-plat-stm32mp1/core/tee-pager_v2.bin \
BL32_EXTRA2=../optee_os/out/arm-plat-stm32mp1/core/tee-pageable_v2.bin \
DTB_FILE_NAME=${DT}.dtb \
BL33=../u-boot/u-boot-nodtb.bin \
BL33_CFG=../u-boot/u-boot.dtb fip

## Copy Output Products
cp build/stm32mp1/release/fip.bin ../output/${sBoard}/fip.bin
cp build/stm32mp1/release/tf-a-${DT}.stm32 ../output/${sBoard}/tf-a-${sBoard}.stm32

# Create Linux Image and Devicetree
cd ../linux
make ARCH=$linuxARCH CROSS_COMPILE=arm-none-eabi- ${sBoard}_linux_defconfig
#(($? != 0)) && { printf '%s\n' "Writing Linux Config Failed"; exit 1; }
make ARCH=$linuxARCH CROSS_COMPILE=arm-none-eabi- -j$BUILDCORES
#(($? != 0)) && { printf '%s\n' "Compiling Linux failed"; exit 1; }

cp arch/arm/boot/zImage ../output/$sBoard/Image_linux
cp arch/arm/boot/dts/st/$DT.dtb ../output/$sBoard/$DT.dtb

cd ../../tools/${VEN}

