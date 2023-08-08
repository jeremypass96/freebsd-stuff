#!/bin/sh
# This script will setup the Catppuccin "mocha" theme for bat. FreeBSD version.

# Clone and install the theme for the user
cd "$HOME" || exit
git clone https://github.com/catppuccin/bat.git
cd bat
mkdir -p "$(bat --config-dir)/themes"
cp *.tmTheme "$(bat --config-dir)/themes"
bat cache --build
sed -i '' 's/1337/Catppuccin-mocha/g' "$HOME/.config/bat/config"

# Install the theme for root as well
sudo sh -c 'mkdir -p "$(bat --config-dir)/themes"; cp /usr/home/$SUDO_USER/bat/*.tmTheme "$(bat --config-dir)/themes"; bat cache --build; sed -i "" "s/1337/Catppuccin-mocha/g" "/root/.config/bat/config"'

echo "Bat syntax highlighter has been configured with the Catppuccin 'mocha' theme for both your user and root."
rm -rf $HOME/bat
sudo rm -rf root/bat
