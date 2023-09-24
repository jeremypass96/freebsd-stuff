#!/bin/sh
# This script will setup the Catppuccin syntax highlighter theme for bat. FreeBSD version.
# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
  dialog --title "Root Privileges Required" --msgbox "Please run this setup script as root via 'su'! Thanks." 10 50
  exit
fi

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

# Generate initial configuration file for bat (this script is running as root, remember?)
bat --generate-config-file

# Modify the configuration settings for the root user.
sed -i 's/#--theme="TwoDark"/--theme="$selected_theme"/g' $HOME/.config/bat/config
sed -i 's/#--italic-text=always/--italic-text=always/g' $HOME/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> $HOME/.config/bat/config
echo '--map-syntax "config:INI"' >> $HOME/.config/bat/config

# Copy the user configuration to /usr/share/skel so new users get the same setup.
mkdir -p /usr/share/skel/dot.config/bat
cp -v /root/.config/bat/config /usr/share/skel/dot.config/bat

# Copy root's configuration to the user's configuration.
mkdir -p /home/$USER/.config/bat
cp -v $HOME/.config/bat/config /home/$USER/.config/bat/config

# Setup the Catppuccin theme for bat.
cd $HOME
git clone https://github.com/catppuccin/bat.git
cd bat
mkdir -p "$(bat --config-dir)/themes"; cp *.tmTheme "$(bat --config-dir)/themes"; bat cache --build

# Copy themes to /etc/skel.
mkdir -p /usr/share/skel/dot.config/bat/themes; cp *.tmTheme /usr/share/skel/dot.config/bat/themes; bat cache --build

# Modify the configuration settings for the user.
sed -i 's/#--theme="TwoDark"/--theme="$selected_theme"/g' /home/$USER/.config/bat/config
sed -i 's/#--italic-text=always/--italic-text=always/g' /home/$USER/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> /home/$USER/.config/bat/config
echo '--map-syntax "config:INI"' >> /home/$USER/.config/bat/config
chown $USER:$USER /home/$USER/.config/bat/config

# Copy themes to user's home directory.
mkdir -p /home/$USER/.config/bat/themes; cp *.tmTheme /home/$USER/.config/bat/themes; bat cache --build
chown -R $USER:$USER /home/$USER/.config/bat/themes

echo "Bat syntax highlighter has been configured with the selected theme ($selected_theme) for both your user and root."
rm -rf $HOME/bat