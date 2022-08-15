# FreeBSD Setup Scripts
You'll need to install git for these scripts to work. The main setup script will ask you what desktop environment you want to install, installs fonts, configures FreeBSD for desktop use, fixes font rendering, updates the FreeBSD base system, and sets up automounting.

Binary package: <code>pkg install git-lite</code>

Port:
<code>cd /usr/ports/devel/git && make install clean</code>

For a minimal "git-lite" build, deselect the following configuration options:
<code>CONTRIB</code>
<code>GITWEB</code>
<code>PERL</code>
<code>SEND_EMAIL</code>
