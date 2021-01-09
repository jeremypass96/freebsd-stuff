#!/usr/local/bin/bash

cd ~
# Install the Vertex GTK theme.
doas pkg install gnome-themes-extra gtk-murrine-engine autoconf automake pkgconf gtk3 git
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr --disable-cinnamon --disable-gnome-shell --disable-light -disable-unity --disable-xfwm --with-gnome=3.22
doas make install
cd ~
rm -rf vertex-theme/
# Install the Arc GTK theme.
doas pkg install gtk-arc-themes
# Install the Vimix GTK theme. Installing only for window borders.
git clone https://github.com/vinceliuice/vimix-gtk-themes.git && cd vimix-gtk-themes/
doas ./install.sh -d /usr/share/themes -s standard
cd ~
rm -rf vimix-gtk-themes/
# Install Kvantum Qt5 theme manager.
doas pkg install Kvantum-qt5
# Install Qogir cursor theme.
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
doas ./install.sh
cd ~
rm -rf Qogir-icon-theme/