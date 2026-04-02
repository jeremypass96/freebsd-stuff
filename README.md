# FreeBSD Setup Scripts
You'll need to install git for these scripts to work. The main setup script will ask you what desktop environment you want to install, installs fonts, configures FreeBSD for desktop use, fixes font rendering, updates the FreeBSD base system, and sets up automounting.

Binary package: <code>pkg install git-lite</code>

Port:
<code>cd /usr/ports/devel/git && make install clean</code>

For a minimal "git-lite" package "flavor" build, deselect the following configuration options when compiling the FreeBSD port:
<code>CONTRIB</code>
<code>GITWEB</code>
<code>PERL</code>
<code>SEND_EMAIL</code>

These scripts use 'dialog' for dialog boxes, and for **some stupid idiotic reason**, the FreeBSD developers decided to remove dialog from the FreeBSD 15 base (why?). So, unfortunately, these scripts can only be used with FreeBSD *14.x* releases for now.
