#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Xfce setup script."
echo "This script will setup Xorg, Xfce, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press the Enter key to continue..." resp

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

clear

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups gutenprint system-config-printer hplip
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (letter/a4): " resp
if [ "$resp" = letter ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = a4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ "$resp" = n ]; then
continue
fi

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji xfce xfce4-goodies xfburn skeuos-gtk-themes papirus-icon-theme epdfview catfish galculator xarchiver xfce4-docklike-plugin xfce4-pulseaudio-plugin font-manager qt5ct qt5-style-plugins ulauncher chromium webfonts micro xclip zsh ohmyzsh neofetch octopkg lightdm slick-greeter mp4v2 numlockx devcpu-data automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf colorize freedesktop-sound-theme rkhunter chkrootkit

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install 3rd party software.
./software_dialog_pkgs.sh
pkg clean -y

# Install BSDstats.
read -p "Would you like to enable BSDstats? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y bsdstats
sysrc bsdstats_enable="YES"
echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/'#REFUSE arabic chinese french german hebrew hungarian japanese'/'REFUSE arabic chinese french german hebrew hungarian japanese'/g /etc/portsnap.conf
sed -i '' s/'#REFUSE korean polish portuguese russian ukrainian vietnamese'/'REFUSE korean polish portuguese russian ukrainian vietnamese'/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

clear

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
sed -i '' '24s/$/print_hplip_UNSET=X11/' /etc/make.conf
echo "" >> /etc/make.conf
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/gutenprint && make install clean
cd /usr/ports/print/system-config-printer && make install clean
cd /usr/ports/print/hplip && make install clean
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size? (letter/a4): " resp
if [ "$resp" = letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ "$resp" = a4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
fi
if [ "$resp" = n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

# make.conf options for Xfce.
echo "# Xfce Options" >> /etc/make.conf
echo "x11-wm_xfce4_SET=LIGHTDM" >> /etc/make.conf
echo "x11-wm_xfce4_UNSET=GREYBIRD" >> /etc/make.conf

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
cd /usr/ports/x11-wm/xfce4 && make install clean
cd /usr/ports/x11/xfce4-goodies && make install clean
cd /usr/ports/sysutils/xfburn && make install clean
cd /usr/ports/x11-themes/skeuos-gtk-themes && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/graphics/epdfview && make install clean
cd /usr/ports/sysutils/catfish && make install clean
cd /usr/ports/math/galculator && make install clean
cd /usr/ports/archivers/xarchiver && make install clean
cd /usr/ports/x11/xfce4-docklike-plugin && make install clean
cd /usr/ports/audio/xfce4-pulseaudio-plugin && make install clean
cd /usr/ports/x11-fonts/font-manager && make install clean
cd /usr/ports/misc/qt5ct && make install clean
cd /usr/ports/x11-themes/qt5-style-plugins && make install clean
cd /usr/ports/x11/ulauncher && make install clean
cd /usr/ports/www/chromium && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/sysutils/fusefs-simple-mtpfs && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/plex-ttf && make install clean
cd /usr/ports/devel/xdg-user-dirs && make install clean
cd /usr/ports/sysutils/duf && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/audio/freedesktop-sound-theme && sudo make install clean
cd /usr/ports/security/rkhunter && make install clean
cd /usr/ports/security/chkrootkit && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

# Install 3rd party software.
./software_dialog_ports.sh

# Install BSDstats.
read -p "Would you like to enable BSDstats? (y/n): " resp
if [ "$resp" = y ]; then
portmaster --no-confirm sysutils/bsdstats
sysrc bsdstats_enable="YES"
echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi

clear

# Install Mousepad text editor color scheme.
fetch https://raw.githubusercontent.com/isdampe/gedit-gtk-one-dark-style-scheme/master/onedark-bright.xml -o /usr/local/share/gtksourceview-3.0/styles/onedark-bright.xml

# Setup Xfce4 Terminal colors.
mkdir -p /home/$USER/.config/xfce4/terminal/colorschemes
chown -R $USER:$USER /home/$USER/.config/xfce4/terminal
fetch https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/xfce4terminal/colorschemes/Andromeda.theme -o /home/$USER/.config/xfce4/terminal/colorschemes/Andromeda.theme
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/terminal/terminalrc /home/$USER/.config/xfce4/terminal/terminalrc
chown $USER:$USER /home/$USER/.config/xfce4/terminal/terminalrc
mkdir -p /usr/share/skel/dot.config/xfce4/terminal
cp -v /home/$USER/.config/xfce4/terminal/terminalrc /usr/share/skel/dot.config/xfce4/terminal/terminalrc

# Setup shutdown/sleep rules for Xfce.
cat << EOF > /usr/local/etc/polkit-1/rules.d/60-shutdown.rules
polkit.addRule(function (action, subject) {
  if ((action.id == "org.freedesktop.consolekit.system.restart" ||
      action.id == "org.freedesktop.consolekit.system.stop")
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
cat << EOF > /usr/local/etc/polkit-1/rules.d/70-sleep.rules
polkit.addRule(function (action, subject) {
  if (action.id == "org.freedesktop.consolekit.system.suspend"
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
pw group mod operator -m $USER

# Install cursor theme.
echo "Installing the "Volantes Light Cursors" cursor theme..."
tar -xvf volantes_light_cursors.tar.gz -C /usr/local/share/icons

# Setup Xfce preferences.
#####
mkdir -p /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml
chown -R $USER:$USER /home/$USER/.config/xfce4/xfconf
chown -R $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
#####

#####
mkdir -p /home/$USER/.config/xfce4/panel
chown -R $USER:$USER /home/$USER/.config/xfce4/panel
mkdir -p /usr/share/skel/dot.config/xfce4/panel
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/panel/whiskermenu-8.rc /home/$USER/.config/xfce4/panel/whiskermenu-8.rc
cp -v /home/$USER/.config/xfce4/panel/whiskermenu-8.rc /usr/share/skel/dot.config/xfce4/panel/whiskermenu-8.rc
chown $USER:$USER /home/$USER/.config/xfce4/panel/whiskermenu-8.rc
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/panel/docklike-7.rc /home/$USER/.config/xfce4/panel/docklike-7.rc
cp -v /home/$USER/.config/xfce4/panel/docklike-7.rc /usr/share/skel/dot.config/xfce4/panel/docklike-7.rc
chown $USER:$USER /home/$USER/.config/xfce4/panel/docklike-7.rc
#####

#####
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/xfce4/panel/datetime-16.rc /home/$USER/.config/xfce4/panel/datetime-16.rc
cp -v /home/$USER/.config/xfce4/panel/datetime-16.rc /usr/share/skel/dot.config/xfce4/panel/datetime-16.rc
chown $USER:$USER /home/$USER/.config/xfce4/panel/datetime-16.rc
#####

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/'#pam-autologin-service=lightdm-autologin'/'pam-autologin-service=lightdm-autologin'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#allow-user-switching=true'/'allow-user-switching=true'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#allow-guest=true'/'allow-guest=false'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#greeter-setup-script='/'greeter-setup-script=numlockx on'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#autologin-user='/'autologin-user=$USER'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#autologin-user-timeout=0'/'autologin-user-timeout=0'/g /usr/local/etc/lightdm/lightdm.conf
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
theme-name = Skeuos-Blue-Light
icon-theme-name = Papirus-Light
EOF

# Setup qt5ct and fix GTK/QT antialiasing.
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/.xinitrc /home/$USER/.xinitrc
cp -v /home/$USER/.xinitrc /usr/share/skel/dot.xinitrc
chown $USER:$USER /home/$USER/.xinitrc

# Setup qt5ct
mkdir /home/$USER/.config/qt5ct
chown -R $USER:$USER /home/$USER/.config/qt5ct
mkdir /usr/share/skel/dot.config/qt5ct
cp -v /home/$USER/freebsd-setup-scripts/Dotfiles/config/qt5ct/qt5ct.conf /home/$USER/.config/qt5ct/qt5ct.conf
cp -v /home/$USER/.config/qt5ct/qt5ct.conf /usr/share/skel/dot.config/qt5ct/qt5ct.conf
chown $USER:$USER /home/$USER/.config/qt5ct/qt5ct.conf

# Hide menu items.
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_assistant.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_designer.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_linguist.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gnome.Glade.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.Demo4.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.IconBrowser4.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.PrintEditor.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.gtk.WidgetFactory4.desktop

# Fix user's .xinitrc permissions.
chown $USER:$USER /home/$USER/.xinitrc

# Fix user's config directory permissions.
chown -R $USER:$USER /home/$USER/.config

# Fix user's local directory permissions.
mkdir /home/$USER/.local
chown -R $USER:$USER /home/$USER/.local

# Install Ulauncher theme.
mkdir -p /home/$USER/.config/ulauncher/user-themes
git clone https://github.com/SylEleuth/ulauncher-gruvbox /home/$USER/.config/ulauncher/user-themes/gruvbox-ulauncher
chown -R $USER:$USER /home/$USER/.config/ulauncher
mkdir -p /usr/share/skel/dot.config/ulauncher/user-themes
cp -r /home/$USER/.config/ulauncher/user-themes/gruvbox-ulauncher /usr/share/skel/dot.config/ulauncher/user-themes/gruvbox-ulauncher
cp -rv /home/$USER/freebsd-setup-scripts/Dotfiles/config/ulauncher/settings.json /usr/share/skel/dot.config/ulauncher/settings.json

# Configure rkhunter (rootkit malware scanner).
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --skip-keypress"' >> /etc/periodic.conf
