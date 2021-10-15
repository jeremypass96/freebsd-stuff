#!/bin/sh
cd Dotfiles/

# Copy over .profile & fix system profile file.
cp -v .profile ~/
sudo cp -v .profile /usr/share/skel/dot.profile
sudo echo "EDITOR=micro;    export EDITOR" >> /etc/profile
sudo echo "PAGER=less;   export PAGER" >> /etc/profile
sudo echo "MANPAGER=less;    export MANPAGER" >> /etc/profile
sudo echo "QT_QPA_PLATFORMTHEME=qt5ct;   export QT_QPA_PLATFORMTHEME" >> /etc/profile

# Copy over zsh config
cp -v .zshrc ~/
sudo cp -v .zshrc /usr/share/skel/dot.zshrc

# Copy over neofetch config
mkdir -p ~/.config/neofetch
cp config/neofetch/neofetch.conf ~/.config/neofetch/

# Change shell to zsh
chsh -s /usr/local/bin/zsh $USER
