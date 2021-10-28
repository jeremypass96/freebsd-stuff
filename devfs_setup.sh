#!/bin/sh
# Sets up a devfs.rules/.conf file on FreeBSD for FreeBSD desktop use. Run this script as root!
cat << EOF >/etc/devfs.rules
[devfsrules_common=7]
add path 'ad*' mode 0660 group operator
add path 'da*' mode 0660 group operator
add path 'acd*' mode 0660 group operator
add path 'cd*' mode 0660 group operator
add path 'mmcsd*' mode 0660 group operator
add path 'pass*' mode 0660 group operator
add path 'xpt*' mode 0660 group operator
add path 'ugen*' mode 0660 group operator
add path 'usbctl' mode 0660 group operator
add path 'usb*' mode 0660 group operator
add path 'lpt*' mode 0660 group operator
add path 'ulpt*' mode 0660 group operator
add path 'unlpt*' mode 0660 group operator
add path 'fd*' mode 0660 group operator
add path 'uscan*' mode 0660 group operator
add path 'video*' mode 0660 group operator
add path 'dvb/*' mode 0660 group operator
EOF
sysrc devfs_system_ruleset="devfsrules_common"
#
sed -i '' s/#link	cd0	cdrom/link	cd0	cdrom/g /etc/devfs.conf
sed -i '' s/#link	cd0	dvd/link	cd0	dvd/g /etc/devfs.conf
echo "own cd0 root:operator" >> /etc/devfs.conf
echo "perm cd0 0660" >> /etc/devfs.conf
echo "own pass0 root:operator" >> /etc/devfs.conf
echo "perm pass0 0660" >> /etc/devfs.conf
echo "own pass1 root:operator" >> /etc/devfs.conf
echo "perm pass1 0660" >> /etc/devfs.conf
echo "own pass2 root:operator" >> /etc/devfs.conf
echo "perm pass2 0660" >> /etc/devfs.conf
echo "own xpt0 root:operator" >> /etc/devfs.conf
echo "perm xpt0 0660" >> /etc/devfs.conf
echo "" >> /etc/devfs.conf
echo "own   /dev/da*    root:operator" >> /etc/devfs.conf
echo "perm  /dev/da*    0660" >> /etc/devfs.conf
