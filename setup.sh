#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.
clear
echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg and MATE for you, along with system files being tweaked for desktop use. This script assumes that you have "sudo" already installed."
echo "Do you have sudo installed? (y/n)"
read answer
if [ $answer = "y" ] ; then
continue
fi
if [ $answer = "n" ] ; then
exit
fi
#
echo "Do you plan to install software via pkg (binary packages) or ports? After answering this question, the required packages/ports will automatically start installing! (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
sudo pkg install -y xorg-minimal xorg-drivers xorg-fonts xorg-libraries mate firefox net-snmp webfonts virtualbox-ose micro zsh ohmyzsh neofetch
sudo ./rcconf_setup.sh
sudo ./bootloader_setup.sh
sudo ./devfs_setup.sh
sudo ./sysctl_setup.sh
sudo ./dotfiles_setup.sh
sudo ./freebsd_mate_theme_install.sh
fi
#
if [ $answer = "ports" ] ; then
sudo cp -v make.conf /etc/
sudo portsnap fetch extract
cd /usr/ports/security/sudo && sudo make deinstall && sudo make reinstall
cd /usr/ports/editors/micro && sudo make install clean
cd /usr/ports/shells/zsh && sudo make install clean
cd /usr/ports/shells/ohmyzsh && sudo make install clean
cd /usr/ports/sysutils/neofetch && sudo make install clean
cd /usr/ports/x11/xorg && sudo make install clean
cd /usr/ports/x11/mate && sudo make install clean
cd /usr/ports/www/firefox && sudo make install clean
cd /usr/ports/x11-fonts/noto && sudo make install clean
cd /usr/ports/net-mgmt/net-snmp && sudo make install clean
cd /usr/ports/x11-fonts/webfonts && sudo make install clean
cd /usr/ports/sysutils/gksu && sudo make install clean
cd /usr/ports/emulators/virtualbox-ose && sudo make install clean
cd /usr/ports/multimedia/webcamd && sudo make install clean
sudo ./rcconf_setup_ports.sh
sudo ./bootloader_setup_ports.sh
sudo ./devfs_setup_ports.sh
sudo ./sysctl_setup.sh
sudo ./dotfiles_setup.sh
sudo ./freebsd_mate_theme_install_ports.sh
fi
