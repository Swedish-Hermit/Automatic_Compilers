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

### Look for latest file and download it 
NGINX_VER="$(curl -s 'http://nginx.org/download/' | grep -oP 'href="nginx-\K[0-9]+\.[0-9]+\.[0-9]+' | sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)"
curl -L -O "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz" && tar xzf "nginx-${NGINX_VER}.tar.gz"
#Unpack
tar -xvf $NGINX_VER.tar.gz

#clone fancyindex git repo
git clone https://github.com/aperezdc/ngx-fancyindex.git ./ngx-fancyindex

#cd into nginx folder
cd nginx
cd nginx-$NGINX_VER
 ./configure --prefix=/usr/share/nginx \
                --sbin-path=/usr/sbin/nginx \
                --conf-path=/etc/nginx/nginx.conf \
                --error-log-path=/var/log/nginx/error.log \
                --http-log-path=/var/log/nginx/access.log \
                --pid-path=/tmp/nginx.pid \
                --lock-path=/run/lock/subsys/nginx \
                --http-client-body-temp-path=/tmp/nginx/client \
                --http-proxy-temp-path=/tmp/nginx/proxy \
                --with-threads \
                --with-file-aio \
                --with-http_addition_module \
                --with-http_random_index_module \
                --with-http_stub_status_module \
                --with-http_sub_module \
                --without-http_rewrite_module \
                --add-module=../ngx-fancyindex \
                --without-http_uwsgi_module \
                --without-http_scgi_module \
                --without-http_gzip_module \
                --without-select_module \
                --without-poll_module \
                --with-cc-opt="-O2 -flto -ffunction-sections -fdata-sections -fPIE -fstack-protector-all -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security" \
                --with-ld-opt="-Wl,--gc-sections -s -static -static-libgcc" \
    && make -j4 \
    && make install