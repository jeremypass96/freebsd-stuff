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
cd && rm -rf vertex-theme/
#
clear
# Install the Greybird GTK theme.
echo "Installing the Greybird GTK theme..."
sudo pkg install -y greybird-theme
#
clear
# Install Kvantum Qt5 theme manager.
echo "Installing the Kvantun Qt5 theme manager..."
sudo pkg install -y Kvantum-qt5
git clone https://github.com/varlesh/greybird-kde.git
cd greybird-kde/Kvantum
sudo cp -rv Greybird /usr/local/share/Kvantum/
cd && rm -rf greybird-kde
#
clear
# Install Newaita icon theme with FreeBSD logo for Applications menu.
echo "Installing the Newaita icon theme with FreeBSD logo for Applications menu..."
cd
git clone https://github.com/cbrnix/Newaita.git
cd Newaita/
sudo cp -rv Newaita /usr/local/share/themes/
cd /usr/local/share/themes/Newaita/
sudo ./FV.sh
cd places/24
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../32
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../48
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd ../64
sudo rm -rf start-here.svg
sudo ln -s distributor-logo-freebsd.svg start-here.svg
cd
rm -rf Newaita
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
# Install the Mojave GTK theme (for window borders ony).
echo "Installing Mojave GTK theme (for window borders only)..."
sudo pkg install -y mojave-gtk-themes
#
clear
# Installing fonts.
echo "Installing fonts..."
sudo pkg install -y ubuntu-font sourcecodepro-ttf
