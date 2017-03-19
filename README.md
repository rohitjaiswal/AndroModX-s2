LeEco Le 2 (s2) AndroModX Kernel     
===============================


The LeEco Le 2 is a smartphone from LeEco or LeMobile Information Technology Co. Ltd.



Device configuration for s2
=====================================

Basic   | Spec Sheet
-------:|:-------------------------
CHIPSET | Qualcomm MSM8976 Snapdragon 652
CPU     | Quad-core 1.4 GHz Cortex-A53 & Quad-core 1.8 GHz Cortex-A72
GPU     | Adreno 510
Memory/RAM  | 3 GB
Storage | 32 GB
Battery | 3000 mAh (Non-Removable)
Dimensions | 151.1 x 74.2 x 7.5 mm
Display | 1080 x 1920 pixels 5.5"
Rear Camera  | 16.0 MP
Front Camera | 8.0 MP
Release Date | June 2016



![LeEco Le 2](http://in.img3.lemall.com/file/20160606/default/3370481864506311 "LeEco Le 2")



# Build Guide:
--------

# Download, Prepare and Compile the Kernel
--------


- Download Toolchains (CAF Toolchains (Recommended) Used Below. Other Toolchains May Cause Problems.)


		$ git clone --recursive https://source.codeaurora.org/quic/la/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b LA.BR.1.3.6_rb1.14



- Download Kernel Sources


		$ git clone --recursive https://github.com/rishabhrao/AndroModX-s2.git -b master



- Change Directory to AndroModX Kernel Directory and Make Output Folder


		$ cd AndroModX-s2



- Compile the Kernel


		$ ./build.sh




# 2. Get Compiled Kernel Output
---------------


- Kernel Flashable zip: lazyflasher/AndroModX-2.0-"DATE".zip
