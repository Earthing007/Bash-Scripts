#!/bin/bash

# Verify root
if [ "$(whoami)" != 'root' ]; then
	echo -e " \e[33m This script must be run as root\e[0m"
	exit
fi

# Permit root login
clear
sleep 1
if [[ $(sudo sshd -T | grep -i "permitrootlogin" | awk '{print $2}') = 'yes' ]]; then
	echo -e "\n"
	echo -e "Root Login already permitted."
else
	echo -e "\n"
	echo -e "\e[32mPermitting root login..\e[0m"
	sed -i "s/PermitRootLogin no/PermitRootLogin yes/" /etc/ssh/sshd_config
	sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
fi

# Allow password authentication
sleep 1
if [[ $(sudo sshd -T | grep -i "passwordauthentication" | awk '{print $2}') = 'yes' ]]; then
	echo -e "PasswordAuthentication already allowed."
else
	echo -e "\e[32mAllowing password authentication..\e[0m"
	sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
fi

# Restart sshd
sleep 1
echo -e "\e[32mRestarting sshd..\e[0m"
systemctl restart sshd

# Set root password
echo -e "\n"
echo -e "\e[32mNow enter password for root\e[0m\n"
sleep 0.3
passwd root
echo -e "\n"

# Remove file
rm -f root.sh
