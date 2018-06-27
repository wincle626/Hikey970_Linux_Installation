# Host OS
Ubuntu 18.04

# Hikey 970 Build Linux Kernel

1. Download kernel source file from:

    https://github.com/96boards-hikey/linux/tree/hikey970-v4.9
    
2. Make sure ARM64 GCC complier is installed: 
    sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

3. Go to the source folder and set up the enviroment variable for cross compie and buld kernel .config:

    export CROSS_COMPILE=aaarch64-linux-gnu-
    
    make ARCH=arm64 hikey970_defconfig
    
4. Change .config with:

    make ARCH=arm64 menuconfig
    
5. Build kernel:

    make ARCH=arm64 

6. The kernel image file is:

    arch/arm64/boot/Image
    
# Hikey 970 Build Sparse Rootfs Image

1. Unzip hikey970-ubuntu-image-1.0.zip and go to the unzipped folder

2. Replace the Image file with compiled kernel image in folder rootfs/boot

3. Run the build.sh. 

4. The sparse rootfs image file is generate in the new created build folder, e.g. ubuntu_bionic.hikey970.v1.0-6-g775823b.sparse.img

5. Rename the sparse image file as rootfs.sparse.img.  


# Hikey 970 Debian Linux Installation

1. Currently there are two version at the moment, hikey970_debin_0531_support_uvc or ubuntu_bionic.hikey971.v1.0. I used the ubuntu_bionic.hikey971.v1.0. 

2. If host is Linux, install fastboot by "sudo apt install fastboot". If host is windows, install adb tool using the adb-setup-1.3.exe in download folder, which will install the fastboot to C:\abd and remember to add this path to system PATH variable. If you don't know how to do that, just Google :)

3. Set the board to adb mode through the four keys switch: 

    ON, OFF, ON, OFF. 
    
4. Connect the cable to setup Type-C port. Power on the board.

5. I used the ubuntu_bionic.hikey971.v1.0 version, so just replace the rootfs.sparse.img file with the compiled one above and run update_hikey970.sh in the folder and wait for it finishes.

6. Once installed, power off the board and change the four keys back to: 

    ON, OFF, OFF, OFF. 

7. Pluging the Type-C UART cable to the board and power on it. The default user is 'hi' and password is 'hikey970'.

8. Change the content of file /etc/netplan/01-dhcp.yaml as the file '01-dhcp.yaml' in the folder.

9. Change the content of file /etc/apt/sources.list as the file 'sources.list' in the folder.

10. Run the command in file 'locale' in the folder. 

11. Set the host ip address as 192.168.1.1 and share the internet through it and then install the xfce4:
    sudo apt update && sudo apt install xfce4

12. Now it is time to enjoy the debian on Hikey970. E.g. ssh -X hi@192.168.1.97. Notice, there is no display manager yet. You need to install either xdm/gdm/lightdm etc. to display the desktop at startup. (Some additional packages: autoconf automake inltool pkg-config glib2.0 gtk+2.0 dbus-glib2.0 xfconf gio2.0 libglade2.0 perl libwnck-3-dev gudev-1.0)

# Known Issues

1. HDMI Display Overscan

2. Bluetooth Driver Halts

3. Unallocated space within OS partition and small rootfs partition

# Sovled Issues

1. Use resize2fs command to expand the full partition size.

2. Install GParted (sudo apt install gparted) and resize the rootfs parition

3. It turns out the display overscan is because of the compatibility of monitor with this board. It is solved by using another monitor. 
