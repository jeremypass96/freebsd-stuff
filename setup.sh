#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot. Run as root!
clear
echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg and MATE (or Xfce) for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? After answering this question, the required packages/ports will automatically start installing! (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
pkg update
pkg upgrade -y
pkg install -y devcpu-data automount sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries cups mate xfburn parole firefox webfonts virtualbox-ose micro zsh ohmyzsh neofetch lightdm slick-greeter numlockx
sudo ./rcconf_setup.sh
fi
#
if [ $answer = "ports" ] ; then
cp -v make.conf /etc/
portsnap auto
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/mate && make install clean
cd /usr/ports/sysutils/xfburn && make install clean
cd /usr/ports/multimedia/parole && make install clean
cd /usr/ports/www/firefox && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/print/cups && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
sudo ./rcconf_setup_ports.sh
fi
sudo ./sysctl_setup.sh
sudo ./bootloader_setup.sh
sudo ./devfs_setup.sh
# Setup LightDM/Slick Greeter.
cd /usr/local/etc/lightdm
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g lightdm.conf
sed -i '' s/#greeter-session=example-gtk-gnome/greeter-session=slick-greeter/g lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g lightdm.conf
sed -i '' s/#greeter-setup-script=/greeter-setup-script=/usr/local/bin/numlockx on/g lightdm.conf
sed -i '' s/#autologin-user=/autologin-user=$USER/g lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g lightdm.conf
cat << EOF >slick-greeter.conf
[Greeter]
background = /usr/local/share/backgrounds/0062.jpg
draw-user-backgrounds = true
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = ClassicLooks Irix
icon-theme-name = matefaenza
EOF
# Reboot
shutdown -r now
