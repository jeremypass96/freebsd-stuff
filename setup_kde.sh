#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD KDE setup script."
echo "This script will setup Xorg, KDE, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press the Enter key to continue..." resp

clear

read -p "Do you plan to install software via pkg (binary packages) or ports (FreeBSD Ports tree)? (pkg/ports): " resp
if [ "$resp" = pkg ]; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
sed -e 's|quarterly|latest|g' /etc/pkg/FreeBSD.conf > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update
echo ""

# Make pkg use sane defaults.
echo "" >> /usr/local/etc/pkg.conf
echo "# Make pkg use sane defaults." >> /usr/local/etc/pkg.conf
echo DEFAULT_ALWAYS_YES=yes >> /usr/local/etc/pkg.conf
echo AUTOCLEAN=yes >> /usr/local/etc/pkg.conf

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y cups cups-filters cups-pk-helper gutenprint system-config-printer print-manager
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sysrc avahi_daemon_enable="YES"
sysrc avahi_dnsconfd_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size?
1. Letter
2. A4
--> " resp
if [ "$resp" = 1 ]; then
pkg install -y papersize-default-letter
fi
if [ "$resp" = 2 ]; then
pkg install -y papersize-default-a4
fi
read -p "Do you own an HP printer? (y/n): " resp
if [ "$resp" = y ]; then
pkg install -y hplip
fi
if [ "$resp" = n ]; then
continue
fi
fi
if [ "$resp" = n ]; then
continue
fi

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji plasma5-plasma kde-baseapps kdeadmin kcalc kcharselect kwalletmanager ark k3b spectacle gwenview juk sddm plasma5-sddm-kcm papirus-icon-theme ungoogled-chromium webfonts micro xclip zsh ohmyzsh neofetch pfetch octopkg mp4v2 numlockx devcpu-data automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts Kvantum-qt5

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install 3rd party software.
./software_dialog_pkgs.sh

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

# Generate SDDM config file.
sddm --example-config > /usr/local/etc/sddm.conf
sed -i '' s/Relogin=false/Relogin=true/g /usr/local/etc/sddm.conf
sed -i '' s/User=/User=$USER/g /usr/local/etc/sddm.conf

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/'# REFUSE arabic chinese french german hebrew hungarian japanese'/'REFUSE arabic chinese french german hebrew hungarian japanese'/g /etc/portsnap.conf
sed -i '' s/'# REFUSE korean polish portuguese russian ukrainian vietnamese'/'REFUSE korean polish portuguese russian ukrainian vietnamese'/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

clear

read -p "Do you plan to use a printer? (y/n): " resp
if [ "$resp" = y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
echo "" >> /etc/make.conf
cd /usr/ports/print/cups && make install clean
cd /usr/ports/print/cups-filters && make install clean
cd /usr/ports/print/cups-pk-helper && make install clean
cd /usr/ports/print/gutenprint && make install clean
cd /usr/ports/print/system-config-printer && make install clean
cd /usr/ports/print/print-manager && make install clean
sysrc cupsd_enable="YES"
sysrc cups_browsed_enable="YES"
sysrc avahi_daemon_enable="YES"
sysrc avahi_dnsconfd_enable="YES"
sed -i '' s/JobPrivateAccess/#JobPrivateAccess/g /usr/local/etc/cups/cupsd.conf
sed -i '' s/JobPrivateValues/#JobPrivateValues/g /usr/local/etc/cups/cupsd.conf
read -p "Paper size?
1. Letter
2. A4
--> " resp
if [ "$resp" = 1 ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ "$resp" = 2 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
read -p "Do you own an HP printer? (y/n): " resp
if [ "$resp" = y ]; then
cd /usr/ports/print/hplip && make install clean
sed -i '' '24s/$/print_hplip_UNSET=X11/' /etc/make.conf
fi
if [ "$resp" = n ]; then
continue
fi
fi
if [ "$resp" = n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

# make.conf options for KDE.
echo "" >> /etc/make.conf
echo "# KDE Options" >> /etc/make.conf
echo "x11_kde5_UNSET=KDEEDU KDEGRAPHICS KDEMULTIMEDIA KDENETWORK KDEPIM KDEUTILS" >> /etc/make.conf

clear

# Install Ports.
cd /usr/ports/shells/bash && make install clean
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/sysutils/pfetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/kde5 && make install clean
cd /usr/ports/math/kcalc && make install clean
cd /usr/ports/deskutils/kcharselect && make install clean
cd /usr/ports/security/kwalletmanager && make install clean
cd /usr/ports/archivers/ark && make install clean
cd /usr/ports/sysutils/k3b && make install clean
cd /usr/ports/graphics/spectacle && make install clean
cd /usr/ports/graphics/gwenview && make install clean
cd /usr/ports/audio/juk && make install clean
cd /usr/ports/x11/sddm && make install clean
cd /usr/ports/deskutils/plasma5-sddm-kcm && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/www/ungoogled-chromium && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
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
cd /usr/ports/sysutils/btop && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/audio/freedesktop-sound-theme && make install clean
cd /usr/ports/security/rkhunter && make install clean
cd /usr/ports/security/chkrootkit && make install clean
cd /usr/ports/sysutils/topgrade && make install clean
cd /usr/ports/textproc/bat && make install clean
cd /usr/ports/sysutils/fd && make install clean
cd /usr/ports/sysutils/lsd && make install clean
cd /usr/ports/x11-fonts/nerd-fonts && make install clean
cd /usr/ports/x11-themes/Kvantum && make install clean
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

# Enable SDDM (Simple Desktop Display Manager) on boot.
sysrc sddm_enable="YES"

# Install cursor theme.
echo "Installing the "Bibata Modern Ice" cursor theme..."
fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz -o /home/$USER/Bibata-Modern-Ice.tar.gz
tar -xvf /home/$USER/Bibata-Modern-Ice.tar.gz -C /usr/local/share/icons
rm -rf /home/$USER/Bibata-Modern-Ice.tar.gz

# Download Konsole colors.
mkdir -p /home/$USER/.local/share/konsole
mkdir -p /usr/share/skel/dot.local/share/konsole
git clone https://github.com/catppuccin/konsole.git
cd konsole/
cp -v Catppuccin-Mocha.colorscheme /home/$USER/.local/share/konsole
cp -v Catppuccin-Mocha.colorscheme /usr/share/skel/dot.local/share/konsole
cd && rm -rf konsole/

# Hide menu items.
echo "Hidden=true" >> /usr/local/share/applications/org.kde.plasma.cuttlefish.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_assistant.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_designer.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_linguist.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.kde.plasma.themeexplorer.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.kde.plasmaengineexplorer.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.kde.plasma.lookandfeelexplorer.desktop
echo "Hidden=true" >> /usr/local/share/applications/org.kde.kuserfeedback-console.desktop

# Fix duplicate Gnumeric menu entry.
sed -i '' s/Science/\/g /usr/local/share/applications/gnumeric.desktop
sed -i '' s/Math/\/g /usr/local/share/applications/gnumeric.desktop

# Fix GTK/QT antialiasing
cat << EOF > /home/$USER/.xinitrc
# GTK/QT Antialiasing
export QT_XFT=1
export GDK_USE_XFT=1
EOF

# Fix user's .xinitrc permissions.
chown $USER:$USER /home/$USER/.xinitrc

# Fix user's config directory permissions.
chown -R $USER:$USER /home/$USER/.config

# Fix user's local directory permissions.
chown -R $USER:$USER /home/$USER/.local

# Configure rkhunter (rootkit malware scanner).
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --skip-keypress"' >> /etc/periodic.conf

# Fix KDE power buttons not appearing on application launcher menu.
cat << EOF > /usr/local/etc/polkit-1/rules.d/40-wheel-group.rules
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF
