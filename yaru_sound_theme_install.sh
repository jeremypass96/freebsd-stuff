#!/usr/local/bin/bash
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
