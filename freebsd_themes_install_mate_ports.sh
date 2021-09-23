#!/bin/sh
cd
#
clear
# Install the Greybird GTK theme.
echo "Installing the Greybird GTK theme..."
sud portmaster x11-themes/greybird-theme
#
clear
# Install Kvantum Qt5 theme manager.
echo "Installing the Kvantun Qt5 theme manager..."
sudo portmaster x11-themes/Kvantum
cd
git clone https://github.com/varlesh/greybird-kde.git
cd greybird-kde/Kvantum
sudo cp -rv Greybird /usr/local/share/Kvantum/
cd && rm -rf greybird-kde
#
clear
# Install Faenza icon theme with the FreeBSD logo from the Newaita icon set for Applications menu. Not working for some reason.
echo "Installing the Faenza icon theme with the FreeBSD logo from the Newaita icon set for Applications menu..."
sudo portmaster graphics/svg2png
sudo portmaster x11-themes/gnome-icons-faenza
cd /usr/local/share/icons/Faenza
cd places/24 && sudo rm -rf start-here.png
sudo fetch https://raw.githubusercontent.com/cbrnix/Newaita/master/Newaita/.places-default/24/freebsd.svg -o start-here-freebsd.svg
sudo svg2png start-here-freebsd.svg start-here-freebsd.png && sudo rm -rf start-here-freebsd.svg
sudo ln -s start-here-freebsd.png start-here.png
cd ../32 && sudo rm -rf start-here.png
sudo fetch https://raw.githubusercontent.com/cbrnix/Newaita/master/Newaita/.places-default/32/freebsd.svg -o start-here-freebsd.svg
sudo svg2png start-here-freebsd.svg start-here-freebsd.png && sudo rm -rf start-here-freebsd.svg
sudo ln -s start-here-freebsd.png start-here.png
cd ../48 && sudo rm -rf start-here.png
sudo fetch https://raw.githubusercontent.com/cbrnix/Newaita/master/Newaita/.places-default/48/freebsd.svg -o start-here-freebsd.svg
sudo svg2png start-here-freebsd.svg start-here-freebsd.png && sudo rm -rf start-here-freebsd.svg
sudo ln -s start-here-freebsd.png start-here.png
cd ../64 && sudo rm -rf start-here.png
sudo fetch https://raw.githubusercontent.com/cbrnix/Newaita/master/Newaita/.places-default/64/freebsd.svg -o start-here-freebsd.svg
sudo svg2png start-here-freebsd.svg start-here-freebsd.png && sudo rm -rf start-here-freebsd.svg
sudo ln -s start-here-freebsd.png start-here.png
cd ../scalable && sudo rm -rf start-here.svg
sudo fetch https://raw.githubusercontent.com/cbrnix/Newaita/master/Newaita/.places-default/64/freebsd.svg -o start-here-freebsd.svg
sudo ln -s start-here-freebsd.svg start-here.svg
#
clear
# Install Qogir mouse cursors.
echo "Installing Qogir mouse cursors..."
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
sudo ./install.sh
cd && rm -rf Qogir-icon-theme/
#
clear
# Install the Mojave GTK theme (for window borders ony).
echo "Installing Mojave GTK theme (for window borders only)..."
sudo portmaster x11-themes/mojave-gtk-themes
#
clear
# Installing fonts.
echo "Installing fonts..."
sudo portmaster x11-fonts/ubuntu-font
sudo portmaster x11-fonts/sourcecodepro-ttf
sudo portmaster x11-fonts/webfonts
#
# Install the Vertex GTK theme.
echo "Installing the Vertex GTK theme (for LightDM login screen)..."
sudo portmaster x11-themes/gnome-themes-extra x11-themes/gtk-murrine-engine devel/autoconf devel/automake devel/pkgconf x11-toolkits/tk30
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr/local --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install
cd
rm -rf vertex-theme/
#
