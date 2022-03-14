#!/bin/sh
# This is the second part of the FreeBSD MATE setup script. Do not run as root!

if [ $(id -u) = 0 ] ; then
echo "This setup script MUST be run as a normal user! DO NOT run as root! Thanks."
exit
fi

echo "Are you installing software via packages or ports? (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
./freebsd_mate_theme_install.sh
fi

if [ $answer = "ports" ] ; then
./freebsd_mate_theme_install_ports.sh
fi
