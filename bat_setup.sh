#!/bin/sh
# This script will setup the Catppuccin "mocha" theme for bat. FreeBSD version.

cd && git clone https://github.com/catppuccin/bat.git
mkdir -p "$(bat --config-dir)/themes"
cp *.tmTheme "$(bat --config-dir)/themes"
bat cache --build
sed -i '' s/'1337/Catppuccin-mocha'/g /home/$USER/.config/bat/config