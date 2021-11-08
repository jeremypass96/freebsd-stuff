#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi
#
clear
echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg, MATE, some useful software for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then
# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF >/usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { url: "http://pkg0.nyi.freebsd.org/${ABI}/latest" }
EOF
pkg update
# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji cups mate xfburn parole firefox thunderbird audacity handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell webfonts virtualbox-ose micro zsh ohmyzsh neofetch lightdm slick-greeter mp4v2 classiclooks flatery-icon-themes wine wine-mono wine-gecko numlockx devcpu-data automount
./rcconf_setup.sh
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
cd /usr/ports/mail/thunderbird && make install clean
cd /usr/ports/audio/audacity && make install clean
cd /usr/ports/multimedia/handbrake && make install clean
cd /usr/ports/sysutils/isomaster && make install clean
cd /usr/ports/editors/abiword && make install clean
cd /usr/ports/math/gnumeric && make install clean
cd /usr/ports/net-p2p/transmission-gtk && make install clean
cd /usr/ports/audio/asunder && make install clean
cd /usr/ports/graphics/gimp && make install clean
cd /usr/ports/graphics/inkscape && make install clean
cd /usr/ports/graphics/pinta && make install clean
cd /usr/ports/graphics/shotwell && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/print/cups && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2/ && make install clean
cd /usr/ports/x11-themes/classiclooks && make install clean 
cd /usr/ports/x11-themes/flatery-icon-themes && make install clean
cd /usr/ports/emulators/wine && make install clean
cd /usr/ports/emulators/wine-gecko && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
./rcconf_setup_ports.sh
fi
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh
# Setup automoumt.
cat << EOF >/usr/local/etc/automount.conf
USERUMOUNT=YES
REMOVEDIRS=YES
ATIME=NO
EOF
# Setup LightDM/Slick Greeter.
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#greeter-session=example-gtk-gnome/greeter-session=slick-greeter/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#greeter-setup-script=/greeter-setup-script=/usr/local/bin/numlockx on/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user=/autologin-user=$USER/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g /usr/local/etc/lightdm/lightdm.conf
cat << EOF >/usr/local/etc/lightdm/slick-greeter.conf
[Greeter]
background = /usr/local/share/backgrounds/0062.jpg
draw-user-backgrounds = true
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = ClassicLooks Solaris
icon-theme-name = Flatery-Black
EOF
# Update FreeBSD base.
freebsd-update fetch install
# Reboot
shutdown -r now
