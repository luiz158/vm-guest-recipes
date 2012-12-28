#!/bin/sh

# 1 Requerimientos y Dependencias

# 1.1 Tener el dominio + subdominio definitivo
# * Tener el dominio + subdominio definitvo que va a apuntar a ésta aplicacion

# 1.2 Instalar CentOS 5.8
# * incluir el dominio definitivo en la instalación 

# 1.3 Fix de “cannot set locale...”

export LANG=en_US.utf-8
export LC_ALL=en_US.utf-8
export LC_CTYPE=en_US.UTF-8

echo "export LANG=en_US.utf-8" >> /etc/profile
echo "export LC_ALL=en_US.utf-8" >> /etc/profile
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/profile

# 1.4 Instalar repositorio de EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# 1.5 Instalar requerimientos de RVM
yum install -y git gcc-c++ patch readline.x86_64 readline-devel.x86_64 zlib.x86_64 zlib-devel.x86_64 libyaml-devel.x86_64 libffi-devel.x86_64 openssl-devel.x86_64 make bzip2 autoconf automake libtool bison glibc.x86_64

# 1.6 Instalar requerimientos de Gitlab
yum install -y curl-devel.x86_64 python26-devel.x86_64 mysql-devel.x86_64 ncurses.x86_64 ncurses-devel.x86_64 gdbm-devel.x86_64 tcl-devel.x86_64  expat-devel.x86_64 db4-devel.x86_64 byacc sqlite-devel.x86_64 libxml2.x86_64 libxml2-devel.x86_64 libicu-devel.x86_64 system-config-network system-config-services python26-devel.x86_64

# 1.7 Instalar servicios para instalación standalone*:
# * Solamente si éste servidor va a hostear MySQL y Redis
yum install -y redis mysql-server
/sbin/chkconfig --add mysqld
/sbin/chkconfig mysqld on
/sbin/chkconfig --add redis
/sbin/chkconfig redis on
/sbin/service mysqld restart
/sbin/service redis restart
# mysql_secure_installation

#############################################################
# 2. Ambiente Ruby

# 2.1 Instalar RVM
\curl -L https://get.rvm.io | sudo bash -s stable
source /etc/profile.d/rvm.sh

# 2.2 Instalar Ruby 1.9.3
rvmsudo rvm install 1.9.3 -C --sysconfdir=/etc

# 2.3 Configurar gem para no instalar/generar documentacion
echo "install: --no-rdoc --no-ri" >> /etc/gemrc
echo "update: --no-rdoc --no-ri" >> /etc/gemrc

# 2.4 Definir 1.9.3 como el default del sistema:
rvm use 1.9.3 --default
