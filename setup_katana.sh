#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Katana setup script."
echo "This script will setup Xorg, the Katana desktop, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press the Enter key to continue..." resp

clear

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
sed -e 's|quarterly|latest|g' /etc/pkg/FreeBSD.conf > /usr/local/etc/pkg/repos/FreeBSD.conf

# Add Katana desktop repo.
cat << EOF > /usr/local/etc/pkg/repos/Katana.conf
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
echo DEFAULT_ALWAYS_YES=yes >> /usr/local/etc/pkg.conf
echo AUTOCLEAN=yes >> /usr/local/etc/pkg.conf

# Printer support.
# Function to install packages with a progress bar.
install_packages_with_progress() {
    dialog --title "Installing Packages" --gauge "Installing $1..." 5 40
    pkg install -y "$1"
    echo "100"
}

# Function to display a menu and return the selected option.
display_menu() {
    dialog --title "$1" --menu "$2" 12 40 2 "$3" "$4" 2> /tmp/menu_resp
    menu_resp=$(cat /tmp/menu_resp)
    echo "$menu_resp"
}

# Check if the user plans to use a printer.
dialog --title "Printer Setup" --yesno "Do you plan to use a printer?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    (
        install_packages_with_progress "cups cups-filters cups-pk-helper gutenprint system-config-printer"
    ) | dialog --title "Installing Printer Packages" --gauge "Installing printer-related packages..." 10 50 0

    sysrc cupsd_enable="YES"
    sysrc cups_browsed_enable="YES"
    sysrc avahi_daemon_enable="YES"
    sysrc avahi_dnsconfd_enable="YES"
    sed -i '' 's/JobPrivateAccess/#JobPrivateAccess/g' /usr/local/etc/cups/cupsd.conf
    sed -i '' 's/JobPrivateValues/#JobPrivateValues/g' /usr/local/etc/cups/cupsd.conf

    selected_option=$(display_menu "Paper Size" "Select paper size:" "1" "Letter" "2" "A4")

    if [ "$selected_option" = 1 ]; then
        (
            install_packages_with_progress "papersize-default-letter"
        ) | dialog --title "Installing Letter Paper Size" --gauge "Installing papersize-default-letter..." 10 50 0
    elif [ "$selected_option" = 2 ]; then
        (
            install_packages_with_progress "papersize-default-a4"
        ) | dialog --title "Installing A4 Paper Size" --gauge "Installing papersize-default-a4..." 10 50 0
    fi

    dialog --title "HP Printer" --yesno "Do you own an HP printer?" 8 40
    hp_resp=$?

    if [ $hp_resp -eq 0 ]; then
        (
            install_packages_with_progress "hplip"
        ) | dialog --title "Installing HPLIP" --gauge "Installing HPLIP..." 10 50 0
    fi
fi

clear

# Install packages.
####################
# Create a list of packages to install.
packages_to_install="bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji katana-workspace katana-extraapps Kvantum-qt5 ulauncher ungoogled-chromium webfonts micro xclip zsh ohmyzsh neofetch pfetch octopkg mp4v2 numlockx devcpu-data automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts"

# Use dialog to create a progress bar for package installation.
dialog --title "Package Installation" --gauge "Installing packages..." 10 50 < <(
    pkg install -y $packages_to_install
)

# Check if any errors occurred during the installation.
if [ $? -ne 0 ]; then
    dialog --title "Error" --msgbox "An error occurred while installing packages." 10 40
    exit 1
fi

dialog --title "Installation Complete" --msgbox "Packages have been installed." 10 40
####################

clear

# Setup rc.conf file.
./rcconf_setup.sh

# Install cursor theme.
dialog --title "Cursor Theme Installation" --yesno "Would you like to install the 'Bibata Modern Ice' cursor theme?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    dialog --title "Installing Cursor Theme" --infobox "Installing the 'Bibata Modern Ice' cursor theme..." 5 40
    fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Ice.tar.gz -o /home/$USER/Bibata-Modern-Ice.tar.gz
    tar -xvf /home/$USER/Bibata-Modern-Ice.tar.gz -C /usr/local/share/icons
    rm -rf /home/$USER/Bibata-Modern-Ice.tar.gz
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

    # Install BSDstats with a progress bar.
    dialog --title "BSDstats Setup" --yesno "Would you like to enable BSDstats?" 8 40
    resp=$?

    if [ $resp -eq 0 ]; then
        (
            install_bsdstats
            echo "100"
        ) | dialog --title "BSDstats Installation" --gauge "Installing BSDstats..." 10 50 0
        result=$?
        if [ $result -ne 0 ]; then
            dialog --title "Error" --msgbox "An error occurred during BSDstats installation." 10 40
            exit 1
        else
            dialog --title "Installation Complete" --msgbox "BSDstats has been installed and enabled." 10 40
        fi
    fi
fi

# Fix GTK/QT antialiasing
cat << EOF > /home/$USER/.xinitrc
# GTK/QT Antialiasing
export QT_XFT=1
export GDK_USE_XFT=1
EOF

# Hide menu items.
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_assistant.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_designer.desktop
echo "Hidden=true" >> /usr/local/share/applications/usr_local_lib_qt5_bin_linguist.desktop

# Fix user's .xinitrc permissions.
chown $USER:$USER /home/$USER/.xinitrc

# Fix user's config directory permissions.
chown -R $USER:$USER /home/$USER/.config

# Fix user's local directory permissions.
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

# Download wallpapers.
./wallpapers.sh
