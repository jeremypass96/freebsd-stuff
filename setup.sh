#!/bin/sh

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD post-install setup script. This script simply asks you what desktop environment you want to use. After you select your desktop environment, this script will launch your specified desktop's setup script."
echo "Which desktop environment do you want to use? Please enter it's corresponding number."
echo "1.) MATE"
echo "2.) Xfce"
echo "3.) Katana (fork of KDE4)"
read answer
if [ $answer = "1" ] ; then
./setup_mate.sh
fi
if [ $answer = "2" ] ; then
./setup_xfce.sh
fi
if [ $answer = "3" ] ; then
./setup_katana.sh
fi

# Disable unneeded TTYs and secure the rest. This will make you enter root's password when booting into single user mode, but you can't login as root while booted into normal mode.
sed -i '' s/ttyu0/#ttyu0/g /etc/ttys
sed -i '' s/ttyu1/#ttyu1/g /etc/ttys
sed -i '' s/ttyu2/#ttyu2/g /etc/ttys
sed -i '' s/ttyu3/#ttyu3/g /etc/ttys
sed -i '' s/dcons/#dcons/g /etc/ttys
sed -i 'ttyv*' s/secure/insecure/g /etc/ttys

# Update FreeBSD base.
freebsd-update fetch install

# Reboot in 5 seconds.
shutdown -r 5s
