#!/bin/sh
# This is the second part of the FreeBSD setup script. Do NOT run as root!
echo "Are you installing software via ports or packages?"
read answer
if [ $answer = "ports" ] ; then
sudo ./rcconf_setup_ports.sh
sudo ./bootloader_setup_ports.sh
sudo ./devfs_setup_ports.sh
sudo ./freebsd_mate_theme_install_ports.sh
fi
#
if [ $answer = "pkg" ] ; then
sudo ./rcconf_setup.sh
sudo ./bootloader_setup.sh
sudo ./devfs_setup.sh
sudo ./freebsd_mate_theme_install.sh
fi
sudo ./dotfiles_setup.sh
sudo ./sysctl_setup.sh
