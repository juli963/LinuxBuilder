#!/bin/bash
#DT=nas-rk3568_lp4
#VEN=rockchip
#sBoard=nas-rk3568
cd ../../build/output/$sBoard
rm $sBoard.img

## Read Rootfs.img, if not provided create an empty 10MB File
Rootsize=0
if [ -n "$Rootfs" ]; then	# Var is set get rootfs size
	#du -schmb $Rootfs
	Rootsize=$(stat -c%s "$Rootfs") # Size in Bytes
	Rootsize=$(($Rootsize/1000000))
	echo "Size of $Rootfs = $Rootsize Mbytes."
	#echo -n "ENTER Size in MByte: "
	#read Rootsize
else
	Rootsize=10
	sudo dd if=/dev/zero of=rootfs.img bs=1MB count=10
	sudo mkfs -t ext4 rootfs.img
	Rootfs=rootfs
fi;

if [[ ! $Rootsize =~ ^[0-9]+$ ]] ; then
    echo "No Number"
    exit
fi;

## Create empty.img file with the right size
Size=$(($Rootsize+128))
sudo dd if=/dev/zero of=$sBoard.img bs=1M count=$Size
(($? != 0)) && { printf '%s\n' "Can't create $sBoard.img"; exit 1; }

## Create Partitiontable
sudo sgdisk \
-n 2:16384:+4M -c 2:"uboot" \
-n 3:24576:+4M -c 3:"trust" \
-n 4:32768:+112M -c 4:"boot" -A 4:set:2 \
-n 5:262144: -c 5:"rootfs" -u 5:B921B045-1DF0-41C3-AF44-4C6F280D3FAE \
-p $sBoard.img -g

# Create Extlinux Partition Image 112MB Size
sudo dd if=/dev/zero of=extlinux.img bs=1MB count=112
(($? != 0)) && { printf '%s\n' "Can't create extlinux Image"; exit 1; }
sudo mkfs -t vfat -F 32 extlinux.img
sudo mkdir -p mnt
sudo mount -t auto -o loop extlinux.img $PWD/mnt
(($? != 0)) && { printf '%s\n' "Can't mount extlinux Image"; exit 1; }
sudo mkdir -p mnt/extlinux
sudo cp extlinux.conf mnt/extlinux/extlinux.conf
sudo cp Image_linux mnt/Image
sudo cp $DT.dtb mnt/$DT.dtb
sudo umount $PWD/mnt

# Write Images to Image File
sudo dd if=u-boot-$VEN.bin of=$sBoard.img seek=64 conv=notrunc
(($? != 0)) && { printf '%s\n' "Can't write U-boot Image"; exit 1; }
sudo dd if=extlinux.img of=$sBoard.img seek=32768 conv=notrunc
(($? != 0)) && { printf '%s\n' "Can't write extlinux Image"; exit 1; }
sudo dd if=$Rootfs of=$sBoard.img seek=262144 conv=notrunc
(($? != 0)) && { printf '%s\n' "Can't write Rootfs"; exit 1; }

# Remove all work Files
sudo rm -f extlinux.img
sudo rm -f rootfs.img
sudo rm -rf mnt
sudo chmod 777 $sBoard.img

#dd if=/dev/zero bs=1M count=400 >> ./binary.img
#parted binary.img
#resize 1

## dd if=$Image of=/dev/sdeXY
