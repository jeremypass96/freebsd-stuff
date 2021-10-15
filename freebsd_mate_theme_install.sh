#!/bin/sh
cd
#
clear
# Install the ClassicLooks GTK themes.
echo "Installing the ClassicLooks GTK themes..."
pkg install -y classiclooks
pkg isntall -y mate-icon-theme-faenza
git clone https://github.com/vinceliuice/vimix-gtk-themes.git
cd vimix-gtk-themes
sudo ./install.sh --dest /usr/local/share/themes --color light
cd && rm -rf vimix-gtk-themes
#
clear
# Install fonts.
echo "Installing fonts..."
pkg install -y ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf
#
clear
# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
echo 'Moving cursor theme directory to "/usr/local/share/icons"...'
sudo mv macOSBigSur /usr/local/share/icons/
echo "Setting proper file permissions..."
cd /usr/local/share/icons && sudo chown root:wheel macOSBigSur/*
cd && rm -rf macOSBigSur.tar.gz
#
clear
