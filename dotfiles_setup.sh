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
    sed -i '' 's/EDITOR=vi/EDITOR=vim/g' "$profile"
    echo "" >> "$profile"
    echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> "$profile"
    echo 'PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO' >> "$profile"
done

# Copy over zsh config.
cp -v .zshrc /home/"$logged_in_user"
cp -v .zshrc /usr/share/skel/dot.zshrc
cp -v /usr/share/skel/dot.zshrc /root/.zshrc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.zshrc

# Copy over fastfetch config.
mkdir -p /home/"$logged_in_user"/.config/fastfetch
cp -v config/fastfetch/config.jsonc /home/"$logged_in_user"/.config/fastfetch
mkdir -p /root/.config/fastfetch
cp -v config/fastfetch/config.jsonc /root/.config/fastfetch
mkdir -p /usr/share/skel/dot.config/fastfetch
cp -v config/fastfetch/config.jsonc /usr/share/skel/dot.config/fastfetch
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
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> /home/"$logged_in_user"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> "$HOME"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> /usr/share/skel/dot.zshrc

cd /home/"$logged_in_user"/freebsd-stuff || exit

# Copy over lsd config.
mkdir -p /home/"$logged_in_user"/.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /home/"$logged_in_user"/.config/lsd
mkdir -p /root/.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/lsd

# Copy over custom Oh My Zsh theme.
cp -v /home/"$logged_in_user"/freebsd-stuff/jpassarelli.zsh-theme /usr/local/share/ohmyzsh/custom/themes
chmod og+r /usr/local/share/ohmyzsh/custom/themes/jpassarelli.zsh-theme

# Change root shell to use "zsh" instead of "csh."
chsh -s /usr/local/bin/zsh root

# Configure bat, a nicer and prettier cat clone.

# Generate initial configuration file for bat (this script is running as root, remember?)
bat --generate-config-file

# Modify the configuration settings.
sed -i '' 's/#--theme="TwoDark"/--theme="1337"'/g /root/.config/bat/config
sed -i '' 's/#--italic-text=always/--italic-text=always'/g /root/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> /root/.config/bat/config
echo '--map-syntax "config:INI"' >> /root/.config/bat/config

# Copy the user configuration to /usr/share/skel so new users get the same setup.
mkdir -p /usr/share/skel/dot.config/bat
cp -v /root/.config/bat/config /usr/share/skel/dot.config/bat

# Copy root's configuration to the user's configuration.
mkdir -p /home/"$logged_in_user"/.config/bat
cp -v /root/.config/bat/config /home/"$logged_in_user"/.config/bat/config
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/bat/config

echo "Bat syntax highlighter has been configured with the '1337' theme for both your user and root."

# Vim setup.
# Install vim-plug.
curl -fLo /home/"$logged_in_user"/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p /usr/share/skel/dot.vim/autoload
cp -v /home/"$logged_in_user"/.vim/autoload/plug.vim /usr/share/skel/dot.vim/autoload/plug.vim
mkdir -p "$HOME"/.vim/autoload
cp -v /usr/share/skel/dot.vim/autoload/plug.vim "$HOME"/.vim/autoload/plug.vim

# Configure the vimrc file.
vimrc_path=/home/"$logged_in_user"/.vim/vimrc
root_vimrc="$HOME"/.vim/vimrc
tee "$vimrc_path" > /dev/null << EOF
set number
set cursorline
set linebreak
set incsearch
set hlsearch
set spell
set smoothscroll
set termguicolors

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'jiangmiao/auto-pairs'
call plug#end()

let g:lightline = {'colorscheme': 'ayu_mirage'}
let g:one_allow_italics = 1
let ayucolor="mirage"
colorscheme ayu
set laststatus=2
set noshowmode
set guifont=JetBrainsMonoNL\ NFM:h12:cDEFAULT
set backspace=indent,eol,start
EOF

# Configure Vim for standard user.
vim -es -u "$vimrc_path" -i NONE -c "PlugInstall" -c "qa"
cp -r /home/"$logged_in_user"/.vim/plugged /usr/share/skel/dot.vim/plugged

# Copy vimrc to root's home directory.
mkdir -p "$HOME"/.vim
cp -rv /home/"$logged_in_user"/.vim/vimrc "$HOME"/.vim/vimrc

# Configure Vim for root.
vim -es -u "$root_vimrc" -i NONE -c "PlugInstall" -c "qa"

# Copy vimrc to /usr/share/skel directory.
cp -rv /home/"$logged_in_user"/.vim/vimrc /usr/share/skel/dot.vim/

# Fix vim folder permissions.
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.vim