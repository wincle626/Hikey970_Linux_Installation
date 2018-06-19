#!/bin/sh

echo "-----------------------------"
echo `date`
echo "Hikey970 Updating:"

output="$(sudo fastboot devices)"
echo $output

output="$(sudo fastboot flash ptable prm_ptable.img)"
echo $output

output="$(sudo fastboot flash xloader sec_xloader.img)"
echo $output

output="$(sudo fastboot flash fastboot l-loader.bin)"
echo $output

output="$(sudo fastboot flash fip fip.bin)"
echo $output

output="$(sudo fastboot flash boot boot2grub.uefi.img)"
echo $output

output="$(sudo fastboot flash system rootfs.sparse.img)"
echo $output

echo "Update Done!"
