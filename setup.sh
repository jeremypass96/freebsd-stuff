#!/bin/sh

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD post-install setup script. This script simply asks you what desktop environment you want to use.
After you select your desktop environment, this script will launch your specified desktop's setup script."
echo ""
read -p "Which desktop environment do you want to use? Please enter it's corresponding number.
1.) MATE
2.) Xfce
3.) Katana (fork of KDE4)
4.) KDE Plasma 5
5.) LXQT
-> " resp
if [ "$resp" = 1 ]; then
./setup_mate.sh
fi
if [ "$resp" = 2 ]; then
./setup_xfce.sh
fi
if [ "$resp" = 3 ]; then
./setup_katana.sh
fi
if [ "$resp" = 4 ]; then
./setup_kde.sh
fi
if [ "$resp" = 5 ]; then
./setup_lxqt.sh
fi

# Disable unneeded TTYs and secure the rest. This will make you enter root's password when booting into single user mode, but you can't login as root when booted into normal user mode.
sed -i '' s/ttyu0/#ttyu0/g /etc/ttys
sed -i '' s/ttyu1/#ttyu1/g /etc/ttys
sed -i '' s/ttyu2/#ttyu2/g /etc/ttys
sed -i '' s/ttyu3/#ttyu3/g /etc/ttys
sed -i '' s/dcons/#dcons/g /etc/ttys
sed -i 'ttyv*' s/secure/insecure/g /etc/ttys

# Add /proc filesystem to /etc/fstab.
echo "procfs			/proc       procfs  rw  	0   0" >> /etc/fstab

# Setup system files for desktop use.
./sysctl_setup.sh
./bootloader_setup.sh
./devfs_setup.sh
./freebsd_symlinks.sh
./dotfiles_setup.sh

# Configure S.M.A.R.T. disk monitoring daemon.
cp /usr/local/etc/smartd.conf.sample /usr/local/etc/smartd.conf
echo "/dev/ada0 -H -l error -f" >> /usr/local/etc/smartd.conf

# Setup automoumt.
cat << EOF > /usr/local/etc/automount.conf
USERUMOUNT=YES
NICENAMES=YES
NOTIFY=YES
ATIME=NO
EOF

# Install the Poppins font.
fetch https://fonts.google.com/download?family=Poppins -o Poppins.zip
unzip Poppins.zip -d /usr/local/share/fonts/Poppins
rm Poppins.zip

# Fix font rendering.
ln -s /usr/local/etc/fonts/conf.avail/11-lcdfilter-default.conf /usr/local/etc/fonts/conf.d/
ln -s /usr/local/etc/fonts/conf.avail/10-sub-pixel-rgb.conf /usr/local/etc/fonts/conf.d/

# Cleanup boot process.
grep -n -E '(1|2)> /dev/null' /etc/rc.d/* | grep -E 'routing|netif|ldconfig'
grep -n -A 8 'random_start()' /etc/rc.d/random
sed -i '' s/'echo "Autoloading module: ${m}"'/'# echo "Autoloading module: ${m}"'/g /etc/rc.d/devmatch
sed -i '' s/'*.err;kern.warning;auth.notice;mail.crit'/'# *.err;kern.warning;auth.notice;mail.crit'/g /etc/syslog.conf
sed -i '' s/'run_rc_script ${_rc_elem} ${_boot}'/'run_rc_script ${_rc_elem} ${_boot} > \/dev\/null/'g /etc/rc
sed -i '' s/'zpool import -c \$cachefile -a -N \&& break'/'zpool import -c \$cachefile -a -N 1> \/dev\/null 2> \/dev\/null \&\& break'/g /etc/rc.d/zpool

# Setup user's home directory with common folders.
xdg-user-dirs-update

# Update FreeBSD base.
freebsd-update fetch install

# Reboot in 5 seconds.
shutdown -r +5s
