#!/bin/sh
# This script will setup the Catppuccin "mocha" theme for bat. FreeBSD version.

# Prompt the user to choose a theme
echo "Select a theme for the 'bat' syntax highlighter:"
echo "1.) Latte"
echo "2.) Frappé"
echo "3.) Macchiato"
echo "4.) Mocha"
read -p "Enter the number of your choice: " theme_choice

case $theme_choice in
    1)
        selected_theme="Catppuccin-latte"
        ;;
    2)
        selected_theme="Catppuccin-frappe"
        ;;
    3)
        selected_theme="Catppuccin-macchiato"
        ;;
    4)
        selected_theme="Catppuccin-mocha"
        ;;
    *)
        echo "Invalid choice. Defaulting to 'Mocha' theme."
        selected_theme="Catppuccin-mocha"
        ;;
esac

# Generate initial configuration file for bat
bat --generate-config-file

# Modify the configuration settings for current user.
sed -i 's/#--theme="TwoDark"/--theme="$selected_theme"/g' /home/$USER/.config/bat/config
sed -i 's/#--italic-text=always/--italic-text=always/g' /home/$USER/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> "$HOME/.config/bat/config"
echo '--map-syntax "config:INI"' >> "$HOME/.config/bat/config"

# Copy the user configuration to /usr/share/skel so new users get the same setup.
sudo mkdir -p /usr/share/skel/dot.config/bat
sudo cp -v "$/home/$USER/.config/bat/config" /usr/share/skel/dot.config/bat

# Copy the user configuration to root's configuration.
sudo mkdir -p /root/.config/bat
sudo cp -v "/home/$USER/.config/bat/config" /root/.config/bat/

# Setup the Catppuccin theme for bat.
cd "$HOME" || exit
git clone https://github.com/catppuccin/bat.git
cd bat
sudo sh -c 'mkdir -p "$(bat --config-dir)/themes"; cp *.tmTheme "$(bat --config-dir)/themes"; bat cache --build'

# Copy themes to /etc/skel.
sudo sh -c 'mkdir -p /usr/share/skel/dot.config/bat/themes; cp *.tmTheme /usr/share/skel/dot.config/bat/themes; bat cache --build'

# Modify the configuration settings for root.
sed -i 's/#--theme="TwoDark"/--theme="$selected_theme"/g' /root/.config/bat/config
sed -i 's/#--italic-text=always/--italic-text=always/g' /root/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> "/root/.config/bat/config"
echo '--map-syntax "config:INI"' >> "/root/.config/bat/config"

# Copy themes to root's home directory.
sudo sh -c 'mkdir -p /root/.config/bat/themes; cp *.tmTheme /root/.config/bat/themes; bat cache --build'

echo "Bat syntax highlighter has been configured with the selected theme ($selected_theme) for both your user and root."
rm -rf "$HOME/bat"
sudo rm -rf /root/bat
