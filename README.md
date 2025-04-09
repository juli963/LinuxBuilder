# Linux image builder
## Supported platforms
- Rockchip 
	- RK3568
- ST Microelectronics
	- STM32MP1

## Quick start guide
1. Edit `setup_build.sh`
	-  Uncomment Variable VEN to selected Vendor
2. Run `$ ./setup_build.sh`
	- This will clone the correct repositories into directory `/build`. 
	- Then it will execute `patch.sh` this will copy the neccesary changes/files to the supported firmware packages.
	- The build system is now configured for the specific vendor.
3.  `$ cd targets`
4.  Uncomment variable `Rootfs` in your `TARGETBOARD.sh` if you want to include a rootfs image for the rootfs partition.
	- Also check variable `BUILDCORES` -> Adjust this number to the number of your buildsystem CPU cores.
5.  Run `$ ./TARGETBOARD.sh`
	- This will execute all makefiles and copy the outputs into directory `/build/output/TARGETBOARD`.
	- After the compiling it will create a .img file for flashing your microSD card.
6. After compiling you can flash your sd card using dd `sudo dd if=/build/output/TARGETBOARD/TARGETBOARD.img of=/dev/sdXY status=progress && sync`
7. Your microSD is now bootable for the selected Board

## Create own Target Script + Patch
If your vendor already exists, you probably just need to patch your configs and devicetrees to the repositorys and set the variables.
Your Target will be called `YOURBOARD` here, so replace it with the name of your specific Board.

You can find all needed variables and an explanation of the bootflow for your Vendor in `tools/VENDOR/README.md`
1. Use the Example Script of `tools/$VEN/example.sh` and replace all things as explained in `tools/VENDOR/README.md`
2. Create Patches
	- The most neccesary thing ist adding your devicetree. Copy it to `/patches/linux,u-boot,optee.../YOURBOARD` the directory structure must be the same as the corresponding git repository, as just all files will be copied into the git repos.
	- Create  `/patches/linux,u-boot,optee.../YOURBOARD.sh` 
		- Just add an script if you need to patch something. If you need no patch you don't have to do it here.
		- Just copy your directory structure into the subsystem
		- For advanced editing of for example makefiles, implement it in this file. You can echo some extra lines or open nano as editor with the description of what to replace/edit. I personally prefer automatism... 
	- Edit `patch.sh` add to `fVENDOR+=YOURBOARD.sh`

## Create own Vendor Scripts
1. Edit `setup_build.sh`
	- Choose a vendor name for variable `VEN`, it gets normalized to lower letters.
	- Add if statement after `cd build`
	- Look at some of the `if [ "$VEN" = "..." ]; then` statements. 
You need to adjust the needed git clones to the repositorys you need. The best would be mainline repositories. 
	- If you need to patch the repositories you should run `./patch.sh` after cloning	
		- Use this for adding new devicetrees.
	- The last thing would be to write your vendor into `/build/.vendor` file. This will prevent you from cloning the repositories at every run of `setup_build.sh` without changing the `VEN` variable.
2. Edit `patch.sh`
	- Create variable `fYOURVENDOR`, add the name of the target scripts in `/patches`
	- Create variable `sYOURVENDOR`, add the names of the subsystems/bootloader needed by your vendor.
	- Create if statement when `$VEN` is your Vendor and set variable `flist=$fYOURVENDOR` and `slist=$sYOURVENDOR`
3. Implement your compile flow
	- We abstract this into `/tools/$VEN/build_system.sh` 
	- In this Script you need to implement all your calls to make for the firmware compilations.
	- For example, at ST you can compile atf, optee_os, u-boot and linux. For rockchip you get the binary files for atf and DDR controller initialization and you provide them to u-boot. This is another compile flow as ST.
	- Look at the ST and rockchip examples for implementing these.
	- Global variables provided by target script should be:
		`$BUILDCORES` -> Number of CPU cores from build system.
		`$sBoard` -> Name of build target / Board name.
		`$DT` -> Device Tree Name, could be another than `$sBoard`.
		`$VEN` -> Vendor for selection of build system.
		`$linuxARCH` -> will give the ARCH argument for linux make.
		`$Rootfs`-> Optional, will give the name of an rootfs.img file
	- Copy the output products needed for creating a bootable system to `/build/output/$sBoard`
	- Optional but nice, call `/tools/$VEN/create_sd_extlinux_image.sh`
		This script is also vendor specific and should create a bootable sd image with extlinux bootflow.
4. Optional but nice, implement the creation of an SD image
	- Create `create_sd_extlinux_image.sh` File this should implement the following steps:
		1. Check if `$Rootfs` is set, else create an empty partition for rootfs.
		2. Create empty file `$sBoard.img` with the size of bootfirmware + rootfs (actually if no rootfs provided I create an empty 10MB ext4 partition for it.
		3. Create the partitiontable for `$sBoard.img` the specific sectors for it are platform/vendor dependent.
		4. Write your bootloader images to `$sBoard.img`
		5. Create extlinux.img file with extlinux.conf, devicetrees and linux kernel and write it to the extlinux partition of `$sBoard.img`
		6. Write the rootfs to `$sBoard.img`
		7. Remove all temporary used files ;)
## ToDo's
- Implement more Boards
- Create a flow for creating rootfs.img
- Create efi bootflow images
- Explain everything better
- More examples
- README.md's for `tools/VENDOR`

