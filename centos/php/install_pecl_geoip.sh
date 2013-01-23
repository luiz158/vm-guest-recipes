#!/bin/bash
# Script para instalar la extension de PHP PECL 'geoip' en Centos 5.8 de manera automatica

PHP_PREFIX="/usr/local"
PHP_INI_FILE="$PHP_PREFIX/php/lib/php.ini"

# Instalar repositorio EPEL:
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# Instalar Librería C de GeoIP + headers de desarrollo:
yum -y --enablerepo=epel install GeoIP-devel.x86_64

# Descargar, compilar e instalar extension de PHP via PECL:
$PHP_PREFIX/php/bin/pecl install geoip

# Habilitar extension en php.ini:
# Agregar 'extension=geoip.so' solo si no lo encuentra en el php.ini:
grep -q -e '^extension=geoip.so' $PHP_INI_FILE \
|| echo "" >> $PHP_INI_FILE \
&& echo "[geoip]" >> $PHP_INI_FILE \
&& echo "extension=geoip.so" >> $PHP_INI_FILE
