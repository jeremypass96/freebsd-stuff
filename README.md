# FreeBSD Stuff
You'll need to install sudo, git, and the bash shell, if not already installed, for these scripts to work. Most is for colored man pages output.

Binary packages:
<code>pkg install sudo git bash bash-completion most micro zsh ohmyzsh neofetch</code>

From Ports (copy make.conf to /etc first):

**Synth**: <code>cd /usr/ports/ports-mgmt/synth/ && make install clean</code>

**Sudo**: <code>cd /usr/ports/security/sudo/ && make install clean</code>

**Bash**: <code>cd /usr/ports/shells/bash/ && make install clean</code>

**Bash Completion**: <code>cd /usr/ports/shells/bash-completion/ && make install clean</code>

**Git**: <code>cd /usr/ports/devel/git/ && make install clean</code>

**Most**: <code>cd /usr/ports/sysutils/most/ && make install clean</code>

**Micro**: <code>cd /usr/ports/editors/micro/ && make install clean</code>

**Zsh**: <code>cd /usr/ports/shells/zsh/ && make install clean</code>

**Oh-My-Zsh**: <code>cd /usr/ports/shells/ohmyzsh/ && make install clean</code>

**Neofetch**: <code>cd /usr/ports/sysutils/neofetch/ && make install clean</code>
