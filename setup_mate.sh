#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD MATE setup script. This script will setup Xorg, MATE, some useful software for you, along with system files being tweaked for desktop use."
echo "Do you plan to install software via pkg (binary packages) or ports? (pkg/ports)"
read answer
if [ $answer = "pkg" ] ; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest", mirror_type: "srv", signature_type: "fingerprints", fingerprints: "/usr/share/keys/pkg", enabled: yes }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update -f

echo "Do you plan to use a printer? (y/n)"
read answer
if [ $answer = "y" ] ; then
pkg install cups papersize-default-letter hplip
sysrc cupsd_enable="YES"
sysrc saned_enable="YES"
fi
if [ $answer = "n" ] ; then
continue
fi

# Add /proc filesystem to /etc/fstab.
echo "proc           /proc        procfs    rw      0     0" >> /etc/fstab

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji mate xfburn parole firefox thunderbird audacity handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell webfonts virtualbox-ose micro xclip zsh ohmyzsh neofetch lightdm slick-greeter mp4v2 classiclooks wine wine-mono wine-gecko numlockx devcpu-data automount unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf

# Setup rc.conf file.
./rcconf_setup.sh

# Setup MATE themes. Will be ran as a normal user.
su - $USER
./freebsd_mate_theme_install.sh
exit
fi

if [ $answer = "ports" ] ; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/"#REFUSE arabic chinese french german hebrew hungarian japanese/REFUSE arabic chinese french german hebrew hungarian japanese"/g /etc/portsnap.conf
sed -i '' s/"#REFUSE korean polish portuguese russian ukrainian vietnamese/REFUSE korean polish portuguese russian ukrainian vietnamese"/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

echo "Do you have a printer? (y/n)"
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
cd /usr/ports/x11/mate && make install clean
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
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/emulators/virtualbox-ose && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11-themes/classiclooks && make install clean
cd /usr/ports/emulators/i386-wine && make install clean
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
cd /usr/ports/sysutils/duf && make install clean

# Setup rc.conf file.
./rcconf_setup_ports.sh

# Setup MATE themes. Will be ran as a normal user.
su - $USER
./freebsd_mate_theme_install_ports.sh
exit
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
cat << EOF > /usr/local/etc/automount.conf
USERUMOUNT=YES
REMOVEDIRS=YES
ATIME=NO
EOF

# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
cd /home/$USER/ && fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
echo 'Moving cursor theme directory to "/usr/local/share/icons"...'
mv macOSBigSur /usr/local/share/icons/
echo "Setting proper file permissions..."
chown -R root:wheel /usr/local/share/icons/macOSBigSur/*
rm -rf macOSBigSur.tar.gz
rm -rf macOSBigSur/

# Install icon theme.
echo "Installing the Newaita-reborn icon theme..."
cd /home/$USER/
git clone https://github.com/cbrnix/Newaita-reborn.git
cd Newaita-reborn
cp -r Newaita-reborn /usr/local/share/icons/
cp -r Newaita-reborn-dark /usr/local/share/icons/
cd && rm -rf /home/$USER/Newaita-reborn
gtk-update-icon-cache /usr/local/share/icons/Newaita-reborn*/

echo "Setting up root account's MATE desktop... looks the same as regular user's desktop, except there's no wallpaper change."
# Set window titlebar font.
gsettings set org.mate.Marco.general titlebar-font "Ubuntu Bold 11"
# Set window theme.
gsettings set org.mate.Marco.general theme vimix-light-doder
# Turn off middle click on window titlebar.
gsettings set org.mate.Marco.general action-middle-click-titlebar none
# Set theme.
gsettings set org.mate.interface gtk-theme "ClassicLooks Solaris"
# Set icon theme.
gsettings set org.mate.interface icon-theme Newaita-reborn
# Set fonts.
gsettings set org.mate.interface monospace-font-name "Office Code Pro 12"
gsettings set org.mate.interface font-name "Roboto 10"
gsettings set org.mate.caja.desktop font "Roboto 10"
# Turn off a couple useless menus.
gsettings set org.mate.interface show-input-method-menu false
gsettings set org.mate.interface show-unicode-menu false
# Set mouse cursor.
gsettings set org.mate.peripherals-mouse cursor-theme macOSBigSur
# Set up FreeDesktop sound theme.
pkg install -y freedesktop-sound-theme
gsettings set org.mate.sound enable-esd true
gsettings set org.mate.sound event-sounds true
gsettings set org.mate.sound input-feedback-sounds true
# Setup Caja preferences.
gsettings set org.mate.caja.preferences enable-delete true
gsettings set org.mate.caja.preferences preview-sound never

# Setup user's home directory with common folders.
xdg-user-dirs-update

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#greeter-setup-script=^/greeter-setup-script=/usr/local/bin/numlockx on/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user=^/autologin-user=$USER/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g /usr/local/etc/lightdm/lightdm.conf
mkdir /usr/local/etc/lightdm/wallpaper
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0062.jpg\?inline\=false -o /usr/local/etc/lightdm/wallpaper/0062.jpg
chown root:wheel /usr/local/etc/lightdm/wallpaper/0062.jpg

# Setup slick greeter.
cat << EOF > /usr/local/etc/lightdm/slick-greeter.conf
[Greeter]
background = /usr/local/etc/lightdm/wallpaper/0062.jpg
draw-user-backgrounds = true
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = ClassicLooks Rainyday
icon-theme-name = Newaita-reborn
EOF
