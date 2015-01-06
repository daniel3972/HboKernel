#!/bin/bash
# Hbohd's program for compiling kernels.

# Basic variables
finaldir=~/aS3/final
data=$(date '+%Y%m%d')
lollidir=~/aS3/kernel_lollipop

# Program
echo "Program kompilujacy i pakujacy kernel"

echo "Wybrales kernel Lollipop, wprowadz wersje w formacie typu <x.x-betax/stable> : "
read ver
echo "$ver" > $lollidir/version
cd ~/Lollipop
export ARCH=arm
echo "Wybierz toolchain"
echo "1 - Linaro"
echo "2 - Google GCC 4.7"
echo "3 - arm-eabi 4.4.3"
read B
case "$B" in
	"1")
		echo "Wybrales Linaro"
    		export CROSS_COMPILE=~/aS3/linaro/bin/arm-cortex_a9-linux-gnueabihf-
    	;;
	"2")
    		echo "Wybrales GCC"
		export CROSS_COMPILE=~/aS3/tc/bin/arm-linux-androideabi-
    	;;
	"3")
		echo "Wybrales arm-eabi 4.4.3"
		export CROSS_COMPILE=~/aS3/arm-eabi-4.4.3/bin/arm-eabi-
	;;
	*)
    		echo "Blad, zacznij od poczatku"
    	;;
esac
echo "Wybierz czy robic full clean, czy nie"
echo "1 - full clean"
echo "2 - bez cleana"
read C
case "$C" in
	"1")
		echo "Czyszcze"
    		make clean
    	;;
	"2")
    		echo "Bez czyszczenia, kompilujemy dalej"
    	;;
	*)
    		echo "Blad, zacznij od poczatku"
    	;;
esac
make hbo_defconfig
make
rm -rf $lollidir/out/*
rm -rf $lollidir/kernel/*
find . -name "*.ko" -exec cp {} $lollidir/skrypt/system/lib/modules \;
cp ~/Lollipop/arch/arm/boot/zImage $lollidir/kernel/
cd $lollidir
./pack_boot.sh
cp $lollidir/out/boot.img $lollidir/skrypt/
cd $lollidir/skrypt
zip -g $finaldir/Lolli.zip boot.img
zip -g $finaldir/Lolli.zip system/lib/modules/*
cp $finaldir/Lolli.zip $finaldir/Lolli1.zip
mv $finaldir/Lolli1.zip $finaldir/i9305-LP-HboKernel-$ver-$data.zip
echo "Zrobione, kernel Lollipop $ver spakowany w folderze $finaldir"


exit
