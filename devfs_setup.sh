#!/bin/sh
# Sets up a devfs.rules/.conf file on FreeBSD for FreeBSD desktop use.

# Write the devfs.rules file
cat <<'EOF' >/etc/devfs.rules
[devfsrules_common=7]
add path 'acd[0-9]*' mode 0666
add path 'ad[0-9]*' mode 0666
add path 'ada[0-9]*' mode 0666
add path 'cd[0-9]*' mode 0666
add path 'cx23885*' mode 0666
add path 'cx88*' mode 0666
add path 'da[0-9]*' mode 0666
add path 'dri/*' mode 0666
add path 'drm/*' mode 0666
add path 'dvb/*' mode 0666
add path 'fd[0-9]*' mode 0666
add path 'iicdev*' mode 0666
add path 'lpt[0-9]*' mode 0666
add path 'mmcsd[0-9]*' mode 0666
add path 'pass[0-9]*' mode 0666
add path 'tuner[0-9]*' mode 0666
add path 'ugen[0-9]*' mode 0666
add path 'ulpt[0-9]*' mode 0666
add path 'unlpt[0-9]*' mode 0666
add path 'usb/*' mode 0666
add path 'usbctl' mode 0666
add path 'uscan[0-9]*' mode 0666
add path 'uvisor[0-9]*' mode 0666
add path 'video[0-9]*' mode 0666
add path 'xpt[0-9]*' mode 0666
EOF

# Configure devfs_system_ruleset
sysrc devfs_system_ruleset="devfsrules_common"

# Update devfs.conf
sed -i '' -e 's/#link/link/g' /etc/devfs.conf
grep -q '# Allow all users to access CD/DVD drives.' /etc/devfs.conf || tee -a /etc/devfs.conf >/dev/null <<EOF
# Allow all users to access CD/DVD drives.
perm /dev/acd* 0666
perm /dev/cd* 0666
EOF

# Allow all users to access USB devices
grep -q '# Allow all users to access USB devices.' /etc/devfs.conf || tee -a /etc/devfs.conf >/dev/null <<EOF
# Allow all users to access USB devices.
perm /dev/da* 0666
EOF

# Misc. other devices
grep -q '# Misc. other devices.' /etc/devfs.conf || tee -a /etc/devfs.conf >/dev/null <<EOF
# Misc. other devices.
perm /dev/pass* 0666
perm /dev/xpt0 0666
perm /dev/uscanner* 0666
perm /dev/video* 0666
perm /dev/tuner0 0666
perm /dev/dvb/adapter0/demux0 0666
perm /dev/dvb/adapter0/dvr 0666
perm /dev/dvb/adapter0/frontend0 0666
EOF

service devfs restart

# Allow users to mount and unmount CD/DVD-ROM drives.
echo "/dev/cd0   /cdrom   cd9660   ro,noauto,user   0   0" >>/etc/fstab
EOF
