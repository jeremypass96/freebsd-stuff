#!/bin/sh
# This is the second part of the FreeBSD setup script. Do NOT run as root!
echo "Are you installing software via ports or packages?"
read answer
if [ $answer = "pkg" ] ; then
sudo ./rcconf_setup.sh
sudo ./bootloader_setup.sh
sudo ./devfs_setup.sh
echo "Which desktop did you install? MATE or Xfce?"
read answer
if [ $answer = "mate" ] ; then
sudo ./freebsd_mate_theme_install.sh
fi
fi
if [ $answer = "ports" ] ; then
sudo ./rcconf_setup_ports.sh
sudo ./bootloader_setup_ports.sh
sudo ./devfs_setup_ports.sh
echo "Which desktop did you install? MATE or Xfce?"
read answer
if [ $answer = "mate" ] ; then
sudo ./freebsd_mate_theme_install_ports.sh
fi
fi
sudo ./dotfiles_setup.sh
sudo ./sysctl_setup.sh
