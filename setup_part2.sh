#!/bin/sh
# This is the second part of the FreeBSD setup script. Do NOT run as root!
echo "Are you installing software via ports or packages?"
read answer
if [ $answer = "ports" ] ; then
sudo ./freebsd_mate_theme_install_ports.sh
fi
#
if [ $answer = "pkg" ] ; then
sudo ./freebsd_mate_theme_install.sh
fi
sudo ./dotfiles_setup.sh
