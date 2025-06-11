#!/bin/sh
set -e

# Colors
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error:${RESET} ${YELLOW}Please run this setup script as root via 'su'! Thanks.${RESET}"
  exit 1
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

# Clear the screen
clear

# Welcome message
dialog --title "FreeBSD Post-Install Setup" --msgbox "Welcome to the FreeBSD post-install setup script.\n\nThis script helps you configure your system and choose a desktop environment." 8 85

# Menu to select a desktop environment
resp=$(dialog --clear --title "Desktop Environment Selection" --menu "Choose a desktop environment:" 15 40 5 \
  1 "MATE" \
  2 "Xfce" \
  3 "Xfce (Windows-esque)" \
  4 "Katana (fork of KDE4)" \
  5 "KDE Plasma 5" \
  6 "Basic Xorg (no desktop)" \
  2>&1 >/dev/tty)

case "$resp" in
  1)
    ./setup_mate.sh
    ;;
  2)
    ./setup_xfce.sh
    ;;
  3)
    ./setup_xfce_win.sh
    ;;
  4)
    ./setup_katana.sh
    ;;
  5)
    ./setup_kde.sh
    ;;
  6)
    ./setup_basicxorg.sh
    ;;
esac

# Disable unneeded TTYs and secure the rest. This will make you enter root's password when booting into single user mode, but you can't login as root when booted into normal user mode.
echo -e "${CYAN}Configuring TTYs and security settings...${RESET}"
cp /etc/ttys /etc/ttys.bak
for tty in ttyu0 ttyu1 ttyu2 ttyu3; do
  sed -i '' "s/^$tty/#$tty/" /etc/ttys
done
sed -i '' s/dcons/#dcons/g /etc/ttys
sed -i '' s/xc0/#xc0/g /etc/ttys
sed -i '' s/rcons/#rcons/g /etc/ttys
sed -i '' '32s/secure/insecure'/g /etc/ttys
sed -i '' '34s/secure/insecure'/g /etc/ttys
sed -i '' '35s/secure/insecure'/g /etc/ttys
sed -i '' '36s/secure/insecure'/g /etc/ttys
sed -i '' '37s/secure/insecure'/g /etc/ttys
sed -i '' '38s/secure/insecure'/g /etc/ttys
sed -i '' '39s/secure/insecure'/g /etc/ttys
sed -i '' '40s/secure/insecure'/g /etc/ttys
sed -i '' '41s/secure/insecure'/g /etc/ttys
sed -i '' '44s/secure/insecure'/g /etc/ttys
sed -i '' '45s/secure/insecure'/g /etc/ttys
sed -i '' '46s/secure/insecure'/g /etc/ttys
sed -i '' '47s/secure/insecure'/g /etc/ttys
sed -i '' '49s/secure/insecure'/g /etc/ttys
sed -i '' '51s/secure/insecure'/g /etc/ttys
sed -i '' '53s/secure/insecure'/g /etc/ttys

# Add /proc filesystem to /etc/fstab.
echo -e "${CYAN}Adding /proc filesystem to /etc/fstab...${RESET}"
echo "procfs			/proc       procfs  rw  	0   0" >> /etc/fstab

# Change umask from 022 to 077. More secure.
echo -e "${CYAN}Changing umask to 077 for better security...${RESET}"
sed -i '' '50s/022/077'/g /etc/login.conf
cap_mkdb /etc/login.conf

# Make system files read-only to non-privileged users.
echo -e "${CYAN}Setting system files to read-only...${RESET}"
chmod o= /etc/fstab
chmod o= /etc/ftpusers
chmod o= /etc/group
chmod o= /etc/hosts
chmod o= /etc/hosts.allow
chmod o= /etc/hosts.equiv
chmod o= /etc/hosts.lpd
chmod o= /etc/inetd.conf
chmod o= /etc/login.access
chmod o= /etc/login.conf
chmod o= /etc/newsyslog.conf
chmod o= /etc/rc.conf
chmod o= /etc/sysctl.conf
chmod o= /etc/ttys
chmod o= /etc/crontab
chmod o= /etc/motd
chmod o= /etc/ssh/sshd_config
chmod o= /etc/cron.d

# Prevent viewing of the root directory and log file directory by non-privileged users.
echo -e "${CYAN}Securing root and log file directories...${RESET}"
chmod 700 /root
chmod o= /var/log

# Prevent viewing/access of user's home directory by other users.
echo -e "${CYAN}Securing user's home directory...${RESET}"
chmod 700 /home/"$logged_in_user"

# Enable process accounting.
echo -e "${CYAN}Enabling process accounting...${RESET}"
sysrc accounting_enable="YES" && service accounting start

# Configure S.M.A.R.T. disk monitoring daemon.
echo -e "${CYAN}Configuring S.M.A.R.T. disk monitoring...${RESET}"
cp /usr/local/etc/smartd.conf.sample /usr/local/etc/smartd.conf
echo "/dev/ada0 -H -l error -f" >> /usr/local/etc/smartd.conf
echo 'daily_status_smart_devices="/dev/ada0"' >> /etc/periodic.conf

# Setup automoumt.
echo -e "${CYAN}Setting up automount...${RESET}"
cat << 'EOF' > /usr/local/etc/automount.conf
USERUMOUNT=YES
NICENAMES=YES
NOTIFY=YES
ATIME=NO
EOF

echo -e "${CYAN}Installing fonts...${RESET}"
# Install the Poppins font.
mkdir -p /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Black.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-BlackItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-BoldItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-ExtraBold.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-ExtraBoldItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-ExtraLight.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-ExtraLightItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Italic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Light.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-LightItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-MediumItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBold.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-SemiBoldItalic.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Thin.ttf -P /usr/local/share/fonts/Poppins
wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-ThinItalic.ttf -P /usr/local/share/fonts/Poppins
chmod 755 /usr/local/share/fonts/Poppins/
chmod 644 /usr/local/share/fonts/Poppins/*

# Install the Source Sans 3 font.
mkdir -p /usr/local/share/fonts/SourceSans3
wget https://github.com/google/fonts/raw/main/ofl/sourcesans3/SourceSans3%5Bwght%5D.ttf -P /usr/local/share/fonts/SourceSans3
wget https://github.com/google/fonts/raw/main/ofl/sourcesans3/SourceSans3-Italic%5Bwght%5D.ttf -P /usr/local/share/fonts/SourceSans3
chmod 755 /usr/local/share/fonts/SourceSans3
chmod 644 /usr/local/share/fonts/SourceSans3/*

# Fix font rendering.
echo -e "${CYAN}Fixing font rendering...${RESET}"
ln -s /usr/local/etc/fonts/conf.avail/11-lcdfilter-default.conf /usr/local/etc/fonts/conf.d/
ln -s /usr/local/etc/fonts/conf.avail/10-sub-pixel-rgb.conf /usr/local/etc/fonts/conf.d/

# Re-gererate font cache.
fc-cache -fv

# Fix micro truecolor support.
echo -e "${CYAN}Enabling micro truecolor support...${RESET}"
echo "# Micro truecolor support." >> /root/.profile
echo "MICRO_TRUECOLOR=1;	export MICRO_TRUECOLOR" >> /root/.profile

# Cleanup boot process/adjust ZFS options for desktop useage.
echo -e "${CYAN}Cleaning up boot process and adjusting ZFS options for desktop useage...${RESET}"
sed -i '' s/'*.err;kern.warning;auth.notice;mail.crit'/'# *.err;kern.warning;auth.notice;mail.crit'/g /etc/syslog.conf
sed -i '' s/"startmsg 'ELF ldconfig path:' \${_LDC}"/"startmsg 'ELF ldconfig path:' \${_LDC} 1> \/dev\/null"/g /etc/rc.d/ldconfig
sed -i '' s/"startmsg '32-bit compatibility ldconfig path:' \${_LDC}"/"startmsg '32-bit compatibility ldconfig path:' \${_LDC} 1> \/dev\/null"/g /etc/rc.d/ldconfig
sed -i '' s/'ifconfig \${ifn}'/'ifconfig \${ifn} 1> \/dev\/null 2> \/dev\/null'/g /etc/rc.d/netif
sed -i '' s/'rpc.umntall -k'/'rpc.umntall -k 2> \/dev\/null'/g /etc/rc.d/nfsclient
sed -i '' s/'if \[ \${harvest_mask} -gt 0 ]; then'/'# if \[ \${harvest_mask} -gt 0 ]; then'/g /etc/rc.d/random
sed -i '' s/"echo -n 'Setting up harvesting: '"/"# echo -n 'Setting up harvesting: '"/g /etc/rc.d/random
sed -i '' s/'\${SYSCTL} kern.random.harvest.mask=\${harvest_mask} > \/dev\/null'/'# \${SYSCTL} kern.random.harvest.mask=\${harvest_mask} > \/dev\/null'/g /etc/rc.d/random
sed -i '' s/'\${SYSCTL_N} kern.random.harvest.mask_symbolic'/'# \${SYSCTL_N} kern.random.harvest.mask_symbolic'/g /etc/rc.d/random
sed -i '' 54s/'fi'/'# fi'/g /etc/rc.d/random
sed -i '' s/'eval static_\${_a} delete \$_if'/'eval static_\${_a} delete \$_if 1> \/dev\/null 2> \/dev\/null'/g /etc/rc.d/routing
sed -i '' 97s/'static_\$2 add \$3'/'static_\$2 add \$3 1> \/dev\/null 2> \/dev\/null'/g /etc/rc.d/routing
sed -i '' 104s/'static_\$2 add \$3'/'static_\$2 add \$3 add \$3 1> \/dev\/null 2> \/dev\/null'/g /etc/rc.d/routing
sed -i '' s/"echo -n 'Feeding entropy: '"/"echo -n 'Feeding entropy:'"/g /etc/rc.d/random
grep -n -E '(1|2)> /dev/null' /etc/rc.d/* | grep -E 'routing|netif|ldconfig'
grep -n -A 8 'random_start()' /etc/rc.d/random
read -rp "Did you install FreeBSD with the ZFS filesystem? (Y/n) " resp
resp=${resp:-Y}
if [ "$resp" = Y ] || [ "$resp" = y ]; then
  sed -i '' s/'zpool import -c \$cachefile -a -N \&& break'/'zpool import -c \$cachefile -a -N 1> \/dev\/null 2> \/dev\/null \&\& break'/g /etc/rc.d/zpool
  # Adjust ZFS ARC cache size.
  echo "" >> /boot/loader.conf
  echo "# Adjust ZFS ARC cache size." >> /boot/loader.conf
  echo 'vfs.zfs.arc_max="512M"' >> /boot/loader.conf
  echo "" >> /boot/loader.conf
  # Turn off atime. Reduces disk writes/wear.
  zfs set atime=off zroot
fi

# Make login quieter.
echo -e "${CYAN}Making login quieter...${RESET}"
touch /home/"$logged_in_user"/.hushlogin
chown "$logged_in_user" /home/"$logged_in_user"/.hushlogin
touch /usr/share/skel/dot.hushlogin

# Setup system files for desktop use.
echo -e "${CYAN}Setting up system files for desktop use...${RESET}"
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh
./freebsd_symlinks.sh
./dotfiles_setup.sh
./locale_fix.sh

# Setup user's home directory with common folders.
echo -e "${CYAN}Setting up user's home directory...${RESET}"
xdg-user-dirs-update

# Update FreeBSD base.
echo -e "${CYAN}Updating FreeBSD base...${RESET}"
PAGER=$(cat freebsd-update fetch install)

# Set mixer levels.
echo -e "${CYAN}Setting volume mixer levels...${RESET}"
mixer vol.volume=100
mixer pcm.volume=100

# Make "line in" the default recording source.
echo -e "${CYAN}Setting default recording source...${RESET}"
mixer line.recsrc=+

# Change MOTD.
cat <<EOF > /etc/motd
Welcome to \033[1;31mBeastieBox\033[0m!
Running FreeBSD like a boss since $(date +%m/%d/%Y).
Don't fear the daemon, be the daemon. 😈
EOF

# Display final completion message
dialog --title "Setup Complete" --msgbox "Post-install setup is complete. Your system is now configured." 5 70