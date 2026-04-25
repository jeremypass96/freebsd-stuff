#!/bin/sh
set -e
# Final setup stage.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
	echo "Please run this setup script as root via 'su'! Thanks."
	exit
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

cd Dotfiles/ || exit

# Export options to system and user profile files.
for profile in /etc/profile /home/$logged_in_user/.profile /usr/share/skel/dot.profile; do
	sed -i '' 's/EDITOR=vim/EDITOR=hx/g' "$profile"
	echo "" >>"$profile"
	echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >>"$profile"
done

# Copy over zsh config.
cp -v .zshrc /home/"$logged_in_user"
cp -v .zshrc /usr/share/skel/dot.zshrc
chmod go+r /usr/share/skel/dot.zshrc
cp -v /usr/share/skel/dot.zshrc /root/.zshrc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.zshrc

# Copy over fastfetch config.
mkdir -p /home/"$logged_in_user"/.config/fastfetch
cp -v config/fastfetch/config.jsonc /home/"$logged_in_user"/.config/fastfetch
mkdir -p /root/.config/fastfetch
cp -v config/fastfetch/config.jsonc /root/.config/fastfetch
mkdir -p /usr/share/skel/dot.config/fastfetch
chmod 755 /usr/share/skel/dot.config/fastfetch
cp -v config/fastfetch/config.jsonc /usr/share/skel/dot.config/fastfetch
chmod go+r /usr/share/skel/dot.config/fastfetch
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/fastfetch

cd /home/"$logged_in_user"/freebsd-stuff || exit

# Change shell to zsh.
chsh -s /usr/local/bin/zsh "$logged_in_user"

# Get "zsh-autosuggestions" Oh My Zsh plugin and "zsh-fast-syntax-highlighting" Zsh plugin.
ZSH_CUSTOM=/usr/local/share/ohmyzsh/custom
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
chmod 755 ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
chmod 755 ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
chmod 755 ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
unset ZSH_CUSTOM

read -rp "Installing Zsh syntax highlighting plugin... do you want the FreeBSD binary packge or the ports tree port? (pkg/port) " zsh_resp
if [ "$zsh_resp" = pkg ]; then
	pkg install -y zsh-fast-syntax-highlighting
elif [ "$zsh_resp" = port ]; then
	cd /usr/ports/shells/zsh-fast-syntax-highlighting && make install clean
fi
chmod 755 /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >>/home/"$logged_in_user"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >>"$HOME"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >>/usr/share/skel/dot.zshrc

cd /home/"$logged_in_user"/freebsd-stuff || exit

# Copy over lsd config.
mkdir -p /home/"$logged_in_user"/.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /home/"$logged_in_user"/.config/lsd
mkdir -p /root/.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
chmod 755 /usr/share/skel/dot.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chmod go+r /usr/share/skel/dot.config/lsd
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/lsd

# Copy over custom Oh My Zsh theme.
cp -v /home/"$logged_in_user"/freebsd-stuff/jpassarelli.zsh-theme /usr/local/share/ohmyzsh/custom/themes
chmod go+r /usr/local/share/ohmyzsh/custom/themes/jpassarelli.zsh-theme

# Change root shell to use "zsh" instead of "csh."
chsh -s /usr/local/bin/zsh root

# Configure bat, a nicer and prettier cat clone.

# Generate initial configuration file for bat (this script is running as root, remember?)
bat --generate-config-file

# Modify the configuration settings.
sed -i '' 's/#--theme="TwoDark"/--theme="1337"'/g /root/.config/bat/config
sed -i '' 's/#--italic-text=always/--italic-text=always'/g /root/.config/bat/config
echo '--map-syntax "*.conf:INI"' >>/root/.config/bat/config
echo '--map-syntax "config:INI"' >>/root/.config/bat/config

# Copy the user configuration to /usr/share/skel so new users get the same setup.
mkdir -p /usr/share/skel/dot.config/bat
cp -v /root/.config/bat/config /usr/share/skel/dot.config/bat
chmod go+r /usr/share/skel/dot.config/bat

# Copy root's configuration to the user's configuration.
mkdir -p /home/"$logged_in_user"/.config/bat
cp -v /root/.config/bat/config /home/"$logged_in_user"/.config/bat/config
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/bat/config

echo "Bat syntax highlighter has been configured with the '1337' theme for both your user and root."

# Configure Helix text editor.
mkdir -p /usr/share/skel/dot.config/helix
chmood 755 /usr/share/skel/dot.config/helix
cp -rv /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/helix/*.toml /usr/share/skel/dot.config/helix
chmod go+r /usr/share/skel/dot.config/helix/*.toml
mkdir -p /root/.config/helix
cp -rv /usr/share/skel/dot.config/helix/*.toml /root/.config/helix
mkdir /home/"$logged_in_user"/.config/helix
cp -rv /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/helix/*.toml /home/"$logged_in_user"/.config/helix
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/helix

# Configure Alacritty.
mkdir -p /usr/share/skel/dot.config/alacritty
chmod 755 /usr/share/skel/dot.config/alacritty
cp -rv /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/alacritty/alacritty.toml /usr/share/skel/dot.config/alacritty
chmod go+r /usr/share/skel/dot.config/alacritty
mkdir -p /root/.config/alacritty
cp -rv /usr/share/skel/dot.config/alacritty/alacritty.toml /root/.config/alacritty
mkdir /home/"$logged_in_user"/.config/alacritty
cp -rv /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/alacritty/alacritty.toml /home/"$logged_in_user"/.config/alacritty
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/alacritty
