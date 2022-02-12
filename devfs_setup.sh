#!/bin/sh
# Sets up a devfs.rules/.conf file on FreeBSD for FreeBSD desktop use.
cat << EOF >/etc/devfs.rules
[devfsrules_common=7]
add path 'ad*' mode 666
add path 'da*' mode 666
add path 'acd*' mode 666
add path 'cd*' mode 666
add path 'mmcsd*' mode 666
add path 'pass*' mode 666
add path 'xpt*' mode 666
add path 'ugen*' mode 666
add path 'usbctl' mode 666
add path 'usb*' mode 666
add path 'lpt*' mode 666
add path 'ulpt*' mode 666
add path 'unlpt*' mode 666
add path 'fd*' mode 666
add path 'uscan*' mode 666
add path 'video*' mode 666
EOF
sysrc devfs_system_ruleset="devfsrules_common"
#
sed -i '' s/"#link	cd0	cdrom/link	cd0	cdrom"/g /etc/devfs.conf
sed -i '' s/"#link	cd0	dvd/link	cd0	dvd"/g /etc/devfs.conf
echo "perm /dev/acd0 0666" >> /etc/devfs.conf
echo "perm /dev/acd1 0666" >> /etc/devfs.conf
echo "perm /dev/cd0 0666" >> /etc/devfs.conf
echo "perm /dev/cd1 0666" >> /etc/devfs.conf
echo "perm /dev/pass0 0666" >> /etc/devfs.conf
echo "perm /dev/xpt0 0666" >> /etc/devfs.conf
echo "perm /dev/da* 0666" >> /etc/devfs.conf
echo "perm /dev/uscanner0 0666" >> /etc/devfs.conf
echo "perm /dev/video0 0666" >> /etc/devfs.conf
