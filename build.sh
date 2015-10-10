#!/bin/bash

KERNEL_DIR="/home/gustavo/kernel-msm"
STRIP="/home/gustavo/toolchain/bin/arm-linux-androideabi-strip"
MODULES=("/home/gustavo/kernel-msm/drivers/char/adsprpc.ko" "/home/gustavo/kernel-msm/drivers/scsi/scsi_wait_scan.ko" "/home/gustavo/kernel-msm/drivers/misc/utag/utags.ko" "/home/gustavo/kernel-msm/drivers/staging/prima_mmi/wlan.ko" )
MODULES_DIR="/home/gustavo/kernel-msm/out/anykernel2/modules"
ZIMAGE="/home/gustavo/kernel-msm/arch/arm/boot/zImage"
ZIMAGE2="/home/gustavo/kernel-msm/out/anykernel2/zImage"
ZIP_DIR="/home/gustavo/kernel-msm/out/anykernel2"
CURRENTDATE=$(date +"%d-%m")


case "$1" in
	clean)
        cd ${KERNEL_DIR}
        make clean && make mrproper
		;;
	build)
        # build the kernel
        cd ${KERNEL_DIR}
        cp ./arch/arm/configs/msm8960dt_mmi_defconfig ./.config
        make -j3
        # strip modules
        for module in "${MODULES[@]}" ; do
            cp "${module}" ${MODULES_DIR}
            ${STRIP} --strip-unneeded ${MODULES_DIR}/*
        done
        # build boot.img
        cp ${ZIMAGE} ${ZIMAGE2}
		echo "Creating kernel zip..."
		cd ${ZIP_DIR}
        zip -r Kernel-$CURRENTDATE.zip ./ -x *.zip *.gitignore *EMPTY_DIRECTORY
        rm ${ZIMAGE2}

		echo "Done!"
	    ;;
esac
