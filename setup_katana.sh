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
if [ 0"$resp" = 0y ]; then
pkg install -y cups
sysrc cupsd_enable="YES"
fi
read -p "Paper size? (Letter/A4): " resp
if [ 0"$resp" = 0Letter ]; then
pkg install -y papersize-default-letter
fi
if [ 0"$resp" = 0A4 ]; then
pkg install -y papersize-default-a4
fi
if [ 0"$resp" = 0n ]; then
continue
fi

clear

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji katana-workspace katana-extraapps Kvantum-qt5 firefox webfonts micro xclip zsh ohmyzsh neofetch mp4v2 numlockx devcpu-data automount unix2dos smartmontools ubuntu-font sourcecodepro-ttf webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize
pkg clean -y

clear 

# Setup rc.conf file.
./rcconf_setup.sh

# Enable KDM (KDE4 display manager) on boot.
sysrc kdm_enable="YES"

clear

read -p "Do you want to install any extra 3rd party software?

1. Audacity (audio editor)
2. Xfburn (CD burner)
3. Handbrake (video file converter)
4. ISO Master (ISO file editor)
5. AbiWord (word processor)
6. Gnumeric (speadsheet)
7. Transmission (Torrent downloader)
8. Asunder (CD ripper)
9. GIMP (image editor)
10. Inkskape (vector graphics editor)
11. Pinta (image editor similar to Paint.NET on Windows)
12. Shotwell (photo organizer/editor)
13. VirtualBox (run multiple operating systems on your PC)
14. Wine (run Windows applications)

15. All of the above.
16. None of the above.
-> " resp
if [ 0"$resp" = 01 ]; then
pkg install -y audacity
fi
if [ 0"$resp" = 02 ]; then
pkg install -y xfburn
fi
if [ 0"$resp" = 03 ]; then
pkg install -y handbrake
fi
if [ 0"$resp" = 04 ]; then
pkg install -y isomaster
fi
if [ 0"$resp" = 05 ]; then
pkg install -y abiword
fi
if [ 0"$resp" = 06 ]; then
pkg install -y gnumeric
fi
if [ 0"$resp" = 07 ]; then
pkg install -y transmission-gtk
fi
if [ 0"$resp" = 08 ]; then
pkg install -y asunder
fi
if [ 0"$resp" = 09 ]; then
pkg install -y gimp
fi
if [ 0"$resp" = 010 ]; then
pkg install -y inkscape
fi
if [ 0"$resp" = 011 ]; then
pkg install -y pinta
fi
if [ 0"$resp" = 012 ]; then
pkg install -y shotwell
fi
if [ 0"$resp" = 013 ]; then
pkg install -y virtualbox-ose
fi
if [ 0"$resp" = 014 ]; then
pkg install -y wine wine-mono wine-gecko
fi
if [ 0"$resp" = 015 ]; then
pkg install -y audacity xfburn handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell virtualbox-ose wine wine-mono wine-gecko
fi
if [ 0"$resp" = 016 ]; then
continue
fi
