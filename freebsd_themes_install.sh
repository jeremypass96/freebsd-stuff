#!/usr/local/bin/bash
cd ~
# Install the Vertex GTK theme.
sudo pkg install gnome-themes-extra gtk-murrine-engine autoconf automake pkgconf gtk3
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr --disable-gnome-shell --disable-light --disable-unity --disable-xfwm --with-gnome=3.22
sudo make install
cd ~
rm -rf vertex-theme/
# Install the Arc and Materia GTK theme.
sudo pkg install gtk-arc-themes materia-gtk-theme
# Install the Vimix GTK theme. Installing only for window borders.
git clone https://github.com/vinceliuice/vimix-gtk-themes.git && cd vimix-gtk-themes/
sudo ./install.sh -d /usr/share/themes -s standard
cd ~
rm -rf vimix-gtk-themes/
# Install Kvantum Qt5 theme manager.
sudo pkg install Kvantum-qt5
# Install Qogir icon theme.
wget https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MTI5MjY2OTMiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6Ijg4ZGIyNjk0OTljZmIxZGI3MWE0Mjc1YWMzYTQwN2E3NmExMGVjZWRmYTI4NTExOWJjZDg5NDZmODNkYTJjZDc2ZjZiMTA2YmZlOGUwYTYzOTIxOTZlMTU4MWZmYzJlNWI4YzQ5YWRiNWU2MTFkZDc5ZWIyZjVhNTRkY2UwZDIxIiwidCI6MTYxMzk2MjA5OSwic3RmcCI6ImE1YmIwZTllY2Y4NWNiMmI2MTgxYmEyOGY5NTAxODU0Iiwic3RpcCI6IjE3NC44NC41Ny4xMSJ9.TBX12Il6NpH8Hv4vYVGhS-T6g1X3OwFcn7wFoAX7cs4/Qogir-ubuntu.tar.xz
tar -xvf Qogir-ubuntu.tar.xz
cp -rv Qogir-* /usr/local/share/themes
