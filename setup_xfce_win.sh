#!/bin/sh
set -e

# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit 1
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

clear

echo "Welcome to the FreeBSD Xfce setup script."
echo "This script will setup Xorg, Xfce, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -rp "Press the Enter key to continue..." resp

clear

# Ask user to choose pkg or ports, with validation
while true; do
  read -rp "Do you plan to install software via pkg (binary packages) or ports (FreeBSD Ports tree)? (pkg/ports): " resp
  resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')

  if [ "$resp" = "pkg" ] || [ "$resp" = "ports" ]; then
    break
  fi

  echo "Invalid input. Please type 'pkg' or 'ports'."
done

if [ "$resp" = pkg ]; then

# Make pkg use sane defaults.
echo "" >> /usr/local/etc/pkg.conf
echo "# Make pkg use sane defaults." >> /usr/local/etc/pkg.conf
echo "DEFAULT_ALWAYS_YES = true" >> /usr/local/etc/pkg.conf
echo "AUTOCLEAN=yes" >> /usr/local/etc/pkg.conf

# Update pkg repo use latest instead of quarterly.
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "pkg+https://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update -f && pkg upgrade

# Printer support.
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

# Enable the Linuxulator.
sysrc linux_enable="YES" && service linux start

clear

# Install packages.
pkg install -y bash sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji xfce xfce4-goodies xfburn skeuos-gtk-themes papirus-icon-theme epdfview catfish galculator xarchiver xfce4-docklike-plugin xfce4-pulseaudio-plugin font-manager qt5ct qt5-style-plugins ulauncher webfonts vim zsh ohmyzsh fastfetch pfetch octopkg lightdm slick-greeter mp4v2 numlockx automount fusefs-simple-mtpfs unix2dos smartmontools ubuntu-font webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf btop colorize freedesktop-sound-theme rkhunter chkrootkit topgrade bat fd-find lsd nerd-fonts wcurl linux-brave

# Fix Linuxulator permissions.
chmod 755 /compat
chmod 755 /compat/linux
chmod 755 /compat/linux/bin
chmod 755 /compat/linux/lib64
chmod 555 /compat/linux/lib64/ld-linux-x86-64.so.2
chmod 751 /compat
chmod 751 /compat/linux

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
else
    dialog --title "BSDstats Skipped" --infobox "Skipping BSDstats installation." 5 30
    sleep 2
fi
fi

if [ "$resp" = ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER="$(sysctl -n hw.ncpu)"/g /etc/make.conf

# Pull in Ports tree with git.
git clone https://git.FreeBSD.org/ports.git /usr/ports
git -C /usr/ports pull

clear

# Printer support.
# Function to install a port with progress bar.
install_port_with_progress() {
    port_name="$1"
    title="$2"
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
            cd /usr/ports/"$port" && make install clean
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

# Enable the Linuxulator.
sysrc linux_enable="YES" && service linux start

# make.conf options for Xfce.
echo "# Xfce Options" >> /etc/make.conf
echo "x11-wm_xfce4_SET=LIGHTDM" >> /etc/make.conf
echo "x11-wm_xfce4_UNSET=GREYBIRD" >> /etc/make.conf

clear

# Install Ports.
cd /usr/ports/shells/bash && make install clean
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/vim && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/fastfetch && make install clean
cd /usr/ports/sysutils/pfetch && make install clean
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
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
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
cd /usr/ports/ftp/wcurl && make install clean
cd /usr/ports/www/linux-brave && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Fix Linuxulator permissions.
chmod 755 /compat
chmod 755 /compat/linux
chmod 755 /compat/linux/bin
chmod 755 /compat/linux/lib64
chmod 555 /compat/linux/lib64/ld-linux-x86-64.so.2
chmod 751 /compat
chmod 751 /compat/linux

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
cd /home/"$logged_in_user"/freebsd-stuff || exit
./rcconf_setup_ports.sh

# Install 3rd party software.
./software_dialog_ports.sh

# Install BSDstats.
# Function to install a port with progress bar.
install_port_with_progress() {
    port_name="$1"
    title="$2"
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
else
    dialog --title "BSDstats Skipped" --infobox "Skipping BSDstats installation." 5 30
    sleep 2
fi
fi

clear

# Setup Xfce Terminal.
mkdir -p /home/"$logged_in_user"/.config/xfce4/terminal
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/terminal
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/terminal/terminalrc /home/"$logged_in_user"/.config/xfce4/terminal/terminalrc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/terminal/terminalrc
mkdir -p /usr/share/skel/dot.config/xfce4/terminal
cp -v /home/"$logged_in_user"/.config/xfce4/terminal/terminalrc /usr/share/skel/dot.config/xfce4/terminal/terminalrc

# Install Xfce Terminal colors.
mkdir -p /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes
mkdir -p /usr/share/skel/dot.config/xfce4/terminal/colorschemes
dialog --title "Xfce Terminal Colorscheme" --menu "Which XFCE Terminal colorscheme do you want?" 10 48 10 \
    1 "Catppuccin" \
    2 "OneHalf-Dark" \
    3 "Ayu Mirage" 2> /tmp/xfceterm_resp
xfceterm_resp=$(cat /tmp/xfceterm_resp)
if [ "$xfceterm_resp" = 1 ]; then
	wcurl https://raw.githubusercontent.com/catppuccin/xfce4-terminal/refs/heads/main/themes/catppuccin-frappe.theme https://raw.githubusercontent.com/catppuccin/xfce4-terminal/refs/heads/main/themes/catppuccin-latte.theme https://raw.githubusercontent.com/catppuccin/xfce4-terminal/refs/heads/main/themes/catppuccin-macchiato.theme https://raw.githubusercontent.com/catppuccin/xfce4-terminal/refs/heads/main/themes/catppuccin-mocha.theme
	mv -v *.theme /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes
	chmod 644 /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/*.theme
    cp -v /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/*.theme /usr/share/skel/dot.config/xfce4/terminal/colorschemes
elif [ "$xfceterm_resp" = 2 ]; then
	wcurl https://raw.githubusercontent.com/sonph/onehalf/master/xfce4-terminal/OneHalfDark.theme
	mv -v OneHalfDark.theme /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes
	chmod 644 /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/OneHalfDark.theme
    cp -v /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/OneHalfDark.theme /usr/share/skel/dot.config/xfce4/terminal/colorschemes
elif [ "$xfceterm_resp" = 3 ]; then
	wcurl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/refs/heads/master/xfce4terminal/Ayu%20Mirage.theme -o AyuMirage.theme
	mv -v AyuMirage.theme /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes
	chmod 644 /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/AyuMirage.theme
    cp -v /home/"$logged_in_user"/.config/xfce4/terminal/colorschemes/AyuMirage.theme /usr/share/skel/dot.config/xfce4/terminal/colorschemes
fi

# Setup shutdown/sleep rules for Xfce.
cat << 'EOF' > /usr/local/etc/polkit-1/rules.d/60-shutdown.rules
polkit.addRule(function (action, subject) {
  if ((action.id == "org.freedesktop.consolekit.system.restart" ||
      action.id == "org.freedesktop.consolekit.system.stop")
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
cat << 'EOF' > /usr/local/etc/polkit-1/rules.d/70-sleep.rules
polkit.addRule(function (action, subject) {
  if (action.id == "org.freedesktop.consolekit.system.suspend"
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
pw group mod operator -m "$logged_in_user"

# Install cursor theme.
dialog --title "Installing Cursor Theme" --infobox "Installing the 'Bibata Modern Ice' cursor theme..." 5 40
fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.gz -o /home/"$USER"/Bibata-Modern-Ice.tar.gz
tar -xvf /home/"$USER"/Bibata-Modern-Ice.tar.gz -C /usr/local/share/icons
rm -rf /home/"$USER"/Bibata-Modern-Ice.tar.gz
dialog --title "Installation Complete" --msgbox "'Bibata Modern Ice' cursor theme has been installed." 8 40

# Setup Xfce preferences.
#####
mkdir -p /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
cp -v /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
#####

#####
mkdir -p /home/"$logged_in_user"/.config/xfce4/panel
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/panel
mkdir -p /usr/share/skel/dot.config/xfce4/panel
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/panel/whiskermenu-8.rc /home/"$logged_in_user"/.config/xfce4/panel/whiskermenu-8.rc
cp -v /home/"$logged_in_user"/.config/xfce4/panel/whiskermenu-8.rc /usr/share/skel/dot.config/xfce4/panel/whiskermenu-8.rc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/panel/whiskermenu-8.rc
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/panel/docklike-7.rc /home/"$logged_in_user"/.config/xfce4/panel/docklike-7.rc
cp -v /home/"$logged_in_user"/.config/xfce4/panel/docklike-7.rc /usr/share/skel/dot.config/xfce4/panel/docklike-7.rc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/panel/docklike-7.rc
#####

#####
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/xfce4/panel/datetime-16.rc /home/"$logged_in_user"/.config/xfce4/panel/datetime-16.rc
cp -v /home/"$logged_in_user"/.config/xfce4/panel/datetime-16.rc /usr/share/skel/dot.config/xfce4/panel/datetime-16.rc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/xfce4/panel/datetime-16.rc
#####

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/'#pam-autologin-service=lightdm-autologin'/'pam-autologin-service=lightdm-autologin'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#allow-user-switching=true'/'allow-user-switching=true'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#greeter-allow-guest=true'/'greeter-allow-guest=false'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#greeter-setup-script='/'greeter-setup-script=numlockx on'/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' "s|#autologin-user=.*|autologin-user=$logged_in_user|" /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/'#autologin-user-timeout=0'/'autologin-user-timeout=0'/g /usr/local/etc/lightdm/lightdm.conf
mkdir -p /usr/local/etc/lightdm/wallpaper
fetch https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate13.0/files/wallpaper/centerFlat_grey-4k.png -o /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
chown root:wheel /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
chmod 755 /usr/local/etc/lightdm/wallpaper/
chmod 644 /usr/local/etc/lightdm/wallpaper/*

# Setup slick greeter.
cat << 'EOF' > /usr/local/etc/lightdm/slick-greeter.conf
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
chmod 644 /usr/local/etc/lightdm/slick-greeter.conf

# Setup qt5ct and fix GTK/QT antialiasing.
mkdir -p /home/"$logged_in_user"/.config/qt5ct
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/qt5ct
mkdir /usr/share/skel/dot.config/qt5ct
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/qt5ct/qt5ct.conf /home/"$logged_in_user"/.config/qt5ct/qt5ct.conf
cp -v /home/"$logged_in_user"/.config/qt5ct/qt5ct.conf /usr/share/skel/dot.config/qt5ct/qt5ct.conf
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/qt5ct/qt5ct.conf
cp -v /home/"$logged_in_user"/freebsd-stuff/Dotfiles/.xinitrc /home/"$logged_in_user"/.xinitrc
cp -v /home/"$logged_in_user"/.xinitrc /usr/share/skel/dot.xinitrc
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.xinitrc

# Hide menu items.
echo "Cleaning menu bloat..."
./cleanup_menu_bloat.sh
cp -v /home/"$logged_in_user"/freebsd-stuff/cleanup_menu_bloat.sh /root/cleanup_menu_bloat
./install_cleanup_hooks.sh

# Fix user's .xinitrc permissions.
chown "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.xinitrc

# Fix user's config directory permissions.
mkdir /home/"$logged_in_user"/.config
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config

# Fix user's local directory permissions.
mkdir /home/"$logged_in_user"/.local
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.local

# Install Ulauncher theme.
mkdir -p /home/"$logged_in_user"/.config/ulauncher/user-themes
git clone https://github.com/SylEleuth/ulauncher-gruvbox /home/"$logged_in_user"/.config/ulauncher/user-themes/gruvbox-ulauncher
chown -R "$logged_in_user":"$logged_in_user" /home/"$logged_in_user"/.config/ulauncher
mkdir -p /usr/share/skel/dot.config/ulauncher/user-themes
cp -r /home/"$logged_in_user"/.config/ulauncher/user-themes/gruvbox-ulauncher /usr/share/skel/dot.config/ulauncher/user-themes/gruvbox-ulauncher
cp -rv /home/"$logged_in_user"/freebsd-stuff/Dotfiles/config/ulauncher/settings.json /usr/share/skel/dot.config/ulauncher/settings.json

# Configure rkhunter (rootkit malware scanner).
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --skip-keypress"' >> /etc/periodic.conf

# Download wallpapers.
./wallpapers.sh