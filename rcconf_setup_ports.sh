#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this script as root! Thanks."
exit
fi

clear

service ntpdate delete
sysrc sendmail_msp_queueenable="NO"
sysrc sendmail_outbound_enable="NO"
sysrc sendmail_submit_enable="NO"
sysrc ntpd_enable="YES"
sysrc ntpd_flags="-g"
sysrc ntpd_sync_on_start="YES"
sysrc powerd_enable="YES"
sysrc inetd_enable="NO"
sysrc icmp_drop_redirect="YES"
sysrc icmp_log_redirect="YES"
sysrc nfs_server_enable="NO"
sysrc nfs_client_enable="NO"
sysrc sshd_enable="NO"
sysrc portmap_enable="NO"
sysrc mixer_enable="YES"
sysrc allscreens_flags="-f vgarom-8x16.fnt"
sysrc keyrate="fast"
sysrc service_delete_empty="YES"
sysrc firewall_enable="YES"
sysrc firewall_type="workstation"
sysrc firewall_quiet="YES"
sysrc firewall_logdeny="YES"
sysrc autoboot="YES"
sysrc rc_fast="YES"
sysrc dbus_enable="YES"
sysrc rc_startmsgs="NO"
sysrc blanktime="1200"
sysrc savecore_enable="NO"
sysrc virecover_enable="NO"
sysrc vboxnet_enable="YES"
sysrc smartd_enable="YES"
sysrc dumpdev="NO"
sysrc apm_enable="YES"
sysrc defaultroute_delay="0"

# Set up DRM kmod support for graphics cards.
cd /usr/ports/graphics/drm-kmod && make install clean

read -p "FreeBSD DRM kmod graphics support has been installed. What kind of graphics card do you have?

1.) AMD GPU
2.) ATI Radeon
3.) NVIDIA
4.) Intel
5.) VirtualBox
6.) VMware
-> " resp

if [ "$resp" = 1 ]; then
sysrc kld_list+=amdgpu
sed -i '' '17s/$/AMDGPU/' /etc/make.conf
fi
#
if [ "$resp" = 2 ]; then
sysrc kld_list+=radeon
sed -i '' '17s/$/ATI/' /etc/make.conf
fi
#
if [ "$resp" = 3 ]; then
cd /usr/ports/x11/nvidia-driver && make install clean
sysrc kld_list+=nvidia nvidia-modeset
fi
#
if [ "$resp" = 4 ]; then
sysrc kld_list+=i915kms
sed -i '' '17s/$/INTEL/' /etc/make.conf
fi
#
if [ "$resp" = 5 ]; then
cd /usr/ports/emulators/virtualbox-ose-additions-legacy && make install clean
cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean
service vboxguest enable ; service vboxservice enable
sed -i '' '17s/$/VMWARE/' /etc/make.conf
pw groupmod vboxusers -m $USER
fi
#
if [ "$resp" = 6 ]; then
cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean
cd /usr/ports/x11-drivers/xf86-input-vmmouse && make install clean
cd /usr/ports/emulators/open-vm-tools && make install clean
sed -i '' '17s/$/VMWARE VMMOUSE/' /etc/make.conf
sysrc powerd_enable="NO"
fi

cd /home/$USER/freebsd-setup-scripts
