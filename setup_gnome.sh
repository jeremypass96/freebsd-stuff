#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD post-install setup script. This script will setup Xorg, GNOME, some useful software for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update

echo "Do you have a printer installed? (y/n)"
read answer
if [ $answer = "y" ] ; then
pkg install cups papersize-default-letter hplip
fi
if [ $answer = "n" ] ; then
continue
fi

# Add /proc filesystem to /etc/fstab.
echo "proc           /proc       procfs  rw  0   0" >> /etc/fstab

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji gnome3-lite gnome-utils gnome-initial-setup gnome-shell-extension-dashtopanel chrome-gnome-shell rhythmbox firefox thunderbird audacity handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell webfonts virtualbox-ose micro xclip zsh ohmyzsh neofetch mp4v2 pop-gtk-themes pop-icon-theme wine wine-mono wine-gecko numlockx devcpu-data automount unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs
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

echo "Do you have a printer installed? (y/n)"
read answer
if [ $answer = "y" ] ; then
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/papersize-default-letter && make install clean
cd /usr/ports/print/hplip && make install clean
fi
if [ $answer = "n" ] ; then
continue
fi

# Install Ports.
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/gnome3-lite && make install clean
cd /usr/ports/deskutils/gnome-utils && make install clean
cd /usr/ports/deskutils/gnome-initial-setup && make install clean
cd /usr/ports/deskutils/gnome-shell-extension-dashtopanel && make install clean
cd /usr/ports/www/chrome-gnome-shell && make install clean
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
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11-themes/pop-gtk-themes && make install clean
cd /usr/ports/x11-themes/pop-icon-theme && make install clean
cd /usr/ports/emulators/wine && make install clean
cd /usr/ports/emulators/wine-gecko && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && sudo make install clean
cd /usr/ports/x11-fonts/office-code-pro && sudo make install clean
cd /usr/ports/x11-fonts/webfonts && sudo make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && sudo make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && sudo make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && sudo make install clean
cd /usr/ports/devel/xdg-user-dirs && sudo make install clean

# Setup rc.conf file.
./rcconf_setup_ports.sh
fi

# Setup system files for desktop use.
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh
./freebsd_symlinks.sh
./dotfiles_setup.sh

# Configure S.M.A.R.T. disk monitoring daemon.
cp /usr/local/etc/smartd.conf.sample /usr/local/etc/smartd.conf
echo "/dev/ada0 -H -l error -f" >> /usr/local/etc/smartd.conf

# Setup automoumt.
cat << EOF >/usr/local/etc/automount.conf
USERUMOUNT=YES
REMOVEDIRS=YES
ATIME=NO
EOF

# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
cd /home/$USER/ && fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
echo 'Moving cursor theme directory to "/usr/local/share/icons"...'
cp -rv macOSBigSur /usr/local/share/icons/
echo "Setting proper file permissions..."
chown -R root:wheel /usr/local/share/icons/macOSBigSur/*
rm -rf macOSBigSur.tar.gz macOSBigSur

# Setup user's home directory with common folders.
xdg-user-dirs-update

# Setup GDM/GNOME.
sysrc gdm_enable="YES"
sysrc gnome_enable="YES"

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
