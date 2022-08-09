#!/bin/sh
# Sets up a devfs.rules/.conf file on FreeBSD for FreeBSD desktop use.
cat << EOF > /etc/devfs.rules
[devfsrules_common=7]
add path 'ad*'	mode 666
add path 'ada*'	mode 666
add path 'da*'	mode 666
add path 'acd*'	mode 666
add path 'cd*'	mode 666
add path 'mmcsd*'	mode 666
add path 'pass*'	mode 666
add path 'xpt0'		mode 666
add path 'ugen*'	mode 666
add path 'usbctl'	mode 666
add path 'usb/\*'	mode 666
add path 'lpt*'	mode 666
add path 'ulpt*'	mode 666
add path 'unlpt*'	mode 666
add path 'fd*'	mode 666
add path 'uscan*'	mode 666
add path 'video*'	mode 666
add path 'tuner*'  mode 666
add path 'dvb/\*'		mode 666
add path 'cx88*' 		mode 0660
add path 'iicdev*' 		mode 0660
add path 'uvisor[0-9]*' mode 0660
EOF
sysrc devfs_system_ruleset="devfsrules_common"
#
sed -i '' s/"#link cd0 cdrom/link	cd0	cdrom"/g /etc/devfs.conf
sed -i '' s/"#link cd0 dvd/link	cd0	dvd"/g /etc/devfs.conf
#
echo "# Allow all users to access CD/DVD drives" >> /etc/devfs.conf
echo "perm 	/dev/acd* 					0666" >> /etc/devfs.conf
echo "perm 	/dev/cd* 					0666" >> /etc/devfs.conf

echo "# Allow all users to access USB devices" >> /etc/devfs.conf
echo "perm 	/dev/da* 					0666" >> /etc/devfs.conf

echo "# Misc. other devices" >> /etc/devfs.conf
echo "perm 	/dev/pass* 					0666" >> /etc/devfs.conf
echo "perm 	/dev/xpt0 					0666" >> /etc/devfs.conf
echo "perm 	/dev/uscanner* 				0666" >> /etc/devfs.conf
echo "perm 	/dev/video* 				0666" >> /etc/devfs.conf
echo "perm 	/dev/tuner0 				0666" >> /etc/devfs.conf
echo "perm    /dev/dvb/adapter0/demux0    	0666" >> /etc/devfs.conf
echo "perm    /dev/dvb/adapter0/dvr       	0666" >> /etc/devfs.conf
echo "perm    /dev/dvb/adapter0/frontend0 	0666" >> /etc/devfs.conf
