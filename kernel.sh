#!/bin/bash
Dependencies='git fakeroot build-essential make ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison curl wget'
    # Error if script not executed as root
    # sudo !! # will run last entry in history with sudo
    [[ "$(id -u)" == 0 ]] || { echo "Run: sudo !!" >&2 ; exit 1 ; }
    # Create directory for the sources
    mkdir kernel;
    cd kernel
    # Remove existing installs of the kernel
    rm latest.tar.gz; rm -r linux*;
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
    # Compile kernel for distribution
    make -j $(nproc) bindeb-pkg
    exit 0