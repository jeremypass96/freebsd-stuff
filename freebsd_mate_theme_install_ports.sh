#!/bin/sh
cd
#
clear
# Install the ClassicLooks GTK themes.
echo "Installing the ClassicLooks GTK themes..."
sudo portmaster x11-themes/classiclooks x11-themes/mate-icon-theme-faenza
cd
git clone https://github.com/vinceliuice/vimix-gtk-themes.git
cd vimix-gtk-themes
sudo ./install.sh --dest /usr/local/share/themes --color light
cd && rm -rf vimix-gtk-themes
#
clear
# Install fonts.
echo "Installing fonts..."
sudo portmaster x11-fonts/ubuntu-font x11-fonts/office-code-pro x11-fonts/webfonts x11-fonts/droid-fonts-ttf x11-fonts/materialdesign-ttf
#
clear
# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
cd
fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
echo 'Moving cursor theme directory to "/usr/local/share/icons"...'
sudo mv macOSBigSur /usr/local/share/icons/
echo "Setting proper file permissions..."
cd /usr/local/share/icons && sudo chown root:wheel macOSBigSur/*
cd && rm -rf macOSBigSur.tar.gz
#
clear
