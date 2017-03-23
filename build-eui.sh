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
WLAN=$KERNEL_DIR/drivers/staging/prima/wlan.ko
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
WLAN=$KERNEL_DIR/lazyflasher/modules/wlan.ko
JOBS=64

# Kernel Compilation Scripts Are Below
compile_kernel ()
{
# Clean Directories
echo -e "$White***********************************************"
echo "       Cleaning Kernel Directories                      "
echo -e "***********************************************$nocol"
OUTPUT_ZIP=$KERNEL_DIR/lazyflasher/$NAME-$VERSION-$DATE.zip
rm -fdr $KERNEL_DIR/output/EUI-$NAME-*.zip
rm -fdr $KERNEL_DIR/lazyflasher/$NAME-*.zip
rm -fdr $KERNEL_DIR/lazyflasher/Image.gz-dtb
rm -fdr $KERNEL_DIR/lazyflasher/modules/wlan.ko
rm -fdr $KERNEL_DIR/lazyflasher/modules/pronto/pronto_wlan.ko
mkdir -p $KERNEL_DIR/lazyflasher/modules/pronto
make clean && make mrproper
if [ -a $OUTPUT_ZIP ];
then
echo -e "$Red Cleaning Kernel Directories Failed! Fix the Errors! $nocol"
exit 1
else
echo -e "$Yellow Directories Cleaned Successfully.$nocol"
fi

# Building AndroModX EUI Kernel
echo -e "$White***********************************************"
echo "         Compiling AndroModX EUI Kernel              "
echo -e "***********************************************$nocol"
sed -i '/CONFIG_PRONTO_WLAN=y/c\CONFIG_PRONTO_WLAN=m' $KERNEL_DIR/arch/arm64/configs/andromodx_defconfig
sed -i '/CONFIG_MODULE_FORCE_LOAD=n/c\CONFIG_MODULE_FORCE_LOAD=y' $KERNEL_DIR/arch/arm64/configs/andromodx_defconfig
make $DEFCONFIG
make -j$JOBS
make -j$JOBS modules
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $KERNEL_DIR/lazyflasher/Image.gz-dtb
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/lazyflasher/modules/wlan.ko
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/lazyflasher/modules/pronto/pronto_wlan.ko
scripts/sign-file.sh sha512 signing_key.priv signing_key.x509 $KERNEL_DIR/lazyflasher/modules/wlan.ko
scripts/sign-file.sh sha512 signing_key.priv signing_key.x509 $KERNEL_DIR/lazyflasher/modules/pronto/pronto_wlan.ko
sed -i '/CONFIG_PRONTO_WLAN=m/c\CONFIG_PRONTO_WLAN=y' $KERNEL_DIR/arch/arm64/configs/andromodx_defconfig
sed -i '/CONFIG_MODULE_FORCE_LOAD=y/c\CONFIG_MODULE_FORCE_LOAD=n' $KERNEL_DIR/arch/arm64/configs/andromodx_defconfig
if ! [ -a $IMAGE ];
then
echo -e "$Red AndroModX EUI Kernel Compilation Failed! Fix the Errors! $nocol"
exit 1
else
echo -e "$Yellow AndroModX EUI Kernel Compiled Successfully.$nocol"
fi

# Building AndroModX EUI Kernel Installer
echo -e "$White***********************************************"
echo "     Building AndroModX EUI Kernel Installer         "
echo -e "***********************************************$nocol"
OUTPUT_ZIP=$KERNEL_DIR/lazyflasher/$NAME-$VERSION-$DATE.zip
cd $KERNEL_DIR/lazyflasher
make
if ! [ -a $OUTPUT_ZIP ];
then
echo -e "$Red EUI Kernel Compilation Failed! Fix the Errors! $nocol"
exit 1
fi

# Copying AndroModX EUI Kernel Installer to Out Directory
echo -e "$White***********************************************"
echo "    Copying AndroModX EUI Kernel Installer to out    "
echo -e "***********************************************$nocol"
OUTPUT_ZIP=$KERNEL_DIR/output/EUI-$NAME-$VERSION-$DATE.zip
cp $KERNEL_DIR/lazyflasher/$NAME-$VERSION-$DATE.zip $KERNEL_DIR/output/EUI-$NAME-$VERSION-$DATE.zip
if ! [ -a $OUTPUT_ZIP ];
then
echo -e "$Copying AndroModX EUI Kernel Installer to out Failed! Fix the Errors! $nocol"
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
echo -e "$Yellow The Flashable Output Zips are at: 'output/'...$nocol                       "
echo -e "*******************************************************"
