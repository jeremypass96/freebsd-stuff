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
if [ "$resp" = pkg ]; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF
pkg update
echo ""

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups gutenprint
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ "$resp" = Letter ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = A4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ "$resp" = n ]; then
continue
fi

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji mate galculator parole qt5ct qt5-style-plugins firefox webfonts micro xclip zsh ohmyzsh neofetch lightdm slick-greeter mp4v2 skeuos-gtk-themes papirus-icon-theme numlockx devcpu-data automount unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize freedesktop-sound-theme
pkg clean -y

# Setup rc.conf file.
./rcconf_setup.sh

# Install 3rd party software.
./software_dialog_pkgs.sh
fi

if [ "$resp" = ports ]; then

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
if [ "$resp" = y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/gutenprint && make install clean
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ "$resp" = Letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ "$resp" = A4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
fi
if [ "$resp" = n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

clear

# Install Ports.
cd /usr/ports/shells/bash && make install clean
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
cd /usr/ports/audio/freedesktop-sound-theme && sudo make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

# Install 3rd party software.
./software_dialog_ports.sh
fi

clear

# Install Pluma text editor color scheme.
fetch https://raw.githubusercontent.com/isdampe/gedit-gtk-one-dark-style-scheme/master/onedark-bright.xml -o /usr/local/share/gtksourceview-4/styles/onedark-bright.xml

# Install cursor theme.
echo "Installing the "Volantes Light Cursors" cursor theme..."
tar -xf volantes_light_cursors.tar.gz -C /usr/local/share/icons

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

# Setup qt5ct and fix GTK/QT antialiasing
cat << EOF > /home/$USER/.xinitrc
# qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct
# GTK/QT Antialiasing
export QT_XFT=1
export GDK_USE_XFT=1
EOF
chown $USER:$USER /home/$USER/.xinitrc

# Setup qt5ct
mkdir /home/$USER/.config/qt5ct
cat << EOF > /home/$USER/.config/qt5ct/qt5ct.conf
[Appearance]
color_scheme_path=/usr/local/share/qt5ct/colors/airy.conf
custom_palette=false
icon_theme=Papirus-Dark
standard_dialogs=default
style=gtk2

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\x1e\0O\0\x66\0\x66\0i\0\x63\0\x65\0 \0\x43\0o\0\x64\0\x65\0 \0P\0r\0o@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\f\0R\0o\0\x62\0o\0t\0o@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=0
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[SettingsWindow]
geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\xd1\0\0\0+\0\0\x3\xb1\0\0\x2\xb1\0\0\0\xd2\0\0\0I\0\0\x3\xb0\0\0\x2\xb0\0\0\0\0\0\0\0\0\x4\0\0\0\0\xd2\0\0\0I\0\0\x3\xb0\0\0\x2\xb0)

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()
EOF
chown $USER:$USER /home/$USER/.config/qt5ct/qt5ct.conf
