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
  echo ""

  # Function to add color output for "YES" or "NO" values
  add_color_output() {
    local value=$1
    if [ "$value" = "YES" ]; then
      echo -e "\033[32m$1\033[0m"  # Green
    elif [ "$value" = "NO" ]; then
      echo -e "\033[31m$1\033[0m"  # Red
    else
      echo "$1"  # Default color (no color change)
    fi
  }

  sendmail_msp_queueenable=$(sysrc -n sendmail_msp_queueenable)
  echo -n "sendmail_msp_queueenable: "; add_color_output "$sendmail_msp_queueenable"
  sendmail_outbound_enable=$(sysrc -n sendmail_outbound_enable)
  echo -n "sendmail_outbound_enable: "; add_color_output "$sendmail_outbound_enable"
  sendmail_submit_enable=$(sysrc -n sendmail_submit_enable)
  echo -n "sendmail_submit_enable: "; add_color_output "$sendmail_submit_enable"
  ntpd_enable=$(sysrc -n ntpd_enable)
  echo -n "ntpd_enable: "; add_color_output "$ntpd_enable"
  ntpd_flags=$(sysrc -n ntpd_flags)
  echo -n "ntpd_flags: "; add_color_output "$ntpd_flags"
  ntpd_sync_on_start=$(sysrc -n ntpd_sync_on_start)
  echo -n "ntpd_sync_on_start: "; add_color_output "$ntpd_sync_on_start"
  ntpd_oomprotect=$(sysrc -n ntpd_oomprotect)
  echo -n "ntpd_oomprotect: "; add_color_output "$ntpd_oomprotect"
  inetd_enable=$(sysrc -n inetd_enable)
  echo -n "inetd_enable: "; add_color_output "$inetd_enable"
  icmp_drop_redirect=$(sysrc -n icmp_drop_redirect)
  echo -n "icmp_drop_redirect: "; add_color_output "$icmp_drop_redirect"
  icmp_log_redirect=$(sysrc -n icmp_log_redirect)
  echo -n "icmp_log_redirect: "; add_color_output "$icmp_log_redirect"
  nfs_server_enable=$(sysrc -n nfs_server_enable)
  echo -n "nfs_server_enable: "; add_color_output "$nfs_server_enable"
  nfs_client_enable=$(sysrc -n nfs_client_enable)
  echo -n "nfs_client_enable: "; add_color_output "$nfs_client_enable"
  sshd_enable=$(sysrc -n sshd_enable)
  echo -n "sshd_enable: "; add_color_output "$sshd_enable"
  portmap_enable=$(sysrc -n portmap_enable)
  echo -n "portmap_enable: "; add_color_output "$portmap_enable"
  mixer_enable=$(sysrc -n mixer_enable)
  echo -n "mixer_enable: "; add_color_output "$mixer_enable"
  allscreens_flags=$(sysrc -n allscreens_flags)
  echo -n "allscreens_flags: "; add_color_output "$allscreens_flags"
  keyrate=$(sysrc -n keyrate)
  echo -n "keyrate: "; add_color_output "$keyrate"
  service_delete_empty=$(sysrc -n service_delete_empty)
  echo -n "service_delete_empty: "; add_color_output "$service_delete_empty"
  firewall_enable=$(sysrc -n firewall_enable)
  echo -n "firewall_enable: "; add_color_output "$firewall_enable"
  firewall_type=$(sysrc -n firewall_type)
  echo -n "firewall_type: "; add_color_output "$firewall_type"
  firewall_quiet=$(sysrc -n firewall_quiet)
  echo -n "firewall_quiet: "; add_color_output "$firewall_quiet"
  firewall_logdeny=$(sysrc -n firewall_logdeny)
  echo -n "firewall_logdeny: "; add_color_output "$firewall_logdeny"
  autoboot=$(sysrc -n autoboot)
  echo -n "autoboot: "; add_color_output "$autoboot"
  rc_fast=$(sysrc -n rc_fast)
  echo -n "rc_fast: "; add_color_output "$rc_fast"
  rc_startmsgs=$(sysrc -n rc_startmsgs)
  echo -n "rc_startmsgs: "; add_color_output "$rc_startmsgs"
  background_dhclient=$(sysrc -n background_dhclient)
  echo -n "background_dhclient: "; add_color_output "$background_dhclient"
  dbus_enable=$(sysrc -n dbus_enable)
  echo -n "dbus_enable: "; add_color_output "$dbus_enable"
  blanktime=$(sysrc -n blanktime)
  echo -n "blanktime: "; add_color_output "$blanktime"
  savecore_enable=$(sysrc -n savecore_enable)
  echo -n "savecore_enable: "; add_color_output "$savecore_enable"
  virecover_enable=$(sysrc -n virecover_enable)
  echo -n "virecover_enable: "; add_color_output "$virecover_enable"
  smartd_enable=$(sysrc -n smartd_enable)
  echo -n "smartd_enable: "; add_color_output "$smartd_enable"
  dumpdev=$(sysrc -n dumpdev)
  echo -n "dumpdev: "; add_color_output "$dumpdev"
  apm_enable=$(sysrc -n apm_enable)
  echo -n "apm_enable: "; add_color_output "$apm_enable"
  defaultroute_delay=$(sysrc -n defaultroute_delay)
  echo -n "defaultroute_delay: "; add_color_output "$defaultroute_delay"
  rcshutdown_timeout=$(sysrc -n rcshutdown_timeout)
  echo -n "rcshutdown_timeout: "; add_color_output "$rcshutdown_timeout"

  echo ""
  echo "rc.conf variables configured."
}

# Function to install graphics driver from ports tree
install_graphics_driver() {
  selected_driver=$(dialog --title "Install Graphics Driver" --menu "Select a graphics driver to install from the FreeBSD ports tree:" 15 45 6 \
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

# Automatically configure rc.conf variables
clear & configure_rc_conf

# End of script
