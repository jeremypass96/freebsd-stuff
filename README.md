# FreeBSD Setup Scripts
You'll need to install sudo and git for these scripts to work. The bootloader setup script automatically sets up CPU microcode updates for you (both the ports version and the pkg version). The main setup script will ask you if you want to install binary packages or compile software from the Ports tree.

The git package is required to download these scripts.

Binary package: <code>pkg install git-lite</code>

Port:
<code>cd /usr/ports/devel/git && make install clean</code>
