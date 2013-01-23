#!/bin/bash

# 1. Install Dependencies:

# Update apt-get:
apt-get update && apt-get upgrade

# Install VMware tools dependencies:
apt-get install gcc libglib2.0-0 make linux-headers-$(uname -r)

# 2. Install VMWare Tools

read -p "Select \"Virtual Machine\" -> \"Install VMware Tools\" On Host machine VMware app. Press [Enter] when ready..."
mount /dev/dvd /mnt
mkdir ~/software && cp /mnt/VMwareTools*.tar.gz ~/software && cd ~/software
tar -xzvf VMwareTools*.tar.gz
cd vmware-tools-distrib && ./vmware-install.pl

# 3. Fix "set locale failed" messages
read -p "To fix \"set locale failed\" messages, comment out the line that says \"AcceptEnv LANG LC_*\". Press [Enter] to open the file with vim..."
vim /etc/ssh/sshd_config
