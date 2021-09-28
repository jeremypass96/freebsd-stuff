#!/bin/sh
cd
#
clear
# Install the Canta GTK theme with icon theme. The Numix icon theme is needed, otherwise the icon theme is incomplete.
echo "Installing the Canta GTK theme with icon theme..."
sud portmaster x11-themes/canta-gtk-themes x11-themes/canta-icon-theme x11-themes/numix-icon-theme
#
clear
# Install Kvantum Qt5 theme manager with theme.
echo "Installing the Kvantun Qt5 theme manager with theme..."
sudo portmaster x11-themes/Kvantum
cd
git clone https://github.com/vinceliuice/Canta-kde.git
cd Canta-kde/Kvantum
sudo cp -rv Canta-light /usr/local/share/Kvantum/
cd && rm -rf Canta-kde
#
clear
# Install Qogir mouse cursors.
echo "Installing Qogir mouse cursors..."
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
sudo ./install.sh
cd && rm -rf Qogir-icon-theme/
#
clear
# Installing fonts.
echo "Installing fonts..."
sudo portmaster x11-fonts/ubuntu-font x11-fonts/sourcecodepro-ttf x11-fonts/webfonts x11-fonts/droid-fonts-ttf x11-fonts/materialdesign-ttf
#
# Install the Vertex GTK theme.
echo "Installing the Vertex GTK theme (for LightDM login screen)..."
sudo portmaster x11-themes/gnome-themes-extra x11-themes/gtk-murrine-engine devel/autoconf devel/automake devel/pkgconf
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr/local --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install clean
cd && rm -rf vertex-theme
