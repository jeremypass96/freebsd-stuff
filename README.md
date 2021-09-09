# FreeBSD Stuff
You'll need to install sudo, git, portmaster (for installing ports), and the bash shell, if not already installed, for these scripts to work. Most is for colored man pages output.

To install via binary packages: <code>pkg install sudo git-lite bash bash-completion most micro zsh ohmyzsh neofetch</code>

To install via ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git shells/bash shells/bash-completion sysutils/most editors/micro shells/zsh shells/ohmyzsh sysutils/neofetch</code>
