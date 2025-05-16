#!/bin/sh
set -e

# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

clear

echo "Welcome to the FreeBSD Katana setup script."
echo "This script will setup Xorg, the Katana desktop, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -rp "Press the Enter key to continue..." resp

clear

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
sed -e 's|quarterly|latest|g' /etc/pkg/FreeBSD.conf > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update
echo ""

# Add Katana desktop repo.
cat << 'EOF' > /usr/local/etc/pkg/repos/Katana.conf
Katana: {
  url: "pkg+https://raw.githubusercontent.com/fluxer/katana-freebsd/master",
  mirror_type: "srv",
  enabled: yes
}
EOF
pkg update
echo ""

# Make pkg use sane defaults.
echo "" >> /usr/local/etc/pkg.conf
echo "# Make pkg use sane defaults." >> /usr/local/etc/pkg.conf
grep -q "DEFAULT_ALWAYS_YES" /usr/local/etc/pkg.conf || echo "DEFAULT_ALWAYS_YES=yes" >> /usr/local/etc/pkg.conf
grep -q "AUTOCLEAN" /usr/local/etc/pkg.conf || echo "AUTOCLEAN=yes" >> /usr/local/etc/pkg.conf

# Printer support.
dialog --title "$1" --menu "$2" 12 40 2 "$3" "$4" 2> /tmp/menu_resp
menu_resp=$(cat /tmp/menu_resp)
echo "$menu_resp"

# Check if the user plans to use a printer.
dialog --title "Printer Setup" --yesno "Do you plan to use a printer?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    pkg install -y cups cups-filters cups-pk-helper gutenprint system-config-printer

    sysrc cupsd_enable="YES"
    sysrc cups_browsed_enable="YES"
    sysrc avahi_daemon_enable="YES"
    sysrc avahi_dnsconfd_enable="YES"
    sed -i '' 's/JobPrivateAccess/#JobPrivateAccess/g' /usr/local/etc/cups/cupsd.conf
    sed -i '' 's/JobPrivateValues/#JobPrivateValues/g' /usr/local/etc/cups/cupsd.conf

    # Paper Size Setup
    dialog --title "Paper Size" --menu "Select paper size:" 12 40 2 \
        1 "Letter" \
        2 "A4" 2> /tmp/papersize_resp

    papersize_resp=$(cat /tmp/papersize_resp)

    if [ "$papersize_resp" = 1 ]; then
        pkg install -y papersize-default-letter
    elif [ "$papersize_resp" = 2 ]; then
        pkg install -y papersize-default-a4
    fi

    dialog --title "HP Printer" --yesno "Do you own an HP printer?" 8 40
    hp_resp=$?

    if [ $hp_resp -eq 0 ]; then
        pkg install -y hplip
    fi

    # Add the final dialog to inform the user that the setup is complete.
    dialog --title "Setup Complete" --infobox "Printer support has been installed and configured." 5 40
    sleep 3
fi

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji katana-workspace katana-extraapps Kvantum-qt5 ulauncher ungoogled-chromium webfonts micro xclip zsh ohmyzsh fastfetch pfetch octopkg mp4v2 numlockx automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts wcurl

# Install CPU microcode.
dialog --title "CPU Microcode" --menu "Which CPU do you have installed? Needed to install CPU microcode." 12 40 12 \
	1 "AMD" \
	2 "Intel" 2> /tmp/microcode_resp

microcode_resp=$(cat /tmp/microcode_resp)
if [ "$microcode_resp" = 1 ]; then
    pkg install -y cpu-microcode-amd
elif [ "$microcode_resp" = 2 ]; then
    pkg install -y cpu-microcode-intel
fi

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install cursor theme.
dialog --title "Cursor Theme Installation" --yesno "Would you like to install the 'Bibata Modern Ice' cursor theme?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    dialog --title "Installing Cursor Theme" --infobox "Installing the 'Bibata Modern Ice' cursor theme..." 5 40
    fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz -o /home/"$logged_in_user"/Bibata-Modern-Ice.tar.gz
    tar -xvf /home/"$logged_in_user"/Bibata-Modern-Ice.tar.gz -C /usr/local/share/icons
    rm -rf /home/"$logged_in_user"/Bibata-Modern-Ice.tar.gz
    dialog --title "Installation Complete" --msgbox "'Bibata Modern Ice' cursor theme has been installed." 8 40
fi

# Enable KDM (KDE4 display manager) on boot.
sysrc kdm_enable="YES"

# Install 3rd party software.
./software_dialog_pkgs.sh

# Install BSDstats.
# Function to install BSDstats and enable it.
install_bsdstats() {
    pkg install -y bsdstats
    sysrc bsdstats_enable="YES"
    echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
}

# Install BSDstats without a progress bar.
dialog --title "BSDstats Setup" --yesno "Would you like to enable BSDstats?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    install_bsdstats
    dialog --title "Installation Complete" --infobox "BSDstats has been installed and enabled." 5 40
    sleep 3
fi

# Fix GTK/QT antialiasing
cat << 'EOF' > /home/"$logged_in_user"/.xinitrc
# GTK/QT Antialiasing
export QT_XFT=1
export GDK_USE_XFT=1
EOF

# Hide menu items.
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_assistant.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_designer.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_linguist.desktop

# Fix user's .xinitrc permissions.
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.xinitrc

# Fix user's config directory permissions.
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config

# Fix user's local directory permissions.
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.local

# Install Ulauncher theme.
mkdir -p /home/"$logged_in_user"/.config/ulauncher/user-themes
git clone https://github.com/SylEleuth/ulauncher-gruvbox /home/"$logged_in_user"/.config/ulauncher/user-themes/gruvbox-ulauncher
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/ulauncher
mkdir -p /usr/share/skel/dot.config/ulauncher/user-themes
cp -r /home/"$logged_in_user"/.config/ulauncher/user-themes/gruvbox-ulauncher /usr/share/skel/dot.config/ulauncher/user-themes/gruvbox-ulauncher
cp -rv /home/"$logged_in_user"/freebsd-setup-scripts/Dotfiles/config/ulauncher/settings.json /usr/share/skel/dot.config/ulauncher/settings.json

# Configure rkhunter (rootkit malware scanner).
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --skip-keypress"' >> /etc/periodic.conf

# Download wallpapers.
./wallpapers.sh