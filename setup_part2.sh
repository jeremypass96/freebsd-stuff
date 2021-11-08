#!/bin/sh
# This is the second part of the FreeBSD setup script. Do NOT run as root!
echo "Are you installing software via ports or packages? (ports/pkg)"
read answer
if [ $answer = "ports" ] ; then
./freebsd_mate_theme_install_ports.sh
fi
#
if [ $answer = "pkg" ] ; then
./freebsd_mate_theme_install.sh
fi
./dotfiles_setup.sh
