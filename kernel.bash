#!/bin/bash

# Error if script not executed as root
# sudo !! # will run last entry in history with sudo

[[ "$(id -u)" == 0 ]] || { echo "Run: sudo !!" >&2 ; exit 1 ; }

### Create directory for the sources
mkdir kernel
cd kernel

### Dependiances
apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison -y 

### Look for latest file and download it 
#wget "$(curl "https://kernel.org" | grep -A3 "<td>mainline:</td>" | grep ".tar.gz" | cut -d\" -f2)" -O latest.tar.gz
wget "$(curl "https://kernel.org/" | grep -A3 "<td>mainline:</td>" | grep ".tar.gz" | cut -d\" -f2)" -O latest.tar.gz

tar -xvf latest.tar.gz
cd linux*

### Copy existing config over to new kernel
cp -v /boot/config-$(uname -r) .config

### Compile menuconfig
make menuconfig

### Compile kernel
make -j $nproc

### install modules
make modules_install

### install kernel
make install

### enable initramfs on boot
#update-initramfs -c -k all

### update grub
#update-grub