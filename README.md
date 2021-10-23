# FreeBSD Setup Scripts
You'll need to install sudo, git, portmaster (for installing ports), and devcpu-data (for CPU microcode updates) for these scripts to work. The bootloader setup script automatically sets up CPU microcode updates for you (both the ports version and the pkg version). The main setup script will install portmaster, micro, zsh, ohmyzsh, and neofetch for you.

To install via binary packages: <code>pkg install sudo git-lite</code>

To install via ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git</code>
