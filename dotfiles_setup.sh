#!/bin/sh

# Final setup stage.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

cd Dotfiles/

# Export options to system and user profile files.
sed -i '' s/EDITOR=vi/EDITOR=micro/g /etc/profile
echo "" >> /etc/profile
echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> /etc/profile
echo "PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO" >> /etc/profile
echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> /etc/profile

sed -i '' s/EDITOR=vi/EDITOR=micro/g /home/$USER/.profile
echo "" >> /home/$USER/.profile
echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> /home/$USER/.profile
echo "PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO" >> /home/$USER/.profile
echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> /home/$USER/.profile

sed -i '' s/EDITOR=vi/EDITOR=micro/g /usr/share/skel/dot.profile
echo "" >> /usr/share/skel/dot.profile
echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> /usr/share/skel/dot.profile
echo "PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO" >> /usr/share/skel/dot.profile
echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> /usr/share/skel/dot.profile

# Copy over zsh config.
cp -v .zshrc /home/$USER
cp -v .zshrc /usr/share/skel/
sed -i '' s/neofetch/\/g /usr/share/skel/dot.zshrc
cp -v /usr/share/skel/dot.zshrc /root/
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

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

# Get "zsh-autosuggestions" and "zsh-syntax-highlighting" Oh My Zsh plugins.
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/ohmyzsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/ohmyzsh/custom/plugins/zsh-syntax-highlighting

# Copy over lsd config.
mkdir -p /home/$USER/.config/lsd
cp -v config/lsd/config.yaml /home/$USER/.config/lsd
mkdir -p /root/.config/lsd
cp -v config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
cp -v config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chown -R $USER:$USER /home/$USER/.config/lsd

# Configure "bat," nicer (and better) cat alternative.
bat --generate-config-file
sed -i '' s/#--theme='"TwoDark"'/--theme='"1337"'/g /root/.config/bat/config
sed -i '' s/#--italic-text=always/--italic-text=always/g /root/.config/bat/config
mkdir -p /home/$USER/.config/bat
cp -v /root/.config/bat/config /home/$USER/.config/bat
mkdir -p /usr/share/skel/dot.config/bat
cp -v /root/.config/bat/config /usr/share/skel/dot.config/bat
chown -R $USER:$USER /home/$USER/.config/bat

# Change root shell to use "zsh" instead of "csh."
chsh -s /usr/local/bin/zsh root

# Install Catppuccin theme for micro.
mkdir -p /home/$USER/.config/micro/colorschemes
mkdir -p /usr/share/skel/dot.config/micro/colorschemes
mkdir -p /root/.config/micro/colorschemes
cd && git clone https://github.com/catppuccin/micro.git
cd micro/src
cp -v catppuccin-mocha.micro /home/$USER/.config/micro/colorschemes
chown -R $USER:$USER /home/$USER/.config/micro/colorschemes
cp -v catppuccin-mocha.micro /usr/share/skel/dot.config/micro/colorschemes
cp -v catppuccin-mocha.micro /root/.config/micro/colorschemes
cd && rm -rf micro

# Configure btop.
mkdir -p /home/$USER/.config/btop/themes
cd && git clone https://github.com/catppuccin/btop.git
cd btop/themes && cp -v *.theme /home/$USER/.config/btop/themes/
chown -R $USER:$USER /home/$USER/.config/btop/themes
cd && rm -rf btop
mkdir -p /home/$USER/.config/btop && cp -v /home/$USER/linux-stuff/Dotfiles/config/btop/btop.conf /home/$USER/.config/btop/btop.conf
chown -R $USER:$USER /home/$USER/.config/btop
mkdir -p /usr/share/skel/dot.config/btop
cp -v /home/$USER/linux-stuff/Dotfiles/config/btop/btop.conf /usr/share/skel/dot.config/btop/btop.conf
mkdir -p /root/.config/btop
cp -v /home/$USER/linux-stuff/Dotfiles/config/btop/btop.conf /root/.config/btop/btop.conf
