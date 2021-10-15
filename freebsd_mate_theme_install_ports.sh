#!/bin/sh
cd
#
clear
# Install the ClassicLooks GTK themes.
echo "Installing the ClassicLooks GTK themes..."
cd /usr/ports/x11-themes/classiclooks && sudo make install clean 
cd /usr/ports/x11-themes/mate-icon-theme-faenza && sudo make install clean
cd
git clone https://github.com/vinceliuice/vimix-gtk-themes.git
cd vimix-gtk-themes
sudo ./install.sh --dest /usr/local/share/themes --color light
cd && rm -rf vimix-gtk-themes
#
clear
# Install fonts.
echo "Installing fonts..."
cd /usr/ports/x11-fonts/ubuntu-font && sudo make install clean
cd /usr/ports/x11-fonts/office-code-pro && sudo make install clean
cd /usr/ports/x11-fonts/webfonts && sudo make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && sudo make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && sudo make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && sudo make install clean
#
clear
# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
sudo tar -xvf macOSBigSur.tar.gz -C /usr/local/share/icons/
echo "Setting proper file permissions..."
cd /usr/local/share/icons && sudo chown root:wheel macOSBigSur/*
cd && rm -rf macOSBigSur.tar.gz
#
clear
# Get extra wallpapers!
echo "Getting extra wallpapers. Who doesn't love wallpapers?"
sudo git clone https://gitlab.com/dwt1/wallpapers.git
cd wallpapers/ && cp -v *.jpg /usr/local/share/backgrounds/
cd /usr/local/share/backgrounds && sudo chown root:wheel *.jpg && cd
clear
