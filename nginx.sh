#!/bin/bash
DIR1=nginx
# Error if script not executed as root
# sudo !! # will run last entry in history with sudo

[[ "$(id -u)" == 0 ]] || { echo "Run: sudo !!" >&2 ; exit 1 ; }

### Create directory for the sources
mkdir $DIR1
cd $DIR1

### Dependiances
sudo apt-get update \
    && sudo apt-get install -y \
        curl \
        g++ \
        gcc \
        git \
        make \
        tar \
        libpcre3 \
        libpcre3-dev

### Look for latest file and download it 
NGINX_VER="$(curl -s 'http://nginx.org/download/' | grep -oP 'href="nginx-\K[0-9]+\.[0-9]+\.[0-9]+' | sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)"
curl -L -O "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz" && tar xzf "nginx-${NGINX_VER}.tar.gz"
#Unpack
tar -xvf $NGINX_VER.tar.gz

#clone fancyindex git repo
git clone https://github.com/aperezdc/ngx-fancyindex.git ./ngx-fancyindex
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.gz && tar xvf
wget https://www.openssl.org/source/openssl-3.0.3.tar.gz && tar xvf 
#cd into nginx folder
cd nginx
cd nginx-$NGINX_VER
 ./configure --prefix=/usr/share/nginx --add-module=../ngx-fancyindex/ \
                --sbin-path=/usr/sbin/nginx \
                --conf-path=/etc/nginx/nginx.conf \
                --error-log-path=/var/log/nginx/error.log \
                --http-log-path=/var/log/nginx/access.log \
                --pid-path=/tmp/nginx.pid \
                --lock-path=/run/lock/subsys/nginx \
                --with-threads \
                --with-file-aio \
                --with-http_addition_module \
                --with-http_random_index_module \
                --with-http_stub_status_module \
                --with-http_sub_module \
                --with-stream \
                --with-http_mp4_module \
                --with-http_sub_module \
                --with-http_dav_module \
                --with-http_flv_module \
                --with-http_ssl_module \
                --with-pcre \
                --with-http_xslt_module \
                --with-http_realip_module \
                --with-http_v2_module \
		--with-http_xslt_module \
    && make -j7 \
    && make install
echo "all done!"
