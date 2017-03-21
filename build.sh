#
# Copyright © 2016, Rishabh Rao "rishabhrao" <admin@rishabhrao.net>
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it

# Initialization Script
: ${KERNEL_DIR:=$PWD}
export PATH=$PATH:$KERNEL_DIR
export PATH=$PATH:$KERNEL_DIR/../aarch64-linux-android-4.9
export PATH=$PATH:$KERNEL_DIR/../aarch64-linux-android-4.9/bin
PATH=$PATH$( find $KERNEL_DIR/../aarch64-linux-android-4.9 -type d -printf ":%p" )
IMAGE=$KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
DEFCONFIG=andromodx_defconfig
: ${JOBS:=32}
BUILD_START=$(date +"%s")

# Color Code Script
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
nocol='\033[0m'         # Default

# Variables
NAME=AndroModX
VERSION=2.0
DATE=$( date +'%d%m%Y' )

# Tweakable Options
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="rishabhrao"
export KBUILD_BUILD_HOST="AndroModX"
export CROSS_COMPILE="aarch64-linux-android-"
DEFCONFIG=andromodx_defconfig
IMAGE=$KERNEL_DIR/lazyflasher/Image.gz-dtb
JOBS=64

# Compilation Scripts Are Below
compile_kernel ()
{
# Clean Directories
echo -e "$White***********************************************"
echo "       Cleaning Kernel Directories                      "
echo -e "***********************************************$nocol"
OUTPUT_ZIP=$KERNEL_DIR/lazyflasher/$NAME-$VERSION-$DATE.zip
rm -fdr $KERNEL_DIR/lazyflasher/$NAME-*.zip
rm -fdr $KERNEL_DIR/lazyflasher/Image.gz-dtb
make clean && make mrproper
if [ -a $OUTPUT_ZIP ];
then
echo -e "$Red Cleaning Kernel Directories Failed! Fix the Errors! $nocol"
exit 1
else
echo -e "$Yellow Directories Cleaned Successfully.$nocol"
fi

# Building AndroModX Kernel
echo -e "$White***********************************************"
echo "         Compiling AndroModX Kernel                     "
echo -e "***********************************************$nocol"
make $DEFCONFIG
make -j$JOBS
make -j$JOBS modules
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $KERNEL_DIR/lazyflasher/Image.gz-dtb
if ! [ -a $IMAGE ];
then
echo -e "$Red AndroModX Kernel Compilation Failed! Fix the Errors! $nocol"
exit 1
else
echo -e "$Yellow AndroModX Kernel Compiled Successfully.$nocol"
fi

# Building AndroModX Installer
echo -e "$White***********************************************"
echo "     Building AndroModX Installer                 "
echo -e "***********************************************$nocol"
OUTPUT_ZIP=$KERNEL_DIR/lazyflasher/$NAME-$VERSION-$DATE.zip
cd $KERNEL_DIR/lazyflasher
make
if ! [ -a $OUTPUT_ZIP ];
then
echo -e "$Red Kernel Compilation Failed! Fix the Errors! $nocol"
exit 1
fi
}

# Finalizing Script Below
case $1 in
clean)
make ARCH=arm64 -j$JOBS clean mrproper
;;
*)
compile_kernel
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "*******************************************************"
echo -e "$Yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol  "
echo
echo -e "$Yellow ENJOY AndroModX...$nocol                       "
echo -e "*******************************************************"
echo -e "$Yellow The Flashable Zip Output is at: '$OUTPUT_ZIP'...$nocol                       "
echo -e "*******************************************************"

