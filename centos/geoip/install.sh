#!/bin/bash
# Script para instalar Redis en Centos 5.8 de manera automatica

# Instalar repositorio EPEL:
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# Instalar Librería C de GeoIP + headers de desarrollo:
yum -y --enablerepo=epel install GeoIP-devel.x86_64


