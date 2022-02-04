#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this script as root! Thanks."
exit
fi

sysrc sendmail_msp_queueenable="NO"
sysrc sendmail_outbound_enable="NO"
sysrc sendmail_submit_enable="NO"
service ntpdate delete
sysrc ntpd_enable="YES"
sysrc ntpd_flags="-g"
sysrc ntpd_sync_on_start="YES"
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
sysrc cupsd_enable="YES"
sysrc saned_enable="YES"
sysrc blanktime="1200"
sysrc savecore_enable="NO"
sysrc virecover_enable="NO"
sysrc vboxnet_enable="YES"
sysrc smartd_enable="YES"
sysrc dumpdev="NO"
sysrc apm_enable="YES"

# Setup DRM kmod support for graphics cards.
pkg install -y drm-kmod
echo "FreeBSD DRM kmod graphics support has been installed. What kind of graphics card do you have?"
echo "1.) AMD GPU"
echo "2.) ATI Radeon"
echo "3.) NVIDIA"
echo "4.) Intel"
echo "5.) VirtualBox"
echo "6.) VMware"
read number
if [ $number = "1" ] ; then
sysrc kld_list+=amdgpu
fi
#
if [ $number = "2" ] ; then
sysrc kld_list+=radeon
fi
#
if [ $number = "3" ] ; then
pkg install -y nvidia-driver && sysrc kld_list+=nvidia-modeset
fi
#
if [ $number = "4" ] ; then
sysrc kld_list+=i915kms
fi
#
if [ $number = "5" ] ; then
pkg install -y virtualbox-ose-additions xf86-video-vmware && service vboxguest enable && service vboxservice enable
pw groupmod vboxusers -m $USER
fi
#
if [ $number = "6" ] ; then
pkg install -y xf86-video-vmware open-vm-tools
fi
