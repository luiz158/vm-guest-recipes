#!/bin/bash
# Script para instalar Redis en Centos 5.8 de manera automatica

# Instalar repositorio EPEL:
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# Instalar dependencias de Redis:
yum install -y curl-devel.x86_64 gcc.x86_64 wget.x86_64 sed.x86_64 GeoIP-devel.x86_64 gd.x86_64 libxslt.x86_64 pcre-devel.x86_64

# Descargar y compilar la última versión estable de Redis:
mkdir -p ~/software \
&& cd ~/software \
&& wget http://nginx.org/download/nginx-1.2.7.tar.gz \
&& tar -xf nginx-1.2.7.tar.gz \
&& cd nginx-1.2.7 \
&& ./configure --user=nginx --group=nginx \
--prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
--http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
--http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
--http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
--http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/subsys/nginx \
--with-http_geoip_module --with-http_ssl_module --with-http_gzip_static_module --with-http_stub_status_module --with-pcre \
&& make

# Instalar:
cd ~/software/nginx-1.2.7 && sudo make install && make clean

# Copiar y editar script de arranque de servicio
wget --no-check-certificate https://raw.github.com/vovimayhem/vm-guest-recipes/master/centos/nginx/init_script.sh \
-O /etc/init.d/nginx \
&& chmod u+x /etc/init.d/nginx

# Activar redis como servicio:
/sbin/chkconfig --add nginx && /sbin/chkconfig --level 345 nginx on && /sbin/service nginx start

# Abrir puertos del firewall:
/sbin/iptables -I RH-Firewall-1-INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT \
&& /sbin/service iptables save && /sbin/service iptables restart

