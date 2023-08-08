#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root! Thanks."
  exit
fi

clear

# Check if dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: dialog not found. Please install dialog first."
  exit 1
fi

# Function to automatically configure rc.conf variables
configure_rc_conf() {
  echo "Configuring rc.conf variables..."

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
  sysrc vboxnet_enable="YES"
  sysrc smartd_enable="YES"
  sysrc dumpdev="NO"
  sysrc apm_enable="YES"
  sysrc defaultroute_delay="0"
  sysrc rcshutdown_timeout="10"

  echo "rc.conf variables configured."
}

# Function to install graphics driver from ports tree
install_graphics_driver() {
  selected_driver=$(dialog --title "Install Graphics Driver" --menu "Select a graphics driver to install from the FreeBSD ports tree:" 12 60 6 \
    1 "x11-drivers/xf86-video-amdgpu" \
    2 "x11-drivers/xf86-video-ati" \
    3 "x11/nvidia-driver" \
    4 "x11-drivers/xf86-video-intel" \
    5 "virtualbox-ose-additions" \
    6 "x11-drivers/xf86-video-vmware" \
    2>&1 >/dev/tty)

  case "$selected_driver" in
    1)
      sysrc kld_list+=amdgpu
      sed -i '' '16s/$/AMDGPU/' /etc/make.conf
      cd /usr/ports/x11-drivers/xf86-video-amdgpu && make install clean
      ;;
    2)
      sysrc kld_list+=radeonkms
      sed -i '' '16s/$/ATI/' /etc/make.conf
      cd /usr/ports/x11-drivers/xf86-video-ati && make install clean
      ;;
    3)
      cd /usr/ports/x11/nvidia-driver && make install clean
      cd /usr/ports/x11/nvidia-xconfig && make install clean
      sysrc kld_list+=nvidia nvidia-modeset
      nvidia-xconfig
      ;;
    4)
      sysrc kld_list+=i915kms
      sed -i '' '16s/$/INTEL/' /etc/make.conf
      cd /usr/ports/x11-drivers/xf86-video-intel && make install clean
      ;;
    5)
      cd /usr/ports/emulators/virtualbox-ose-additions && make install clean
      sed -i '' '16s/$/VMWARE/' /etc/make.conf
      cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean
      service vboxguest enable && service vboxservice enable
      sysrc kldload_vbox="vboxdrv"
      pw groupmod vboxusers -m $USER
      sed -i '' s/hw.acpi.power_button_state=S3/\/g /etc/sysctl.conf
      ;;
    6)
      sed -i '' '16s/$/VMWARE VMMOUSE/' /etc/make.conf
      cd /usr/ports/x11-drivers/xf86-video-vmware && make install clean
      cd /usr/ports/x11-drivers/xf86-input-vmmouse && make install clean
      cd /usr/ports/emulators/open-vm-tools && make install clean
      sed -i '' s/hw.acpi.power_button_state=S3/\/g /etc/sysctl.conf
      service smartd delete
      ;;
    *)
      echo "Invalid choice. No driver installed."
      ;;
  esac
}

# Install graphics driver
install_graphics_driver

# Automatically configure rc.conf variables in the background
configure_rc_conf &

# End of script
