#!/bin/sh

# Final setup stage.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
    echo "Please run this setup script as root via 'su'! Thanks."
    exit
fi

cd Dotfiles/

# Export options to system and user profile files.
for profile in /etc/profile /home/$USER/.profile /usr/share/skel/dot.profile; do
    sed -i '' 's/EDITOR=vi/EDITOR=micro/g' $profile
    echo "" >> $profile
    echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> $profile
    echo 'PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO' >> $profile
    echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> $profile
    cat << EOF >> $profile
# Generate bat cache.
flag_file=$HOME/.bat_cache

# Check if the flag file exists
if [ ! -f $flag_file ]; then
    # Run the command only if the flag file doesn't exist
    sudo -u $USER bat cache --build
    # Create the flag file to indicate that the command has been executed
    touch $flag_file
fi
EOF
done

# Copy over zsh config.
cp -v .zshrc /home/$USER
cp -v .zshrc /usr/share/skel/dot.zshrc
cp -v /usr/share/skel/dot.zshrc /root/.zshrc
chown $USER:$USER /home/$USER/.zshrc

# Copy over neofetch config.
mkdir -p /home/$USER/.config/neofetch
cp -v config/neofetch/config.conf /home/$USER/.config/neofetch
mkdir -p /root/.config/neofetch
cp -v config/neofetch/config.conf /root/.config/neofetch
mkdir -p /usr/share/skel/dot.config/neofetch
cp -v config/neofetch/config.conf /usr/share/skel/dot.config/neofetch
chown -R $USER:$USER /home/$USER/.config/neofetch

# Copy over micro config.
mkdir -p /home/$USER/.config/micro
cp -v config/micro/settings.json /home/$USER/.config/micro
mkdir -p /root/.config/micro
cp -v config/micro/settings.json /root/.config/micro
mkdir -p /usr/share/skel/dot.config/micro
cp -v config/micro/settings.json /usr/share/skel/dot.config/micro
chown -R $USER:$USER /home/$USER/.config/micro

# Install Catppuccin color schemes for micro.
mkdir -p /home/$USER/.config/micro/colorschemes
mkdir -p /usr/share/skel/dot.config/micro/colorschemes
mkdir -p /root/.config/micro/colorschemes
cd && git clone https://github.com/catppuccin/micro.git
cd micro/src

echo "Which Catppuccin colors do you want for micro?"
echo "1.) Latte"
echo "2.) Frappé"
echo "3.) Macchiato"
echo "4.) Mocha"
read -p "-> " resp

if [ "$resp" = 1 ]; then
    chosen_scheme="catppuccin-latte.micro"
elif [ "$resp" = 2 ]; then
    chosen_scheme="catppuccin-frappe.micro"
elif [ "$resp" = 3 ]; then
    chosen_scheme="catppuccin-macchiato.micro"
elif [ "$resp" = 4 ]; then
    chosen_scheme="catppuccin-mocha.micro"
fi

cp -v $chosen_scheme /home/$USER/.config/micro/colorschemes
chown -R $USER:$USER /home/$USER/.config/micro/colorschemes
cp -v $chosen_scheme /usr/share/skel/dot.config/micro/colorschemes
cp -v $chosen_scheme /root/.config/micro/colorschemes

cd && rm -rf micro

cd /home/$USER/freebsd-stuff

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

# Get "zsh-autosuggestions" and "zsh-syntax-highlighting" Oh My Zsh plugins.
ZSH_CUSTOM=/usr/local/share/oh-my-zsh/custom
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
unset ZSH_CUSTOM

# Copy over lsd config.
mkdir -p /home/$USER/.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /home/$USER/.config/lsd
mkdir -p /root/.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chown -R $USER:$USER /home/$USER/.config/lsd

# Change root shell to use "zsh" instead of "csh."
chsh -s /usr/local/bin/zsh root

# Configure btop.
mkdir -p /home/$USER/.config/btop/themes
cd && git clone https://github.com/catppuccin/btop.git
cd btop/themes && cp -v *.theme /home/$USER/.config/btop/themes/
chown -R $USER:$USER /home/$USER/.config/btop/themes
cd && rm -rf btop
mkdir -p /home/$USER/.config/btop && cp -v /home/$USER/freebsd-stuff/Dotfiles/config/btop/btop.conf /home/$USER/.config/btop/btop.conf
chown -R $USER:$USER /home/$USER/.config/btop
mkdir -p /usr/share/skel/dot.config/btop
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/btop/btop.conf /usr/share/skel/dot.config/btop/btop.conf
mkdir -p /root/.config/btop
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/btop/btop.conf /root/.config/btop/btop.conf

# Configure bat, a nicer and prettier cat clone.
##
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
sed -i '' 's/#--theme="TwoDark"/--theme="'"$selected_theme"'"'/g $HOME/.config/bat/config
sed -i '' 's/#--italic-text=always/--italic-text=always'/g $HOME/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> $HOME/.config/bat/config
echo '--map-syntax "config:INI"' >> $HOME/.config/bat/config

# Copy the user configuration to /usr/share/skel so new users get the same setup.
mkdir -p /usr/share/skel/dot.config/bat
cp -v $HOME/.config/bat/config /usr/share/skel/dot.config/bat

# Copy root's configuration to the user's configuration.
mkdir -p /home/$USER/.config/bat
cp -v $HOME/.config/bat/config /home/$USER/.config/bat/config

# Setup the Catppuccin theme for bat.
cd $HOME
git clone https://github.com/catppuccin/bat.git
cd bat
sh -c 'mkdir -p $(bat --config-dir)/themes; cp *.tmTheme $(bat --config-dir)/themes; bat cache --build'

# Copy themes to /etc/skel.
sh -c 'mkdir -p /usr/share/skel/dot.config/bat/themes; cp *.tmTheme /usr/share/skel/dot.config/bat/themes'

# Modify the configuration settings for the user.
sed -i -E 's/#--theme="TwoDark"/--theme="'"$selected_theme"'"'/g "/home/$USER/.config/bat/config"
sed -i -E 's/#--italic-text=always/--italic-text=always'/g "/home/$USER/.config/bat/config"
echo '--map-syntax "*.conf:INI"' >> /home/$USER/.config/bat/config
echo '--map-syntax "config:INI"' >> /home/$USER/.config/bat/config
chown -R $USER:$USER /home/$USER/.config/bat

# Copy themes to user's home directory.
sh -c 'mkdir -p /home/$USER/.config/bat/themes; cp *.tmTheme /home/$USER/.config/bat/themes; sudo -u $USER bat cache --build'
chown -R $USER:$USER /home/$USER/.config/bat/themes

echo "Bat syntax highlighter has been configured with the selected theme ($selected_theme) for both your user and root."
rm -rf $HOME/bat
##
