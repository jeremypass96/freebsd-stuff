#!/bin/sh

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

echo "Welcome to the FreeBSD post-install setup script. This script simply asks you what desktop environment you want to use. After you select your desktop environment, this script will launch your specified desktop's setup script."
echo "Which desktop environment do you want to use? Please enter it's corresponding number."
echo "1.) MATE"
echo "2.) Xfce"
echo "3.) GNOME"
read answer
if [ $answer = "1" ] ; then
./setup_mate.sh
if [ $answer = "2" ] ; then
./setup_xfce.sh
if [ $answer = "3" ] ; then
./setup_gnome.sh
