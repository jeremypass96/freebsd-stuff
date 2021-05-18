#!/usr/local/bin/bash
cd
#
clear
# Install the Vertex GTK theme.
echo "Installing the Vertex GTK theme (for LightDM login screen)..."
sudo pkg install -y gnome-themes-extra gtk-murrine-engine autoconf automake pkgconf gtk3
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install
cd
rm -rf vertex-theme/
#
clear
# Install Kvantum Qt5 theme manager.
echo "Installing the Kvantum Qt5 theme manager..."
sudo pkg install -y Kvantum-qt5
#
clear
# Install Qogir mouse cursors.
echo "Installing Qogir mouse cursors..."
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
sudo ./install.sh
cd
rm -rf Qogir-icon-theme/
#
clear
# Install the Vimix GTK theme (for window borders ony).
echo "Installing Vimix GTK theme (for window borders only)..."
git clone https://github.com/vinceliuice/vimix-gtk-themes.git && cd vimix-gtk-themes/
sudo ./install.sh -d /usr/share/themes -s standard
cd
rm -rf vimix-gtk-themes/
#
clear
# Install the Yaru GTK/icon theme.
echo "Installing the Yaru GTK/icon theme..."
sudo pkg install -y yaru-gtk-themes yaru-icon-theme
#
clear
# Install fonts.
echo "Installing fonts..."
sudo pkg install -y ubuntu-font sourcecodepro-ttf
