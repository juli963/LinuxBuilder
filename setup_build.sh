#!/bin/bash

VEN=Rockchip
#VEN=STM32MP1

## Normalize ARCH Variable
export VEN=`echo ${VEN} | tr '[:upper:]' '[:lower:]'`
echo "VEN ${VEN} is selected"


## Check Last selected Vendor
cloneReps=true
if [ -e "build/.vendor" ]; then
	savedFile="$(cat build/.vendor)"
 	if [ "$savedFile" = "$VEN" ]; then 
 		cloneReps=false
 	fi;
fi;
mkdir -p build
cd build


## ARCH = STM32MP1
if [ "$VEN" = "stm32mp1" ]; then 
  echo "Setting up Sourcesystem Rockchip" 
  if [ "$cloneReps" = true ]; then 
	  echo "Cloning Repositories"
		git clone -b 4.5.0 https://github.com/OP-TEE/optee_os/
		git clone -b v2.12.0 https://github.com/ARM-software/arm-trusted-firmware
		git clone -b v2025.01 https://source.denx.de/u-boot/u-boot
		git clone -b v6.14 https://github.com/torvalds/linux
	fi;
	cd ..
	./patch.sh
	echo "$VEN" > build/.vendor
	exit;
fi;


## ARCH = Rockchip 
if [ "$VEN" = "rockchip" ]; then 
  echo "Setting up Sourcesystem Rockchip" 
  if [ "$cloneReps" = true ]; then 
    echo "Cloning Repositories"
		git clone -b rockchip-release https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux
		git clone -b 2025.01-rk3588 https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot
		git clone https://github.com/rockchip-linux/rkbin
	fi;
	cd ..
	./patch.sh
	echo "$VEN" > build/.vendor
	exit;
fi;


echo "Sourcesystem $VEN is NOT a valid Sourecesystem" 
