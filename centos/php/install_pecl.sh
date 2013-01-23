#!/bin/bash
# Script de Shell para instalar una extension de PHP PECL
# URL original: ?
#

# Argument = -l PHP_bin_location -e extension_name

usage()
{
cat << EOF
usage: $0 options

This script will install the given PHP PECL extension.

OPTIONS:
   -h      Show this message
   -l      Location of the PHP installation
   -e      Extension Name (Ex. geoip, apc)
EOF
}

ensure_dependencies()
{
	# EPEL Repo:
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

	# REMI Repo:
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
	
	# GCC compiler:
	yum install -y gcc
}

install_extension()
{
	ensure_dependencies
	$PHP_BIN_LOCATION/bin/pecl install $EXTENSION_NAME
}

PHP_BIN_LOCATION=
EXTENSION_NAME=
while getopts “hl:e” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         l)
             PHP_BIN_LOCATION=$OPTARG
             ;;
         e)
             EXTENSION_NAME=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [ -z $PHP_BIN_LOCATION ]; then
     usage
     exit 1
elif [ -z $EXTENSION_NAME]; then
	usage
	exit 1
else
	echo "Installing PHP PECL Extension '$EXTENSION_NAME' in 'PHP_BIN_LOCATION'"
fi

install_extension

exit

