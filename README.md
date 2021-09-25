# FreeBSD Stuff
You'll need to install sudo, git, portmaster (for installing ports), devcpu-data (for CPU microcode updates), and the bash shell, if not already installed, for these scripts to work.

To install via binary packages: <code>pkg install sudo git-lite bash bash-completion micro zsh ohmyzsh neofetch devcpu-data</code>

To install via ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git shells/bash shells/bash-completion editors/micro shells/zsh shells/ohmyzsh sysutils/neofetch sysutils/devcpu-data</code>

<b>IMPORTANT!</b> To use the .zshrc file correctly with zsh, you <b>MUST</b> have these 3 plugins installed!

<code>git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions</code>

<code>git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting</code>
