#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot. Run as root!
clear
echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg and MATE (or Xfce) for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? After answering this question, the required packages/ports will automatically start installing! (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
pkg update
pkg upgrade -y
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries cups xfburn firefox webfonts virtualbox-ose micro zsh ohmyzsh neofetch lightdm slick-greeter numlockx
echo "Do you want to use MATE or Xfce as your desktop?"
read answer
if [ $answer = "mate" ] ; then
pkg install -y mate
fi
if [ $answer = "xfce" ] ; then
pkg install -y xfce
fi
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
cd /usr/ports/sysutils/xfburn && make install clean
cd /usr/ports/www/firefox && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/print/cups && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/x11/numlockx && make install clean
echo "Do you want to use MATE or Xfce as your desktop?"
read answer
if [ $answer = "mate" ] ; then
cd /usr/ports/x11/mate && make install clean
fi
if [ $answer = "xfce" ] ; then
cd /usr/ports/x11-wm/xfce4 && make install clean
fi
fi
# Setup LightDM/Slick Greeter.
cd /usr/local/etc/lightdm
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g lightdm.conf
sed -i '' s/#greeter-session=example-gtk-gnome/greeter-session=slick-greeter/g lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g lightdm.conf
sed -i '' s/#greeter-setup-script=/greeter-setup-script=/usr/local/bin/numlockx on/g lightdm.conf
sed -i '' s/#autologin-user=/autologin-user=$USER/g lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g lightdm.conf
echo "[Greeter]" > slick-greeter.conf
echo "background = /usr/local/share/backgrounds/0062.jpg" >> slick-greeter.conf
echo "draw-user-backgrounds = true" >> slick-greeter.conf
echo "draw-grid = false" >> slick-greeter.conf
echo "show-hostname = true" >> slick-greeter.conf
echo "show-a11y = false" >> slick-greeter.conf
echo "show-keyboard = false" >> slick-greeter.conf
echo "clock-format = %I:%M %p" >> slick-greeter.conf
echo "theme-name = ClassicLooks Irix" >> slick-greeter.conf
echo "icon-theme-name = matefaenza" >> slick-greeter.conf
# Reboot
shutdown -r now
