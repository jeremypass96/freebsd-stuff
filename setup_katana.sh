#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Katana setup script. This script will setup Xorg, the Katana desktop, some useful software for you, along with the rc.conf file being tweaked for desktop use."

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest", mirror_type: "srv", signature_type: "fingerprints", fingerprints: "/usr/share/keys/pkg", enabled: yes }' > /usr/local/etc/pkg/repos/FreeBSD.conf
echo 'Katana: { url: "pkg+https://raw.githubusercontent.com/fluxer/katana-freebsd/master", mirror_type: "srv", enabled: yes }' > /usr/local/etc/pkg/repos/Katana.conf
pkg update -y

echo "Do you plan to use a printer? (y/n)"
read answer
if [ $answer = "y" ] ; then
pkg install cups papersize-default-letter
sysrc cupsd_enable="YES"
fi
if [ $answer = "n" ] ; then
continue
fi

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji katana-workspace katana-extraapps Kvantum-qt5 firefox audacity handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell webfonts virtualbox-ose micro xclip zsh ohmyzsh neofetch mp4v2 wine wine-mono wine-gecko numlockx devcpu-data automount unix2dos smartmontools ubuntu-font sourcecodepro-ttf webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf
pkg clean -y

# Setup rc.conf file.
./rcconf_setup.sh

# Enable KDM (KDE4 display manager) on boot.
sysrc kdm_enable="YES"
