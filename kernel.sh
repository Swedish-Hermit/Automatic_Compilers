#!/bin/bash
Dependencies='git fakeroot build-essential make ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison curl wget'
# If you pass flag INSTALL then run installation for kernel after compile!
if [ "install" == "true" ]; then
    echo 'Installing kernel after compile!'
    # Error if script not executed as root
    # sudo !! # will run last entry in history with sudo
    [[ "$(id -u)" == 0 ]] || { echo "Run: sudo !!" >&2 ; exit 1 ; }
    # Create directory for the sources
    mkdir kernel
    cd kernel
    # Dependencies
    apt-get install -y $Dependencies 
    # Look for latest file and download it 
    # wget "$(curl "https://kernel.org" | grep -A3 "<td>mainline:</td>" | grep ".tar.gz" | cut -d\" -f2)" -O latest.tar.gz
    wget -e robots=off "$(curl "https://kernel.org/" | grep -A3 "<td>mainline:</td>" | grep ".tar.gz" | cut -d\" -f2)" -O latest.tar.gz
    tar -xvf latest.tar.gz
    cd ./linux*
    # Copy existing config over to new kernel
    cp -v /boot/config-$(uname -r) .config
    # Make menu config and display it for changes
    make menuconfig
    # Compile kernel and install kernel
    make -j5 && make modules_install && make install
    # Install modules with the flag INSTALL
    exit 0
else
    echo 'not installing kernel after Compile!'
    ### Create directory for the sources
    mkdir kernel
    cd kernel
    # Dependencies
    apt-get install -y $Dependencies
    # Look for latest file and download it 
    wget "$(curl "https://kernel.org/" | grep -A3 "<td>mainline:</td>" | grep ".tar.gz" | cut -d\" -f2)" -O latest.tar.gz
    tar -xvf latest.tar.gz
    cd ./linux*
    # Compile kernel
    make -j6
    # Install modules with the flag INSTALL
    echo Install the modules and kernel with "install"
    exit 0
fi