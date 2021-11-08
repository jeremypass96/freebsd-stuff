# FreeBSD Setup Scripts
You'll need to install sudo, git, portmaster (for installing ports), and devcpu-data (for CPU microcode updates) for these scripts to work. The bootloader setup script automatically sets up CPU microcode updates for you (both the ports version and the pkg version). The main setup script will install portmaster (if you decided to tell the setup script to compile software from the Ports tree), micro, zsh, ohmyzsh, and neofetch for you. It will also ask you if you want to install binary packages or compile software from the Ports tree.

Dependencies required to download these scripts:

Binary packages: <code>pkg install -y sudo git-lite</code>

Ports:
<code>cd /usr/ports/ports-mgmt/portmaster && make install clean</code>

<code>portmaster security/sudo devel/git</code>
