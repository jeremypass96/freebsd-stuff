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
sudo chown -R root:wheel /usr/local/share/icons/macOSBigSur/*
cd && rm -rf macOSBigSur.tar.gz
# Get extra wallpapers!
echo "Getting extra wallpapers..."
sudo git clone https://gitlab.com/dwt1/wallpapers.git
cd wallpapers && mv -v *.jpg /usr/local/share/backgrounds/
cd /usr/local/share/backgrounds && sudo chown root:wheel *.jpg && cd
rm -rf wallpapers
clear
# Set up common folders in users home directory.
cd /usr/ports/devel/xdg-user-dirs && sudo make install clean
xdg-user-dirs-update
# Set wallpaper.
gsettings set org.mate.background picture-options zoom && gsettings set org.mate.background picture-filename /usr/local/share/backgrounds/0188.jpg
# Set window titlebar font.
gsettings set org.mate.Marco.general titlebar-font "Ubuntu Bold 11"
# Set window theme.
gsettings set org.mate.Marco.general theme vimix-light-doder
# Turn off middle click on window titlebar.
gsettings set org.mate.Marco.general action-middle-click-titlebar none
# Set theme.
gsettings set org.mate.interface gtk-theme "ClassicLooks Solaris"
# Set icon theme.
gsettings set org.mate.interface icon-theme matefaenza
# Set fonts.
gsettings set org.mate.interface monospace-font-name "Office Code Pro 12"
gsettings set org.mate.interface font-name "Roboto 10"
gsettings set org.mate.caja.desktop font "Roboto 10"
# Turn off a couple useless menus.
gsettings set org.mate.interface show-input-method-menu false
gsettings set org.mate.interface show-unicode-menu false
# Set mouse cursor.
gsettings set org.mate.peripherals-mouse cursor-theme macOSBigSur
#
echo "Your FreeBSD MATE desktop has been set up for you automatically! Enjoy."
