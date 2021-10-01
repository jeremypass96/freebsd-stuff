#!/bin/sh
# This shell script sets up FreeBSD's loader.conf bootloader variables for desktop use. Run this script as root.
echo 'cc_cubic_load="YES"' >> /boot/loader.conf
echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf
echo 'amdsbwd_load="YES"' >> /boot/loader.conf
echo 'amdtemp_load="YES"' >> /boot/loader.conf
echo "loader_delay=0" >> /boot/loader.conf
echo "autoboot_delay=-1" >> /boot/loader.conf
echo 'beastie_disable="YES"' >> /boot/loader.conf
echo 'cpu_microcode_load="YES"' >> /boot/loader.conf
echo 'cpu_microcode_name="/boot/firmware/intel-ucode.bin"' >> /boot/loader.conf
echo 'fusefs_load="YES"' >> /boot/loader.conf
echo 'libiconv_load="YES"' >> /boot/loader.conf
echo 'libmchain_load="YES"' >> /boot/loader.conf
echo 'cd9660_iconv_load="YES"' >> /boot/loader.conf
echo 'msdosfs_iconv_load="YES"' >> /boot/loader.conf
echo "kern.ipc.shmseg=10000" >> /boot/loader.conf
echo "kern.ipc.shmmni=10000" >> /boot/loader.conf
echo "kern.maxproc=100000" >> /boot/loader.conf
echo "#####################################" >> /boot/loader.conf
echo "#### Custom VT Colors - Dracula+ ####" >> /boot/loader.conf
echo "#####################################" >> /boot/loader.conf
echo 'kern.vt.color.0.rgb="#21222c"' >> /boot/loader.conf
echo 'kern.vt.color.1.rgb="#ff5555"' >> /boot/loader.conf
echo 'kern.vt.color.2.rgb="#50fa7b"' >> /boot/loader.conf
echo 'kern.vt.color.3.rgb="#ffcb6b"' >> /boot/loader.conf
echo 'kern.vt.color.4.rgb="#82aaff"' >> /boot/loader.conf
echo 'kern.vt.color.5.rgb="#c792ea"' >> /boot/loader.conf
echo 'kern.vt.color.6.rgb="#8be9fd"' >> /boot/loader.conf
echo 'kern.vt.color.7.rgb="#f8f8f2"' >> /boot/loader.conf
echo 'kern.vt.color.8.rgb="#545454"' >> /boot/loader.conf
echo 'kern.vt.color.9.rgb="#ff6e6e"' >> /boot/loader.conf
echo 'kern.vt.color.10.rgb="#69ff94"' >> /boot/loader.conf
echo 'kern.vt.color.11.rgb="#ffcb6b"' >> /boot/loader.conf
echo 'kern.vt.color.12.rgb="#d6acff"' >> /boot/loader.conf
echo 'kern.vt.color.13.rgb="#ff92df"' >> /boot/loader.conf
echo 'kern.vt.color.14.rgb="#a4ffff"' >> /boot/loader.conf
echo 'kern.vt.color.15.rgb="#f8f8f2"' >> /boot/loader.conf
echo "#####################################" >> /boot/loader.conf

# Setting up microcode CPU updates firmware.
cd /usr/ports/sysutils/devcpu-data && make install clean

# Reboot to apply changes.
reboot
