#!/usr/local/bin/bash
cd
# Install the Arc and Materia GTK theme.
echo "Installing the Arc GTK theme..."
sudo pkg install -y gtk-arc-themes
#
# Install Kvantum Qt5 theme manager.
echo "Installing the Kvantun Qt5 theme manager..."
sudo pkg install -y Kvantum-qt5
#
# Install Tango icon theme and fix the menu logo icon.
echo "Fixing stupid MATE menu icon. Replacing the Tango icon logo with the FreeBSD logo..."
sudo pkg install -y icons-tango icons-tango-extras svg2png gtk-update-icon-cache
git clone https://github.com/cbrnix/Newaita.git
cd Newaita/Newaita/.places-default/24/
svg2png freebsd.svg freebsd.png
sudo cp -v freebsd.png /usr/local/share/icons/Tango/22x22/places/start-here.png
sudo cp -v freebsd.png /usr/local/share/icons/Tango/24x24/places/start-here.png
sudo cp -v freebsd.png /usr/local/share/icons/Tango/32x32/places/start-here.png
sudo cp -v freebsd.svg /usr/local/share/icons/Tango/scalable/places/start-here.svg
sudo gtk-update-icon-cache /usr/local/share/icons/Tango/
cd
rm -rf Newaita/
echo "Icon is now fixed!"
#
# Install Qogir mouse cursors.
echo "Installing Qogir mouse cursors..."
git clone https://github.com/vinceliuice/Qogir-icon-theme.git && cd Qogir-icon-theme/src/cursors/
sudo ./install.sh
cd
rm -rf Qogir-icon-theme/
#
# Install the Vimix GTK theme (for window borders ony).
echo "Installing Vimix GTK theme (for window borders only)..."
git clone https://github.com/vinceliuice/vimix-gtk-themes.git && cd vimix-gtk-themes/
sudo ./install.sh -d /usr/share/themes -s standard
cd
rm -rf vimix-gtk-themes/
#
# Install the Yaru sound theme. GTK theme doesn't work with MATE properly.
sudo pkg install -y meson sassc python3
git clone https://github.com/ubuntu/yaru.git
cd yaru/
echo "option('icons', type: 'boolean', value: false, description:'build icons component')" > meson_options.txt
echo "option('gnome-shell', type: 'boolean', value: false, description:'build gnome-shell component')" >> meson_options.txt
echo "option('gnome-shell-gresource', type: 'boolean', value: false, description: 'build gnome-shell component in gresources')" >> meson_options.txt
echo "option('gtk', type: 'boolean', value: false, description:'build gtk component')" >> meson_options.txt
echo "option('gtksourceview', type: 'boolean', value: false, description:'build gtksourceview component')" >> meson_options.txt
echo "option('sounds', type: 'boolean', value: true, description:'build sounds component')" >> meson_options.txt
echo "option('sessions', type: 'boolean', value: false, description:'build sessions component')" >> meson_options.txt
echo "option('communitheme_compat', type: 'boolean', value: false, description:'build communitheme-compact')" >> meson_options.txt
echo "" >> meson_options.txt
echo "option('default', type: 'boolean', value: false, description:'build Yaru gtk default flavour')" >> meson_options.txt
echo "option('dark', type: 'boolean', value: false, description:'build Yaru gtk dark flavour')" >> meson_options.txt
echo "option('light', type: 'boolean', value: false, description:'build Yaru gtk light flavour')" >> meson_options.txt
echo "option('ubuntu-unity', type: 'boolean', value: false, description:'build Yaru with Unity assets')" >> meson_options.txt
sudo ninja -C "build" install
