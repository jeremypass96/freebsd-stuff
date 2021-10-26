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
echo "This script will not exit. Please install sudo and re-execute script."
exit
fi
#
echo "Do you plan to install software via pkg (binary packages) or ports? After answering this question, the required packages/ports will automatically start installing! (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
sudo pkg install -y xorg-minimal xorg-drivers xorg-fonts xorg-libraries mate firefox net-snmp webfonts virtualbox-ose micro zsh ohmyzsh neofetch lightdm slick-greeter numlockx
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
cd /usr/ports/x11/lightdm && sudo make install clean
cd /usr/ports/x11/slick-greeter && sudo make install clean
cd /usr/ports/
sudo ./rcconf_setup_ports.sh
sudo ./bootloader_setup_ports.sh
sudo ./devfs_setup_ports.sh
sudo ./sysctl_setup.sh
sudo ./dotfiles_setup.sh
sudo ./freebsd_mate_theme_install_ports.sh
fi
# Setup LightDM/Slick Greeter.
cd /usr/local/etc/lightdm
sudo sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g lightdm.conf
sudo sed -i '' s/#greeter-session=example-gtk-gnome/greeter-session=slick-greeter/g lightdm.conf
sudo sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g lightdm.conf
sudo sed -i '' s/#allow-guest=true/allow-guest=false/g lightdm.conf
sudo sed -i '' s/#greeter-setup-script=/greeter-setup-script=/usr/local/bin/numlockx on/g lightdm.conf
sudo sed -i '' s/#autologin-user=/autologin-user=$USER/g lightdm.conf
sudo sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g lightdm.conf
sudo echo "[Greeter]" > slick-greeter.conf
sudo echo "background = /usr/local/share/backgrounds/0062.jpg" >> slick-greeter.conf
sudo echo "draw-user-backgrounds = true" >> slick-greeter.conf
sudo echo "draw-grid = false" >> slick-greeter.conf
sudo echo "show-hostname = true" >> slick-greeter.conf
sudo echo "show-a11y = false" >> slick-greeter.conf
sudo echo "show-keyboard = false" >> slick-greeter.conf
sudo echo "clock-format = %I:%M %p" >> slick-greeter.conf
sudo echo "theme-name = ClassicLooks Irix" >> slick-greeter.conf
sudo echo "icon-theme-name = matefaenza" >> slick-greeter.conf
# Reboot
shutdown -r now
