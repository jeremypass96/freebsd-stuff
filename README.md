# FreeBSD Setup Scripts
You'll need to install sudo, git, portmaster (for installing ports), and devcpu-data (for CPU microcode updates) for these scripts to work. The bootloader setup script automatically sets up CPU microcode updates for you (both the ports version and the pkg version).

To install via binary packages: <code>pkg install sudo git-lite micro zsh ohmyzsh neofetch</code>

To install via ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git editors/micro shells/zsh shells/ohmyzsh sysutils/neofetch</code>

<b>IMPORTANT!</b> To use the .zshrc file correctly with zsh, you <b>MUST</b> have these 2 plugins installed!

<code>git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions</code>

<code>git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting</code>
