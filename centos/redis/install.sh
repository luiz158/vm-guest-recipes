#!/bin/bash
# Script para instalar Redis en Centos 5.8 de manera automatica

# Instalar repositorio EPEL:
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# Instalar dependencias de Redis:
yum install -y curl-devel.x86_64 gcc.x86_64 wget.x86_64 sed.x86_64 jemalloc-devel.x86_64 lua-devel.x86_64 lua-static.x86_64

# Descargar y compilar la última versión estable de Redis:
mkdir -p ~/software \
&& cd ~/software \
&& wget http://redis.googlecode.com/files/redis-2.6.9.tar.gz \
&& tar -xvf redis-2.6.9.tar.gz \
&& cd redis-2.6.9 \
&& make

# Instalar tcl, que es dependencia para las pruebas de Redis:
#cd ~/software && wget http://downloads.sourceforge.net/tcl/tcl8.6.0-src.tar.gz \
#&& tar -xvf tcl8.6.0-src.tar.gz && cd tcl8.6.0/unix \
#&& ./configure && make && sudo make install && make clean \
#&& sudo ln -s /usr/local/bin/tclsh8.6 /usr/local/bin/tclsh8.5

# Realizar la prueba sobre la compilación de Redis:
#cd ~/software/redis-2.6.9 && make test

# Instalar:
cd ~/software/redis-2.6.9 && sudo make install && make clean

# Crear directorio de trabajo de redis:
mkdir -p /var/lib/redis

# Crear archivo de configuracion a partir del ejemplo:
sed \
-e "s/^daemonize no$/daemonize yes/" \
-e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" \
-e "s/^dir \.\//dir \/var\/lib\/redis\//" \
-e "s/^loglevel debug$/loglevel notice/" \
-e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" \
redis.conf > /etc/redis.conf

# Copiar y editar script de arranque de servicio
wget https://raw.github.com/vovimayhem/vm-guest-recipes/master/centos/redis/init_script.sh -O /etc/init.d/redis-server \
&& sed -i "s/usr\/local\/sbin\/redis/usr\/local\/bin\/redis/" /etc/init.d/redis-server \
&& chmod u+x /etc/init.d/redis-server

# Activar redis como servicio:
chkconfig --add redis-server && chkconfig --level 345 redis-server on && service redis-server start

# Para probar el servicio, utilizaremos el cliente de redis (redis-cli):
redis-cli