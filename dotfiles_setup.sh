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
    sed -i '' 's/EDITOR=vi/EDITOR=micro/g' "$profile"
    echo "" >> "$profile"
    echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> "$profile"
    echo 'PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO' >> "$profile"
    echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> "$profile"
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

cp -v "$chosen_scheme" /home/$USER/.config/micro/colorschemes
chown -R $USER:$USER /home/$USER/.config/micro/colorschemes
cp -v "$chosen_scheme" /usr/share/skel/dot.config/micro/colorschemes
cp -v "$chosen_scheme" /root/.config/micro/colorschemes

cd && rm -rf micro

cd /home/$USER/freebsd-stuff

# Change shell to zsh.
chsh -s /usr/local/bin/zsh $USER

# Get "zsh-autosuggestions" and "zsh-syntax-highlighting" Oh My Zsh plugins.
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/ohmyzsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/ohmyzsh/custom/plugins/zsh-syntax-highlighting

# Copy over lsd config.
mkdir -p /home/$USER/.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /home/$USER/.config/lsd
mkdir -p /root/.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
cp -v /home/$USER/freebsd-stuff/Dotfiles/config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chown -R $USER:$USER /home/$USER/.config/lsd

# Configure "bat," nicer (and better) cat alternative.
./bat_setup.sh

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
