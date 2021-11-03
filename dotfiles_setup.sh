#!/bin/sh
# Final setup stage. Run as non-root user!
cd Dotfiles/
# Copy over .profile & fix system profile file.
cp -v .profile ~
sudo cp -v .profile /usr/share/skel/dot.profile
sudo echo "EDITOR=micro;    export EDITOR" >> /etc/profile
sudo echo "PAGER=less;   export PAGER" >> /etc/profile
sudo echo "MANPAGER=less;    export MANPAGER" >> /etc/profile
sudo echo 'QT_QPA_PLATFORMTHEME="qt5ct";   export QT_QPA_PLATFORMTHEME' >> /etc/profile

# Copy over zsh config.
cp -v .zshrc ~
sudo cp -v .zshrc /usr/share/skel/dot.zshrc

# Copy over neofetch config.
mkdir -p ~/.config/neofetch
cp -v config/neofetch/config.conf ~/.config/neofetch/
mkdir -p /usr/share/skel/dot.config/neofetch
cp -v config/neofetch/config.conf /usr/share/skel/dot.config/neofetch/

# Copy over micro config.
mkdir -p ~/.config/micro
cp -v config/micro/settings.json ~/.config/micro/
mkdir -p /usr/share/skel/dot.config/micro
cp -v config/micro/settings.json /usr/share/skel/dot.config/micro/

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
