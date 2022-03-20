#!/bin/sh

# Final setup stage.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

cd Dotfiles/

# Copy over .profile & fix system profile file.
cp -v .profile /home/$USER
chown $USER:$USER /home/$USER/.profile
cp -v .profile /usr/share/skel/dot.profile
echo "EDITOR=micro;    export EDITOR" >> /etc/profile
echo "PAGER=less;   export PAGER" >> /etc/profile
echo "MANPAGER=less;    export MANPAGER" >> /etc/profile
echo 'QT_QPA_PLATFORMTHEME="qt5ct";   export QT_QPA_PLATFORMTHEME' >> /etc/profile

# Copy over zsh config.
cp -v .zshrc /home/$USER
chown $USER:$USER /home/$USER/.zshrc
cp -v .zshrc /usr/share/skel/dot.zshrc

# Copy over neofetch config.
mkdir -p /home/$USER/.config/neofetch
cp -v config/neofetch/config.conf /home/$USER/.config/neofetch/
chown $USER:$USER /home/$USER/.config/neofetch
chown $USER:$USER /home/$USER/.config/neofetch/*
mkdir -p /usr/share/skel/dot.config/neofetch
cp -v config/neofetch/config.conf /usr/share/skel/dot.config/neofetch/

# Copy over micro config.
mkdir -p /home/$USER/.config/micro
cp -v config/micro/settings.json /home/$USER/.config/micro/
chown $USER:$USER /home/$USER/.config/micro
chown $USER:$USER /home/$USER/.config/micro/*
mkdir -p /usr/share/skel/dot.config/micro
cp -v config/micro/settings.json /usr/share/skel/dot.config/micro/

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

# Get "zsh-autosuggestions" and "zsh-syntax-highlighting" Oh My Zsh plugins.
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/ohmyzsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/ohmyzsh/custom/plugins/zsh-syntax-highlighting
