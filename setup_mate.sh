#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD MATE setup script."
echo "This script will setup Xorg, MATE, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press any key to continue..." resp

clear

read -p "Do you plan to install software via pkg (binary packages) or ports (FreeBSD Ports tree)? (pkg/ports): " resp
if [ 0"$resp" = 0pkg ]; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { 
  url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF
pkg update
echo ""

read -p "Do you plan to use a printer? (y/n): " resp
if [ 0"$resp" = 0y ]; then
pkg install -y cups
sysrc cupsd_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ 0"$resp" = 0Letter ]; then
pkg install -y papersize-default-letter
fi
if [ 0"$resp" = 0A4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ 0"$resp" = 0n ]; then
continue
fi

clear

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji mate galculator parole qt5ct qt5-style-plugins firefox webfonts micro xclip zsh ohmyzsh neofetch lightdm slick-greeter mp4v2 skeuos-gtk-themes papirus-icon-theme numlockx devcpu-data automount unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize
pkg clean -y

# Setup rc.conf file.
./rcconf_setup.sh

# Setup MATE themes. Will be ran as a normal user.
su - $USER
./freebsd_mate_theme_install.sh
exit

clear

read -p "Do you want to install any extra 3rd party software?

1. Audacity (audio editor)
2. Xfburn (CD burner)
3. Handbrake (video file converter)
4. ISO Master (ISO file editor)
5. AbiWord (word processor)
6. Gnumeric (speadsheet)
7. Transmission (Torrent downloader)
8. Asunder (CD ripper)
9. GIMP (image editor)
10. Inkskape (vector graphics editor)
11. Pinta (image editor similar to Paint.NET on Windows)
12. Shotwell (photo organizer/editor)
13. VirtualBox (run multiple operating systems on your PC)
14. Wine (run Windows applications)

15. All of the above.
16. None of the above.
-> " resp
if [ 0"$resp" = 01 ]; then
pkg install -y audacity
if [ 0"$resp" = 02 ]; then
pkg install -y xfburn
if [ 0"$resp" = 03 ]; then
pkg install -y handbrake
if [ 0"$resp" = 04 ]; then
pkg install -y isomaster
if [ 0"$resp" = 05 ]; then
pkg install -y abiword
if [ 0"$resp" = 06 ]; then
pkg install -y gnumeric
if [ 0"$resp" = 07 ]; then
pkg install -y transmission-gtk
if [ 0"$resp" = 08 ]; then
pkg install -y asunder
if [ 0"$resp" = 09 ]; then
pkg install -y gimp
if [ 0"$resp" = 010 ]; then
pkg install -y inkscape
if [ 0"$resp" = 011 ]; then
pkg install -y pinta
if [ 0"$resp" = 012 ]; then
pkg install -y shotwell
if [ 0"$resp" = 013 ]; then
pkg install -y virtualbox-ose
if [ 0"$resp" = 014 ]; then
pkg install -y wine wine-mono wine-gecko
if [ 0"$resp" = 015 ]; then
pkg install -y audacity xfburn handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell virtualbox-ose wine wine-mono wine-gecko
if [ 0"$resp" = 016 ]; then
continue
fi

if [ 0"$resp" = 0ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/"#REFUSE arabic chinese french german hebrew hungarian japanese/REFUSE arabic chinese french german hebrew hungarian japanese"/g /etc/portsnap.conf
sed -i '' s/"#REFUSE korean polish portuguese russian ukrainian vietnamese/REFUSE korean polish portuguese russian ukrainian vietnamese"/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

read -p "Do you plan to use a printer? (y/n): " resp
if [ 0"$resp" = 0y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
cd /usr/ports/print/cups && make install clean
sysrc cupsd_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ 0"$resp" = 0Letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ 0"$resp" = 0A4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
fi
if [ 0"$resp" = 0n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

clear

# Install Ports.
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/mate && make install clean
cd /usr/ports/math/galculator && make install clean
cd /usr/ports/multimedia/parole && make install clean
cd /usr/ports/misc/qt5ct && make install clean
cd /usr/ports/x11-themes/qt5-style-plugins && make install clean
cd /usr/ports/www/firefox && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/x11/lightdm && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11-themes/skeuos-gtk-themes && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && make install clean
cd /usr/ports/x11-fonts/office-code-pro && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && make install clean
cd /usr/ports/devel/xdg-user-dirs && make install clean
cd /usr/ports/sysutils/duf && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

# Setup MATE theme. Will be ran as a normal user.
su - $USER
./freebsd_mate_theme_install_ports.sh
exit

clear

read -p "Do you want to install any extra 3rd party software?

1. Audacity (audio editor)
2. Xfburn (CD burner)
3. Handbrake (video file converter)
4. ISO Master (ISO file editor)
5. AbiWord (word processor)
6. Gnumeric (speadsheet)
7. Transmission (Torrent downloader)
8. Asunder (CD ripper)
9. GIMP (image editor)
10. Inkskape (vector graphics editor)
11. Pinta (image editor similar to Paint.NET on Windows)
12. Shotwell (photo organizer/editor)
13. VirtualBox (run multiple operating systems on your PC)
14. Wine (run Windows applications)

15. All of the above.
16. None of the above.
-> " resp
if [ 0"$resp" = 01 ]; then
cd /usr/ports/audio/audacity && make install clean
if [ 0"$resp" = 02 ]; then
cd /usr/ports/sysutils/xfburn && make install clean
if [ 0"$resp" = 03 ]; then
cd /usr/ports/multimedia/handbrake && make install clean
if [ 0"$resp" = 04 ]; then
cd /usr/ports/sysutils/isomaster && make install clean
if [ 0"$resp" = 05 ]; then
cd /usr/ports/editors/abiword && make install clean
if [ 0"$resp" = 06 ]; then
cd /usr/ports/math/gnumeric && make install clean
if [ 0"$resp" = 07 ]; then
cd /usr/ports/net-p2p/transmission-gtk && make install clean
if [ 0"$resp" = 08 ]; then
cd /usr/ports/audio/asunder && make install clean
if [ 0"$resp" = 09 ]; then
cd /usr/ports/graphics/gimp && make install clean
if [ 0"$resp" = 010 ]; then
cd /usr/ports/graphics/inkscape && make install clean
if [ 0"$resp" = 011 ]; then
cd /usr/ports/graphics/pinta && make install clean
if [ 0"$resp" = 012 ]; then
cd /usr/ports/graphics/shotwell && make install clean
if [ 0"$resp" = 013 ]; then
cd /usr/ports/emulators/virtualbox-ose && make install clean
if [ 0"$resp" = 014 ]; then
cd /usr/ports/emulators/wine && make install clean
cd /usr/ports/emulators/wine-gecko && make install clean
if [ 0"$resp" = 015 ]; then
portmaster -y audio/audacity sysutils/xfburn multimedia/handbrake sysutils/isomaster editors/abiword math/gnumeric net-p2p/transmission-gtk audio/asunder graphics/gimp graphics/inkscape graphics/pinta graphics/shotwell emulators/virtualbox-ose emulators/wine emulators/wine-gecko
if [ 0"$resp" = 016 ]; then
continue
fi

# Install Pluma text editor color scheme.
fetch https://raw.githubusercontent.com/isdampe/gedit-gtk-one-dark-style-scheme/master/onedark-bright.xml -o /usr/local/share/gtksourceview-4/styles/onedark-bright.xml

# Install cursor theme.
echo "Installing the macOS Big Sur cursor theme..."
cd /home/$USER/ && fetch https://github.com/ful1e5/apple_cursor/releases/download/v1.2.0/macOSBigSur.tar.gz -o macOSBigSur.tar.gz
tar -xvf macOSBigSur.tar.gz
echo 'Moving cursor theme directory to "/usr/local/share/icons"...'
mv macOSBigSur /usr/local/share/icons/
echo "Setting proper file permissions..."
chown -R root:wheel /usr/local/share/icons/macOSBigSur/*
rm -rf macOSBigSur.tar.gz

echo "Setting up root account's MATE desktop... looks the same as regular user's desktop, except there's no wallpaper change."
# Set window titlebar font.
gsettings set org.mate.Marco.general titlebar-font "Ubuntu Bold 11"
# Set window theme.
gsettings set org.mate.Marco.general theme vimix-light-doder
# Turn off middle click on window titlebar.
gsettings set org.mate.Marco.general action-middle-click-titlebar none
# Set theme.
gsettings set org.mate.interface gtk-theme "Skeuos-Blue-Dark"
# Set icon theme.
gsettings set org.mate.interface icon-theme Papirus-Dark
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

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#greeter-setup-script=^/greeter-setup-script=/usr/local/bin/numlockx on/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user=^/autologin-user=$USER/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g /usr/local/etc/lightdm/lightdm.conf
mkdir /usr/local/etc/lightdm/wallpaper
fetch https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate13.0/files/wallpaper/centerFlat_grey-4k.png -o /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
chown root:wheel /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png

# Setup slick greeter.
cat << EOF > /usr/local/etc/lightdm/slick-greeter.conf
[Greeter]
background = /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
draw-user-backgrounds = false
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = Papirus-Light
icon-theme-name = Skeuos-Blue-Light
EOF
