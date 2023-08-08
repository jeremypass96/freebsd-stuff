#!/bin/sh

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
  dialog --title "Root Privileges Required" --msgbox "Please run this setup script as root via 'su'! Thanks." 10 50
  exit
fi

# Clear the screen
clear

# Welcome message
dialog --title "FreeBSD Post-Install Setup" --msgbox "Welcome to the FreeBSD post-install setup script.\nThis script helps you configure your system and choose a desktop environment." 10 50

# Menu to select a desktop environment
resp=$(dialog --clear --title "Desktop Environment Selection" --menu "Choose a desktop environment:" 15 50 5 \
  1 "MATE" \
  2 "Xfce" \
  3 "Katana (fork of KDE4)" \
  4 "KDE Plasma 5" \
  5 "Basic Xorg (no desktop)" \
  2>&1 >/dev/tty)

case "$resp" in
  1)
    ./setup_mate.sh
    ;;
  2)
    ./setup_xfce.sh
    ;;
  3)
    ./setup_katana.sh
    ;;
  4)
    ./setup_kde.sh
    ;;
  5)
    ./setup_basicxorg.sh
    ;;
esac

# Disable unneeded TTYs and secure the rest. This will make you enter root's password when booting into single user mode, but you can't login as root when booted into normal user mode.
sed -i '' s/ttyu0/#ttyu0/g /etc/ttys
sed -i '' s/ttyu1/#ttyu1/g /etc/ttys
sed -i '' s/ttyu2/#ttyu2/g /etc/ttys
sed -i '' s/ttyu3/#ttyu3/g /etc/ttys
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
echo "procfs			/proc       procfs  rw  	0   0" >> /etc/fstab

# Change umask from 022 to 077. More secure.
sed -i '' '50s/022/077'/g /etc/login.conf
cap_mkdb /etc/login.conf

# Make system files read-only to non-privileged users.
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
chmod 700 /root
chmod o= /var/log

# Prevent viewing/access of user's home directory by other users.
chmod 700 /home/$USER

# Enable process accounting.
sysrc accounting_enable="YES" && service accounting start

# Configure S.M.A.R.T. disk monitoring daemon.
cp /usr/local/etc/smartd.conf.sample /usr/local/etc/smartd.conf
echo "/dev/ada0 -H -l error -f" >> /usr/local/etc/smartd.conf
echo 'daily_status_smart_devices="/dev/ada0"' >> /etc/periodic.conf

# Setup automoumt.
cat << EOF > /usr/local/etc/automount.conf
USERUMOUNT=YES
NICENAMES=YES
NOTIFY=YES
ATIME=NO
EOF

# Install the Poppins font.
fetch https://fonts.google.com/download?family=Poppins -o /home/$USER/Poppins.zip
unzip -d /usr/local/share/fonts/Poppins -x OFL.txt /home/$USER/Poppins.zip
rm /home/$USER/Poppins.zip

# Install the Source Sans 3 font.
fetch https://fonts.google.com/download\?family\=Source+Sans+3 -o /home/$USER/Source_Sans_3.zip
unzip -d /usr/local/share/fonts/SourceSansPro -x README.txt -x OFL.txt -x SourceSans3-VariableFont_wght.ttf -x SourceSans3-Italic-VariableFont_wght.ttf /home/$USER/Source_Sans_3.zip
rm /home/$USER/Source_Sans_3.zip

# Fix font rendering.
ln -s /usr/local/etc/fonts/conf.avail/11-lcdfilter-default.conf /usr/local/etc/fonts/conf.d/
ln -s /usr/local/etc/fonts/conf.avail/10-sub-pixel-rgb.conf /usr/local/etc/fonts/conf.d/

# Fix micro truecolor support.
echo "# Micro truecolor support." >> /root/.profile
echo "MICRO_TRUECOLOR=1;	export MICRO_TRUECOLOR" >> /root/.profile

# Cleanup boot process/adjust ZFS options for desktop useage.
sed -i '' s/'*.err;kern.warning;auth.notice;mail.crit'/'# *.err;kern.warning;auth.notice;mail.crit'/g /etc/syslog.conf
sed -i '' s/"check_startmsgs \&& echo 'ELF ldconfig path:' \${_LDC}"/"check_startmsgs \&\& echo 'ELF ldconfig path:' \${_LDC} 1> \/dev\/null"/g /etc/rc.d/ldconfig
sed -i '' s/"echo '32-bit compatibility ldconfig path:' \${_LDC}"/"echo '32-bit compatibility ldconfig path:' \${_LDC} 1> \/dev\/null"/g /etc/rc.d/ldconfig
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
read -p "Did you install FreeBSD with the ZFS filesystem? (y/n) " resp
if [ "$resp" = y ]; then
sed -i '' s/'zpool import -c \$cachefile -a -N \&& break'/'zpool import -c \$cachefile -a -N 1> \/dev\/null 2> \/dev\/null \&\& break'/g /etc/rc.d/zpool
# Adjust ZFS ARC cache size.
echo "" >> /boot/loader.conf
echo "# Adjust ZFS ARC cache size." >> /boot/loader.conf
echo 'vfs.zfs.arc_max="512M"' >> /boot/loader.conf
echo "" >> /boot/loader.conf
# Turn off atime. Reduces disk writes/wear.
zfs set atime=off zroot
fi
if [ "$resp" = n ]; then
continue
fi

# Make login quieter.
touch /home/$USER/.hushlogin
chown $USER /home/$USER/.hushlogin
touch /usr/share/skel/dot.hushlogin

# Setup system files for desktop use.
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh
./freebsd_symlinks.sh
./dotfiles_setup.sh

# Setup user's home directory with common folders.
xdg-user-dirs-update

# Update FreeBSD base.
PAGER=cat freebsd-update fetch install

# Set mixer levels.
mixer vol 100
mixer pcm 100

# Display final completion message
dialog --title "Setup Complete" --msgbox "Post-install setup is complete. Your system is now configured." 10 50
