#!/bin/sh

# Final setup stage.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this setup script as root via 'su'! Thanks."
    exit
fi

cd Dotfiles/ || exit

# Export options to system and user profile files.
for profile in /etc/profile /home/$USER/.profile /usr/share/skel/dot.profile; do
    sed -i '' 's/EDITOR=vi/EDITOR=micro/g' "$profile"
    echo "" >> "$profile"
    echo "QT_QPA_PLATFORMTHEME=qt5ct;  export QT_QPA_PLATFORMTHEME" >> "$profile"
    echo 'PF_INFO="ascii os kernel uptime pkgs shell editor de";  export PF_INFO' >> "$profile"
    echo "MICRO_TRUECOLOR=1;  export MICRO_TRUECOLOR" >> "$profile"
done

# Copy over zsh config.
cp -v .zshrc /home/"$USER"
cp -v .zshrc /usr/share/skel/dot.zshrc
cp -v /usr/share/skel/dot.zshrc /root/.zshrc
chown "$USER":"$USER" /home/"$USER"/.zshrc

# Copy over fastfetch config.
mkdir -p /home/"$USER"/.config/fastfetch
cp -v config/fastfetch/config.jsonc /home/"$USER"/.config/fastfetch
mkdir -p /root/.config/fastfetch
cp -v config/fastfetch/config.jsonc /root/.config/fastfetch
mkdir -p /usr/share/skel/dot.config/fastfetch
cp -v config/fastfetch/config.jsonc /usr/share/skel/dot.config/fastfetch
chown -R "$USER":"$USER" /home/"$USER"/.config/fastfetch

# Copy over micro config.
mkdir -p /home/"$USER"/.config/micro
cp -v config/micro/settings.json /home/"$USER"/.config/micro
mkdir -p /root/.config/micro
cp -v config/micro/settings.json /root/.config/micro
mkdir -p /usr/share/skel/dot.config/micro
cp -v config/micro/settings.json /usr/share/skel/dot.config/micro
chown -R "$USER":"$USER" /home/"$USER"/.config/micro

cd /home/"$USER"/freebsd-stuff || exit

# Change shell to zsh.
chsh -s /usr/local/bin/zsh "$USER"

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
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> /home/"$USER"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> "$HOME"/.zshrc
echo "source /usr/local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> /usr/share/skel/dot.zshrc

cd /home/"$USER"/freebsd-stuff || exit

# Copy over lsd config.
mkdir -p /home/"$USER"/.config/lsd
cp -v /home/"$USER"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /home/"$USER"/.config/lsd
mkdir -p /root/.config/lsd
cp -v /home/"$USER"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /root/.config/lsd
mkdir -p /usr/share/skel/dot.config/lsd
cp -v /home/"$USER"/freebsd-stuff/Dotfiles/config/lsd/config.yaml /usr/share/skel/dot.config/lsd
chown -R "$USER":"$USER" /home/"$USER"/.config/lsd

# Copy over custom Oh My Zsh theme.
cp -v /home/"$USER"/freebsd-stuff/jpassarelli.zsh-theme /usr/local/share/ohmyzsh/custom/themes
chmod og+r /usr/local/share/ohmyzsh/custom/themes/jpassarelli.zsh-theme

# Change root shell to use "zsh" instead of "csh."
chsh -s /usr/local/bin/zsh root

# Configure bat, a nicer and prettier cat clone.

# Generate initial configuration file for bat (this script is running as root, remember?)
bat --generate-config-file
chown "$USER":"$USER" /home/"$USER"/.config/bat/config

# Modify the configuration settings.
sed -i '' 's/#--theme="TwoDark"/--theme="1337"'/g /home/"$USER"/.config/bat/config
sed -i '' 's/#--italic-text=always/--italic-text=always'/g /home/"$USER"/.config/bat/config
echo '--map-syntax "*.conf:INI"' >> /home/"$USER"/.config/bat/config
echo '--map-syntax "config:INI"' >> /home/"$USER"/.config/bat/config

# Copy the user configuration to /usr/share/skel so new users get the same setup.
mkdir -p /usr/share/skel/dot.config/bat
cp -v /home/"$USER"/.config/bat/config /usr/share/skel/dot.config/bat

# Copy user's configuration to the root user's configuration.
mkdir -p "$HOME"/.config/bat
cp -v /home/"$USER"/.config/bat/config "$HOME"/.config/bat/config

echo "Bat syntax highlighter has been configured with the '1337' theme for both your user and root."

# Vim setup.
# Install vim-plug.
curl -fLo /home/"$USER"/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p /usr/share/skel/dot.config/.vim/autoload
cp -v /home/"$USER"/.vim/autoload/plug.vim /usr/share/skel/dot.config/.vim/autoload/plug.vim

# Configure the vimrc file.
vimrc_path=/home/$USER/.vim/vimrc
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

# Configure vim.
vim -es -u "$vimrc_path" -i NONE -c "PlugInstall" -c "qa"
cp -r /home/"$USER"/.vim/plugged /usr/share/skel/dot.config/.vim/plugged

# Copy vimrc to /usr/share/skel directory.
cp -rv /home/"$USER"/.vim/vimrc /usr/share/skel/dot.config/.vim/

# Copy vimrc to root's home directory.
cp -rv /home/"$USER"/.vim/vimrc "$HOME"/.vim/vimrc

# Fix vim folder permissions.
chown -R "$USER":"$USER" /home/"$USER"/.vim