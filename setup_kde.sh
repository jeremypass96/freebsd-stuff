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

# Printer support.
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

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji plasma6-plasma kde-baseapps kdeadmin kcalc kcharselect kwalletmanager ark k3b spectacle gwenview juk sddm plasma6-sddm-kcm papirus-icon-theme ungoogled-chromium webfonts micro xclip zsh ohmyzsh fastfetch pfetch octopkg mp4v2 numlockx automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf plex-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts Kvantum-qt5

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
fi

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Pull in Ports tree with git.
git clone https://git.FreeBSD.org/ports.git /usr/ports
git -C /usr/ports pull

clear

# Printer support.
# Function to install a port with progress bar.
install_port_with_progress() {
    local port_name="$1"
    local title="$2"
    dialog --title "$title" --infobox "Installing $port_name..." 5 40
    cd /usr/ports/print/"$port_name" && make install clean
    echo "100"
}

# Function to install printer-related ports.
install_printer_ports() {
    sed -i '' '16s/$/ CUPS/' /etc/make.conf
    echo "" >> /etc/make.conf

    dialog --title "Installing Print Software" --infobox "Installing print software..." 5 40

    ports_to_install="print/cups print/cups-filters print/cups-pk-helper print/gutenprint print/system-config-printer"

    for port in $ports_to_install; do
        port_name=$(basename "$port")
        (
            dialog --title "Installing $port_name" --infobox "Installing $port_name..." 5 40
            cd /usr/ports/$port && make install clean
            echo "100"
        ) | dialog --title "Installing $port_name" --infobox "Installing $port_name..." 10 50 0
        result=$?
        if [ $result -ne 0 ]; then
            dialog --title "Error" --msgbox "An error occurred during $port_name installation." 10 40
            exit 1
        fi
    done
}

# Printer support with progress bar.
dialog --title "Printer Setup" --yesno "Do you plan to use a printer?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    (
        install_printer_ports
        echo "100"
    ) | dialog --title "Printer Setup" --infobox "Setting up printer support..." 10 50 0
    result=$?
    if [ $result -ne 0 ]; then
        dialog --title "Error" --msgbox "An error occurred during printer setup." 10 40
        exit 1
    else
        dialog --title "Setup Complete" --infobox "Printer support has been installed and configured." 5 40
        sleep 3
    fi
fi

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
    (
        install_port_with_progress "papersize-default-letter" "Installing Letter Paper Size"
    ) | dialog --title "Installing Letter Paper Size" --infobox "Installing Letter Paper Size..." 10 50 0
elif [ "$papersize_resp" = 2 ]; then
    (
        install_port_with_progress "papersize-default-a4" "Installing A4 Paper Size"
    ) | dialog --title "Installing A4 Paper Size" --infobox "Installing A4 Paper Size..." 10 50 0
fi

# HP Printer Setup
dialog --title "HP Printer" --yesno "Do you own an HP printer?" 8 40
hp_resp=$?

if [ $hp_resp -eq 0 ]; then
    (
        sed -i '' '27s/$/print_hplip_UNSET=X11/' /etc/make.conf
        dialog --title "Installing HPLIP" --infobox "Installing HPLIP..." 5 40
        cd /usr/ports/print/hplip && make install clean
        echo "100"
    ) | dialog --title "Installing HPLIP" --infobox "Installing HPLIP..." 10 50 0
else
    sed -i '' '17s/$/ CUPS/' /etc/make.conf
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
cd /usr/ports/sysutils/fastfetch && make install clean
cd /usr/ports/sysutils/pfetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11/kde6 && make install clean
cd /usr/ports/math/kcalc && make install clean
cd /usr/ports/deskutils/kcharselect && make install clean
cd /usr/ports/security/kwalletmanager && make install clean
cd /usr/ports/archivers/ark && make install clean
cd /usr/ports/sysutils/k3b && make install clean
cd /usr/ports/graphics/spectacle && make install clean
cd /usr/ports/graphics/gwenview && make install clean
cd /usr/ports/audio/juk && make install clean
cd /usr/ports/x11/sddm && make install clean
cd /usr/ports/deskutils/plasma6-sddm-kcm && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/www/ungoogled-chromium && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11/numlockx && make install clean
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

# Install CPU microcode.
dialog --title "CPU Microcode" --menu "Which CPU do you have installed? Needed to install CPU microcode." 12 40 12 \
    1 "AMD" \
    2 "Intel" 2> /tmp/microcode_resp

microcode_resp=$(cat /tmp/microcode_resp)
if [ "$microcode_resp" = 1 ]; then
    cd /usr/ports/sysutils/cpu-microcode-amd && make install clean
elif [ "$microcode_resp" = 2 ]; then
    cd /usr/ports/sysutils/cpu-microcode-intel && make install clean
fi

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

# Install 3rd party software.
./software_dialog_ports.sh

# Install BSDstats.
# Function to install a port with progress bar.
install_port_with_progress() {
    local port_name="$1"
    local title="$2"
    dialog --title "$title" --infobox "Installing $port_name..." 5 40
    portmaster --no-confirm "$port_name"
    echo "100"
}

# Install BSDstats
dialog --title "BSDstats Setup" --yesno "Would you like to enable BSDstats?" 8 40
resp=$?

if [ $resp -eq 0 ]; then
    (
        install_port_with_progress "sysutils/bsdstats" "Installing BSDstats"
    ) | dialog --title "Installing BSDstats" --infobox "Installing BSDstats..." 10 50 0

    sysrc bsdstats_enable="YES"
    echo 'monthly_statistics_enable="YES"' >> /etc/periodic.conf
    fi
fi

clear

# Enable SDDM (Simple Desktop Display Manager) on boot.
sysrc sddm_enable="YES"
# Generate SDDM config file.
sddm --example-config > /usr/local/etc/sddm.conf
sed -i '' s/Relogin=false/Relogin=true/g /usr/local/etc/sddm.conf
sed -i '' s/User=/User=$USER/g /usr/local/etc/sddm.conf

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

# Download Konsole colors.
dialog --title "Konsole Colorscheme" --menu "Which Konsole colorscheme do you want?" 12 40 12 \
    1 "Catppuccin" \
    2 "OneHalf-Dark" \
    3 "Ayu Mirage" 2> /tmp/konsole_resp
konsole_resp=$(cat /tmp/konsole_resp)
if [ "$konsole_resp" = 1 ]; then
	wcurl https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-frappe.colorscheme https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-latte.colorscheme https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-macchiato.colorscheme https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme
	mv -v *.colorscheme /usr/local/share/konsole
	chmod 644 /usr/local/share/konsole/*.colorscheme
elif [ "$konsole_resp" = 2 ]; then
	wcurl https://raw.githubusercontent.com/sonph/onehalf/master/konsole/onehalf-dark.colorscheme
	mv -v onehalf-dark.colorscheme /usr/local/share/konsole
	chmod 644 /usr/local/share/konsole/onehalf-dark.colorscheme
elif [ "$konsole_resp" = 3 ]; then
	wcurl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/refs/heads/master/konsole/Ayu%20Mirage.colorscheme -o AyuMirage.colorscheme
	mv -v AyuMirage.colorscheme /usr/local/share/konsole
	chmod 644 /usr/local/share/konsole/AyuMirage.colorscheme
fi

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
cat << EOF >> /usr/local/etc/polkit-1/rules.d/40-wheel-group.rules
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

# Download wallpapers.
./wallpapers.sh
