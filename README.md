# FreeBSD Setup Scripts
You'll need to install sudo, git, portmaster (for installing ports), and devcpu-data (for CPU microcode updates) for these scripts to work. The bootloader setup script automatically sets up CPU microcode updates for you (both the ports version and the pkg version). The main setup script will install portmaster (if you decided to tell the setup script to compile software from the Ports tree), micro, zsh, ohmyzsh, and neofetch for you. It will also ask you if you want to install binary packages or compile software from the Ports tree.

The git package is required to download these scripts.

Binary package: <code>pkg install git-lite</code>

Port:
<code>cd /usr/ports/devel/git && make install clean</code>
