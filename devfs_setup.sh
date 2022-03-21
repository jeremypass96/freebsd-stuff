#!/bin/sh
# Sets up a devfs.rules/.conf file on FreeBSD for FreeBSD desktop use.
cat << EOF > /etc/devfs.rules
[devfsrules_common=7]
add path 'ad*' mode 0660
add path 'da*' mode 0660
add path 'acd*' mode 0660
add path 'cd*' mode 0660
add path 'mmcsd*' mode 0660
add path 'pass*' mode 0660
add path 'xpt*' mode 0660
add path 'ugen*' mode 0660
add path 'usbctl' mode 0660
add path 'usb*' mode 0660
add path 'lpt*' mode 0660
add path 'ulpt*' mode 0660
add path 'unlpt*' mode 0660
add path 'fd*' mode 0660
add path 'uscan*' mode 0660
add path 'video*' mode 0660
EOF
sysrc devfs_system_ruleset="devfsrules_common"
#
sed -i '' s/"#link	cd0	cdrom/link	cd0	cdrom"/g /etc/devfs.conf
sed -i '' s/"#link	cd0	dvd/link	cd0	dvd"/g /etc/devfs.conf
echo "perm /dev/acd* 0660" >> /etc/devfs.conf
echo "perm /dev/cd* 0660" >> /etc/devfs.conf
echo "perm /dev/pass* 0660" >> /etc/devfs.conf
echo "perm /dev/xpt* 0660" >> /etc/devfs.conf
echo "perm /dev/da* 0660" >> /etc/devfs.conf
echo "perm /dev/uscanner* 0660" >> /etc/devfs.conf
echo "perm /dev/video* 0660" >> /etc/devfs.conf
