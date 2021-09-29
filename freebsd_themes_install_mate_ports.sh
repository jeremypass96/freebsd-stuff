#!/bin/sh
cd
#
clear
# Install the ClassicLooks GTK themes.
echo "Installing the ClassicLooks GTK themes..."
sud portmaster x11-themes/classiclooks x11-themes/mate-icon-theme-faenza
cd
git clone https://github.com/vinceliuice/vimix-gtk-themes.git
cd vimix-gtk-themes
sudo ./install.sh --dest /usr/local/share/themes --color light
#
clear
# Installing fonts.
echo "Installing fonts..."
sudo portmaster x11-fonts/ubuntu-font x11-fonts/office-code-pro x11-fonts/webfonts x11-fonts/droid-fonts-ttf x11-fonts/materialdesign-ttf
#
# Install the Vertex GTK theme.
echo "Installing the Vertex GTK theme (for LightDM login screen)..."
sudo portmaster x11-themes/gnome-themes-extra x11-themes/gtk-murrine-engine devel/autoconf devel/automake devel/pkgconf
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr/local --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install clean
cd && rm -rf vertex-theme
