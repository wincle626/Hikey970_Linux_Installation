# Host OS
Ubuntu 18.04

# Hikey 970 Build Linux Kernel - only for those who want to customize the kernel

1. Download kernel source file from:

    https://github.com/96boards-hikey/linux/tree/hikey970-v4.9
    
2. Make sure ARM64 GCC complier is installed: 
    sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

3. Go to the source folder and set up the enviroment variable for cross compie and buld kernel .config:

    export CROSS_COMPILE=aarch64-linux-gnu-
    
    make ARCH=arm64 hikey970_defconfig
    
4. Change .config with:

    make ARCH=arm64 menuconfig
    
5. Build kernel:

    make ARCH=arm64 

6. The kernel image file is:

    arch/arm64/boot/Image
    
# Hikey 970 Build Sparse Rootfs Image

1. git clone https://github.com/mengzhuo/hikey970-ubuntu-image and enter the folder

2. Replace the Image file with compiled kernel image in folder rootfs/boot

3. Run the build.sh. (might need "sudo apt-get install img2simg binfmt-support qemu qemu-user-static debootstrap")

4. The sparse rootfs image file is generate in the new created build folder, e.g. ubuntu_bionic.hikey970.v1.0-6-g775823b.sparse.img

5. Rename the sparse image file as rootfs.sparse.img.  


# Hikey 970 Debian Linux Installation

1. Currently there are two version at the moment, hikey970_debin_0531_support_uvc or ubuntu_bionic.hikey971.v1.0. I used the [ubuntu_bionic.hikey971.v1.0](https://github.com/mengzhuo/hikey970-ubuntu-image/releases/download/v1.0/ubuntu_bionic.hikey971.v1.0.sparse.img.tar.gz). 

2. If host is Linux, install fastboot by "sudo apt install fastboot". If host is windows, install adb tool using the adb-setup-1.3.exe in download folder, which will install the fastboot to C:\abd and remember to add this path to system PATH variable. If you don't know how to do that, just Google :)

3. Set the board to adb mode through the four keys switch: 

    ON, OFF, ON, OFF. 
    
4. Connect the cable to setup Type-C port. Power on the board.

5. I used the ubuntu_bionic.hikey971.v1.0 version, so just replace the rootfs.sparse.img file with the compiled one above and run update_hikey970.sh in the folder and wait for it finishes. (PS: use 64gtoendprm_ptable.img instead of prm_patable.img in the script to avoid the fractional partition. In this case, no need to use resize2fs command to extend the rootfs partition any more.)

6. Once installed, power off the board and change the four keys back to: 

    ON, OFF, OFF, OFF. 

7. Pluging the Type-C UART cable to the board and power on it. The default user is 'hi' and password is 'hikey970'.

8. Change the content of file /etc/netplan/01-dhcp.yaml as the file '01-dhcp.yaml' in the folder.

9. Change the content of file /etc/apt/sources.list as the file 'sources.list' in the folder.

10. Run the command in file 'locale' in the folder. 

11. Set the host ip address as 192.168.1.1 and share the internet through it and then install the xfce4:
    sudo apt update && sudo apt install xfce4

12. Now it is time to enjoy the debian on Hikey970. E.g. ssh -X hi@192.168.1.97. Notice, there is no display manager yet. You need to install either xdm/gdm/lightdm etc. to display the desktop at startup. (Some additional packages: autoconf automake intltool pkg-config glib2.0 gtk+2.0 dbus-glib2.0 xfconf gio2.0 libglade2.0 perl libwnck-3-dev gudev-1.0)


# Pre-Built Linux Images

Please note that LeMaker has provided pre-built image for Hikey970. Please follow the link to download tar file and follow the installation guide:

http://www.lemaker.org/product-hikey970-resource.html

One of the drawback of this pre-compiled image is that some kernel modules are not reloaded at boot, for example the fdti_sio. In order to have those kernel modules after boot, you need to compile the kernel modules manually from the source. 

1. Copy the source to the /lib/modules on the board and rename it according to the current linux kernel information:

    cp -r #(you download folder)/hikey970-v4.9 /lib/modlues/$(uname -r)

2. Go to the folder "/lib/modlues/$(uname -r)" and go through the step 1-4 in Hikey 970 Build Linux Kernel section. By openning the graphical configure interface, navigate to : "Device Drivers -> USB Support -> USB Serial Converter Support" and select 'M'module "USB FTDI Single Port Serial Driver". Then choose exit and save the configuration.

3. Build the additional kernel module with

    make ARCH=arm64 M=drivers/usb/serial/
    
    make ARCH=arm64 modules
    
    make ARCH=arm64 modlues_install
    
4. You will see generated kernel module .ko files under drivers/usb/serial/ folder. Take the fdti_sio.ko for example, it can be loaded by insmod comamnd (need to load the module usbserial.ko first):

    insmod drivers/usb/serial/usbserial.ko
    
    insmod drivers/usb/serial/fdti_sio.ko
    
And unloaded using rmmod command:
    
    rmmod drivers/usb/serial/fdti_sio.ko
    
    rmmod drivers/usb/serial/usbserial.ko
    
Use lsmod command to check if they are loaded successfully. You can also use modprobe command to do steps 3 and 4.
    
Now you can attach the serieal connection device to the USB port and access them through /dev/ttyUSB* (* is the an integer number). This method is also valid for other kernel modules.

#### PS: All the commands executed above are under superuser mode, so run sudo -s before doing them. There are some prerequisite packages, please refer to https://help.ubuntu.com/community/Kernel/Compile. And if you are also interested in building up your own custom kernel module, follow this helloworld guide here: https://www.tldp.org/LDP/lkmpg/2.6/html/x181.html.
    

# Known Issues

1. HDMI Display Overscan

2. Unallocated space within OS partition and small rootfs partition

3. Bluetooth Driver Halts because the invalid definition in DeviceTree

4. No access to GPS yet

5. No access to AI core yet

6. No Mali G72 userspace binary driver, hence no OpenCL support at the moment

7. If the board is fully connected with 2 usb (e.g. keyboard and mouse), 1 HDMI (e.g. monitor), 1 RJ45 (e.g. Ethernet) and 1 UART, there is a chance the Ethernet will not work. If remove everything except the RJ45, it will bring the Ethernet back. Then you can use the USB but not the HDMI as the board does not support hot plugin of HDMI. 

# Sovled Issues

1. Use resize2fs command to expand the full partition size. Install GParted (sudo apt install gparted) and resize the rootfs parition.

2. It turns out the display overscan is caused by the compatibility of monitor with this board. It is solved by using another monitor. 

7. Switching from Netplan to NetworkManager make it slightly better. Then you need to update the /etc/network/interface with following content:

        auto lo
        
        iface lo inet loopback
        
        
        auto enp6s0
        
        iface enp6s0 inet static
        
        address 192.168.1.97
        
        netmask 255.255.255.0
        
        gateway 192.168.1.97
        
   And update the /etc/resolv.conf with following content:
   
        nameservers 192.168.1.1
        
   Then do "sudo ifdown enp6s0 && sudo ifup enp6s0". It should bring you the internet through the host as using the Netplan. 
