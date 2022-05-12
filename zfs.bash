#!/bin/bash
Dependencies='git build-essential autoconf automake libtool gawk alien fakeroot dkms libblkid-dev uuid-dev libudev-dev libssl-dev zlib1g-dev libaio-dev libattr1-dev libelf-dev 'linux-headers-$(uname -r)' python3 python3-dev python3-setuptools python3-cffi libffi-dev python3-packaging git libcurl4-openssl-dev'
[[ "$(id -u)" == 0 ]] || { echo "Run: sudo !!" >&2 ; exit 1 ; }
apt update && apt install $Dependencies
if [[ -d $HOME/zfs ]]; then
    cd $HOME
    echo 'running git pull then compile'
    cd ./zfs && git pull 
    git checkout master
    sh autogen.sh && ./configure
    make -s -j4
    echo 'all done!'
    exit 0
  else
    echo 'running git clone then compile'
    git clone https://github.com/openzfs/zfs
    cd ./zfs && git checkout master
    sh autogen.sh && ./configure
    make -s -j4
    echo 'all done!'
    exit 0
fi