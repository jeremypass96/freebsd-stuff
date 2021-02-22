#!/usr/local/bin/bash
cd
# Install the Vertex GTK theme.
sudo pkg install -y gnome-themes-extra gtk-murrine-engine autoconf automake pkgconf gtk3
git clone https://github.com/horst3180/vertex-theme --depth 1 && cd vertex-theme
./autogen.sh --prefix=/usr --disable-gnome-shell --disable-light --disable-unity --disable-xfwm
sudo make install
cd
rm -rf vertex-theme/
#
# Install Kvantum Qt5 theme manager.
sudo pkg install -y Kvantum-qt5
# Install Qogir icon theme.
wget https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MTI5MjY2OTMiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6Ijg4ZGIyNjk0OTljZmIxZGI3MWE0Mjc1YWMzYTQwN2E3NmExMGVjZWRmYTI4NTExOWJjZDg5NDZmODNkYTJjZDc2ZjZiMTA2YmZlOGUwYTYzOTIxOTZlMTU4MWZmYzJlNWI4YzQ5YWRiNWU2MTFkZDc5ZWIyZjVhNTRkY2UwZDIxIiwidCI6MTYxMzk2MjA5OSwic3RmcCI6ImE1YmIwZTllY2Y4NWNiMmI2MTgxYmEyOGY5NTAxODU0Iiwic3RpcCI6IjE3NC44NC41Ny4xMSJ9.TBX12Il6NpH8Hv4vYVGhS-T6g1X3OwFcn7wFoAX7cs4/Qogir-ubuntu.tar.xz
tar -xvf Qogir-ubuntu.tar.xz
cp -rv Qogir-ubuntu /usr/share/themes
cp -rv Qogir-ubuntu-dark /usr/share/themes
rm Qogir-ubuntu.tar.xz
#
# Install the Yaru GTK/sound theme.
sudo pkg install -y meson sassc python3
git clone https://github.com/ubuntu/yaru.git
cd yaru/
echo "option('icons', type: 'boolean', value: false, description:'build icons component')" > meson_options.txt
echo "option('gnome-shell', type: 'boolean', value: false, description:'build gnome-shell component')" >> meson_options.txt
echo "option('gnome-shell-gresource', type: 'boolean', value: false, description: 'build gnome-shell component in gresources')" >> meson_options.txt
echo "option('gtk', type: 'boolean', value: true, description:'build gtk component')" >> meson_options.txt
echo "option('gtksourceview', type: 'boolean', value: false, description:'build gtksourceview component')" >> meson_options.txt
echo "option('sounds', type: 'boolean', value: true, description:'build sounds component')" >> meson_options.txt
echo "option('sessions', type: 'boolean', value: false, description:'build sessions component')" >> meson_options.txt
echo "option('communitheme_compat', type: 'boolean', value: false, description:'build communitheme-compact')" >> meson_options.txt
echo "" >> meson_options.txt
echo "option('default', type: 'boolean', value: true, description:'build Yaru gtk default flavour')" >> meson_options.txt
echo "option('dark', type: 'boolean', value: false, description:'build Yaru gtk dark flavour')" >> meson_options.txt
echo "option('light', type: 'boolean', value: false, description:'build Yaru gtk light flavour')" >> meson_options.txt
echo "option('ubuntu-unity', type: 'boolean', value: false, description:'build Yaru with Unity assets')" >> meson_options.txt
sudo ninja -C "build" install
