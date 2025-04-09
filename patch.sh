#!/bin/bash
echo "Start Patching"
## Device Files
flist=""
frockchip="nas.sh"
#frockchip+=" nas2.sh"

fstm32mp1="gateway_mp1.sh"

## Subsystems (Bootloader, Kernel)
slist=""
srockchip="linux"
srockchip+=" u-boot"
srockchip+=" rkbin"

sstm32mp1="linux"
sstm32mp1+=" u-boot"
sstm32mp1+=" atf"
sstm32mp1+=" optee_os"

echo "Patching $VEN"
# Patch System Start Code
if [ "$VEN" = "rockchip" ]; then 

	flist=$frockchip
	slist=$srockchip
fi;
if [ "$VEN" = "stm32mp1" ]; then 
	flist=$fstm32mp1
	slist=$sstm32mp1
fi;

if [ "$flist" = "" ]; then 
	echo "No Valid Vendor selected"
	exit;
fi;
if [ "$slist" = "" ]; then 
	echo "No Subsystem List provided"
	exit;
fi;

cd patches

for subsystem in $slist; do
	cd $subsystem
	for file in $flist; do
		./$file
	done
	cd ..
done

cd ..
