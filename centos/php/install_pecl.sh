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

function elementExists()
{

	if [ -z "$1" ]; then
		return
	fi

	for i in ${excluded[@]}
	do
	if [ $i == $1 ]
	then
	return 1
	fi
	done

	return 0
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
	echo "$PHP_BIN_LOCATION/bin/pecl install $EXTENSION_NAME"
}

install_unknownextension()
{
	echo "Installing *UNKNOWN php pecl extension '$EXTENSION_NAME' in '$PHP_BIN_LOCATION'"
	ensure_dependencies
	install_extension
}

install_apc()
{
	ensure_dependencies
	install_extension
}

install_geoip()
{
	echo "Installing *KNOWN* php pecl extension '$EXTENSION_NAME' in '$PHP_BIN_LOCATION'"
	\curl -L https://raw.github.com/vovimayhem/vm-guest-recipes/master/centos/geoip/install.sh | sudo bash
	install_extension
}

install_memcached()
{
	return 1;
}

PHP_BIN_LOCATION=
EXTENSION_NAME=
VERBOSE=
while getopts “hl:e:v” OPTION
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
         v)
             VERBOSE="--verbose"
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

echo "PHP_BIN_LOCATION: '$PHP_BIN_LOCATION'"
echo "EXTENSION_NAME: '$EXTENSION_NAME'"
if [ -z $PHP_BIN_LOCATION ] || [ -z $EXTENSION_NAME ]; then
	usage
	exit 1
else
	
	KNOWN_EXTENSIONS="geoip apc memcached"
	
	case $KNOWN_EXTENSIONS in
	  # match exact string
	  #"$searchString") echo yep, it matches exactly;;

	  # match start of string
	  #"$searchString"*) echo yep, it matches at the start ;;

	  # match end of string
	  #*"$searchString") echo yep, it matches at the end ;;

	  # EXTENSION_NAME can be anywhere in KNOWN_EXTENSIONS
	  *"$EXTENSION_NAME"*) install_$EXTENSION_NAME ;;

	  *) install_extension ;;
	esac
fi

exit

