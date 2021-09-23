# FreeBSD Stuff
You'll need to install sudo, git, portmaster (for installing ports), and the bash shell, if not already installed, for these scripts to work. Most is for colored man pages output.

To install via binary packages: <code>pkg install sudo git-lite bash bash-completion micro zsh ohmyzsh neofetch</code>

To install via ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git shells/bash shells/bash-completion editors/micro shells/zsh shells/ohmyzsh sysutils/neofetch</code>

IMPORTANT! To use the .zshrc file correctly with ZSH, you MUST have these two plugins installed!

<code>git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions</code>
<code>git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting</code>
