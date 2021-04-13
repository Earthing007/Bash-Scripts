#!/bin/bash

rd=$'\033[31m'; # Red
gr=$'\033[32m'; # Green
or=$'\033[33m'; # Orange
nc=$'\033[0m'; # No Color

# Check if root then exit if not
if [ "$(whoami)" != 'root' ]; then
	echo "${rd}This script must be run as root${nc}"
	exit
fi

clear
if [[ $(sudo sshd -T | grep -i "permitrootlogin" | awk '{print $2}') = 'yes' ]]; then
	echo -e "\n"
	echo "${or}PermitRootLogin already allowed.${nc}"
else
	echo -e "\n"
	echo "${gr}Permitting root login..${nc}"
	sed -i "s/PermitRootLogin no/PermitRootLogin yes/" /etc/ssh/sshd_config
	sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
fi
sleep 1
if [[ $(sudo sshd -T | grep -i "passwordauthentication" | awk '{print $2}') = 'yes' ]]; then
	echo "${or}PasswordAuthentication already allowed.${nc}"
else
	echo "${gr}Allowing password authentication..${nc}"
	sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
fi
sleep 1

echo "${or}Restarting sshd..${nc}"
sudo systemctl restart sshd

echo -e "\n"
echo "${gr}Now enter password for root${nc}"
read -rp "< Default: i@mtheB3st >  --> " rootpass
if [[ -z "$rootpass" ]]; then
	rootpass="i@mtheB3st"
fi
echo "root:$rootpass" | chpasswd
echo -e "\n"
rm -f root.sh
