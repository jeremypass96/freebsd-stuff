#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
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
sysrc ntpd_oomprotect="YES"
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
sysrc rc_startmsgs="NO"
sysrc background_dhclient="YES"
sysrc dbus_enable="YES"
sysrc blanktime="1200"
sysrc savecore_enable="NO"
sysrc virecover_enable="NO"
sysrc smartd_enable="YES"
sysrc dumpdev="NO"
sysrc apm_enable="YES"
sysrc defaultroute_delay="0"
sysrc rcshutdown_timeout="10"

# Setup DRM kmod support for graphics cards.
pkg install -y drm-kmod

clear

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
pkg install -y xf86-video-amdgpu
fi
#
if [ "$resp" = 2 ]; then
sysrc kld_list+=radeonkms
pkg install -y xf86-video-ati
fi
#
if [ "$resp" = 3 ]; then
pkg install -y nvidia-driver nvidia-xconfig
sysrc kld_list+=nvidia nvidia-modeset
fi
#
if [ "$resp" = 4 ]; then
sysrc kld_list+=i915kms
pkg install -y xf86-video-intel
fi
#
if [ "$resp" = 5 ]; then
pkg install -y virtualbox-ose-additions xf86-video-vmware
service vboxguest enable && service vboxservice enable
sysrc kldload_vbox="vboxdrv"
pw groupmod vboxusers -m $USER
fi
#
if [ "$resp" = 6 ]; then
pkg install -y xf86-video-vmware xf86-input-vmmouse open-vm-tools
sysrc powerd_enable="NO"
sysrc smartd_enable="NO"
fi
