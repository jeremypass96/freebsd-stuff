#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Katana setup script."
echo "This script will setup Xorg, the Katana desktop, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press any key to continue..." resp

clear

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { 
  url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF
#
cat << EOF > /usr/local/etc/pkg/repos/Katana.conf
Katana: {
  url: "pkg+https://raw.githubusercontent.com/fluxer/katana-freebsd/master",
  mirror_type: "srv",
  enabled: yes
}
EOF
pkg update

echo ""
read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups
sysrc cupsd_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ "$resp" = Letter ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = A4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ "$resp" = n ]; then
continue
fi

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji katana-workspace katana-extraapps Kvantum-qt5 firefox webfonts micro xclip zsh ohmyzsh neofetch mp4v2 numlockx devcpu-data automount unix2dos smartmontools ubuntu-font sourcecodepro-ttf webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize
pkg clean -y

clear 

# Setup rc.conf file.
./rcconf_setup.sh

# Enable KDM (KDE4 display manager) on boot.
sysrc kdm_enable="YES"

# Install 3rd party software.
./software_dialog_pkgs.sh
