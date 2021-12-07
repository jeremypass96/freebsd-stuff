#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg, WindowMaker, some useful software for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF >/usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { url: "http://pkg0.nyi.freebsd.org/${ABI}/latest" }
EOF
pkg update

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji cups papersize-default-letter hplip windowmaker wmakerconf wmcpuload wmmemload wmupmon wmsmixer wmclock wmnd thunar thunar-archive-plugin xarchiver thunar-media-tags-plugin xfce4-terminal xfce4-screensaver xfburn parole firefox thunderbird audacity handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell webfonts virtualbox-ose micro xclip zsh ohmyzsh neofetch slim slim-freebsd-dark-theme mp4v2 classiclooks i386-wine wine-mono wine-gecko numlockx devcpu-data automount unix2dos smartmontools
./rcconf_setup.sh
fi

if [ $answer = "ports" ] ; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/#REFUSE arabic chinese french german hebrew hungarian japanese/REFUSE arabic chinese french german hebrew hungarian japanese/g /etc/portsnap.conf
sed -i '' s/#REFUSE korean polish portuguese russian ukrainian vietnamese/REFUSE korean polish portuguese russian ukrainian vietnamese/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

# Install Ports.
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11-wm/windowmaker && make install clean
cd /usr/ports/x11-wm/wmakerconf && make install clean
cd /usr/ports/sysutils/wmcpuload && make install clean
cd /usr/ports/sysutils/wmmemload && make install clean
cd /usr/ports/sysutils/wmupmon && make install clean
cd /usr/ports/audio/wmsmixer && make install clean
cd /usr/ports/x11-clocks/wmclock && make install clean
cd /usr/ports/net/wmnd && make install clean
cd /usr/ports/x11-fm/thunar && make install clean
cd /usr/ports/archivers/thunar-archive-plugin && make install clean
cd /usr/ports/archivers/xarchiver && make install clean
cd /usr/ports/audio/thunar-media-tags-plugin && make install clean
cd /usr/ports/x11/xfce4-terminal && make install clean
cd /usr/ports/x11/xfce4-screensaver && make install clean
cd /usr/ports/sysutils/xfburn && make install clean
cd /usr/ports/multimedia/parole && make install clean
cd /usr/ports/www/firefox && make install clean
cd /usr/ports/mail/thunderbird && make install clean
cd /usr/ports/audio/audacity && make install clean
cd /usr/ports/multimedia/handbrake && make install clean
cd /usr/ports/sysutils/isomaster && make install clean
cd /usr/ports/editors/abiword && make install clean
cd /usr/ports/math/gnumeric && make install clean
cd /usr/ports/net-p2p/transmission-gtk && make install clean
cd /usr/ports/audio/asunder && make install clean
cd /usr/ports/graphics/gimp && make install clean
cd /usr/ports/graphics/inkscape && make install clean
cd /usr/ports/graphics/pinta && make install clean
cd /usr/ports/graphics/shotwell && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/papersize-default-letter && make install clean
cd /usr/ports/print/hplip && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/slim && make install clean
cd /usr/ports/x11/slim-freebsd-dark-theme && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11-themes/classiclooks && make install clean
cd /usr/ports/emulators/i386-wine && make install clean
cd /usr/ports/emulators/wine-gecko && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean

# Setup rc.conf file.
./rcconf_setup_ports.sh
fi

# Setup system files for desktop use.
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh

# Configure S.M.A.R.T. disk monitoring daemon.
cp /usr/local/etc/smartd.conf.sample /usr/local/etc/smartd.conf
echo "/dev/ada0 -H -l error -f" >> /usr/local/etc/smartd.conf

# Setup automoumt.
cat << EOF >/usr/local/etc/automount.conf
USERUMOUNT=YES
REMOVEDIRS=YES
ATIME=NO
EOF

# Setup NineIcons (icon theme)
git clone https://github.com/grassmunk/Platinum9.git ~
cd ~/Platinum9 && cp -rv NineIcons /usr/local/share/icons/
cd && rm -rf Platinum9

# Setup Xfce4 Terminal colors.
mkdir -p ~/.config/xfce4/terminal/colorschemes
cd ~/.config/xfce4/terminal/colorschemes
fetch https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/xfce4terminal/colorschemes/Andromeda.theme -o Andromeda.theme && cd
cat << EOF >~/.config/xfce4/terminal/terminalrc
[Configuration]
ColorForeground=#e5e5e5
ColorBackground=#262a33
ColorCursor=#f8f8f0
ColorPalette=#000000;#cd3131;#05bc79;#e5e512;#2472c8;#bc3fbc;#0fa8cd;#e5e5e5;#666666;#cd3131;#05bc79;#e5e512;#2472c8;#bc3fbc;#0fa8cd;#e5e5e5
MiscAlwaysShowTabs=FALSE
MiscBell=TRUE
MiscBellUrgent=TRUE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=155x42
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=TRUE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=TRUE
MiscSearchDialogOpacity=100
MiscShowUnsafePasteDialog=TRUE
FontUseSystem=TRUE
ShortcutsNoMenukey=TRUE
EOF

# Setup SLiM.
sed -i '' s/#^numlock/numlock/g /usr/local/etc/slim.conf
sed -i '' s/#default_user^simone/default_user^$USER/g /usr/local/etc/slim.conf
sed -i '' s/#focus_password^no/focus_password^yes/g /usr/local/etc/slim.conf
sed -i '' s/#auto_login^no/auto_login^yes/g /usr/local/etc/slim.conf
sed -i '' s/current_theme^default/current_theme^slim-freebsd-dark-theme/g /usr/local/etc/slim.conf

# Add SLiM to rc.conf.
service slim enable

# Disable unneeded TTYs and secure the rest. This will make you enter root's password when booting into single user mode, but you can't login as root while booted into normal mode.
sed -i '' s/ttyu0/#ttyu0/g /etc/ttys
sed -i '' s/ttyu1/#ttyu1/g /etc/ttys
sed -i '' s/ttyu2/#ttyu2/g /etc/ttys
sed -i '' s/ttyu3/#ttyu3/g /etc/ttys
sed -i '' s/dcons/#dcons/g /etc/ttys
sed -i 'ttyv*' s/secure/insecure/g /etc/ttys

# Update FreeBSD base.
freebsd-update fetch install

# Reboot
shutdown -r now
