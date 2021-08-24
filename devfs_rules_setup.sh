#!/bin/sh
# Sets up a devfs.rules file on FreeBSD for FreeBSD desktop use. Run this script as root!
echo "[devfsrules_common=7]" > /etc/devfs.rules
echo "add path 'ad*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'da*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'acd*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'cd*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'mmcsd*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'pass*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'xpt*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'ugen*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'usbctl' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'usb*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'lpt*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'ulpt*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'unlpt*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'fd*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'uscan*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'video*' mode 0666 group operator" >> /etc/devfs.rules
echo "add path 'dvb/*' mode 0666 group operator" >> /etc/devfs.rules
echo 'devfs_system_ruleset="devfsrules_common"' >> /etc/rc.conf
# Install automount via ports.
cd /usr/ports/sysutils/automount
make install clean ; cd
service devd enable
service devd restart
