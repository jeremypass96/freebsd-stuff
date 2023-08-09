#!/bin/sh
# This shell script installs graphics drivers and configures rc.conf variables for desktop use.

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
  sysrc smartd_enable="YES"
  sysrc dumpdev="NO"
  sysrc apm_enable="YES"
  sysrc defaultroute_delay="0"
  sysrc rcshutdown_timeout="10"

  echo "rc.conf variables configured."
}

# Function to install graphics driver based on selection
install_graphics_driver() {
  selected_driver=$(dialog --title "Install Graphics Driver" --menu "Select a graphics driver:" 15 30 6 \
    1 "AMD GPU" \
    2 "ATI Radeon" \
    3 "NVIDIA" \
    4 "Intel" \
    5 "VirtualBox" \
    6 "VMware" \
    2>&1 >/dev/tty)

  case "$selected_driver" in
    1)
      sysrc kld_list+="amdgpu"
      pkg install -y xf86-video-amdgpu
      ;;
    2)
      sysrc kld_list+="radeonkms"
      pkg install -y xf86-video-ati
      ;;
    3)
      pkg install -y nvidia-driver nvidia-xconfig
      sysrc kld_list+="nvidia nvidia-modeset"
      nvidia-xconfig
      ;;
    4)
      sysrc kld_list+="i915kms"
      pkg install -y xf86-video-intel
      ;;
    5)
      pkg install -y virtualbox-ose-additions xf86-video-vmware
      service vboxguest enable && service vboxservice enable
      sysrc kldload_vbox="vboxdrv"
      pw groupmod vboxusers -m $USER
      sed -i '' s/hw.acpi.power_button_state=S3/\#hw.acpi.power_button_state=S3/g /etc/sysctl.conf
      ;;
    6)
      pkg install -y xf86-video-vmware xf86-input-vmmouse open-vm-tools
      sed -i '' s/hw.acpi.power_button_state=S3/\#hw.acpi.power_button_state=S3/g /etc/sysctl.conf
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
