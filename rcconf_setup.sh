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

  # Set and display sendmail_msp_queueenable
  sendmail_msp_queueenable="NO"
  sysrc sendmail_msp_queueenable="$sendmail_msp_queueenable"
  echo -n "sendmail_msp_queueenable: "; add_color_output "$sendmail_msp_queueenable"
  # Set and display sendmail_outbound_enable
  sendmail_outbound_enable="NO"
  sysrc sendmail_outbound_enable="$sendmail_outbound_enable"
  echo -n "sendmail_outbound_enable: "; add_color_output "$sendmail_outbound_enable"
  # Set and display sendmail_submit_enable
  sendmail_submit_enable="NO"
  sysrc sendmail_submit_enable="$sendmail_submit_enable"
  echo -n "sendmail_submit_enable: "; add_color_output "$sendmail_submit_enable"
  # Set and display ntpd_enable
  ntpd_enable="YES"
  sysrc ntpd_enable="$ntpd_enable"
  echo -n "ntpd_enable: "; add_color_output "$ntpd_enable"
  # Set and display ntpd_flags
  ntpd_flags="-g"
  sysrc ntpd_flags="$ntpd_flags"
  echo -n "ntpd_flags: "; add_color_output "$ntpd_flags"
  # Set and display ntpd_sync_on_start
  ntpd_sync_on_start="YES"
  sysrc ntpd_sync_on_start="$ntpd_sync_on_start"
  echo -n "ntpd_sync_on_start: "; add_color_output "$ntpd_sync_on_start"
  # Set and display ntpd_oomprotect
  ntpd_oomprotect="YES"
  sysrc ntpd_oomprotect="$ntpd_oomprotect"
  echo -n "ntpd_oomprotect: "; add_color_output "$ntpd_oomprotect"
  # Set and display inetd_enable
  inetd_enable="NO"
  sysrc inetd_enable="$inetd_enable"
  echo -n "inetd_enable: "; add_color_output "$inetd_enable"
  # Set and display icmp_drop_redirect
  icmp_drop_redirect="YES"
  sysrc icmp_drop_redirect="$icmp_drop_redirect"
  echo -n "icmp_drop_redirect: "; add_color_output "$icmp_drop_redirect"
  # Set and display icmp_log_redirect
  icmp_log_redirect="YES"
  sysrc icmp_log_redirect="$icmp_log_redirect"
  echo -n "icmp_log_redirect: "; add_color_output "$icmp_log_redirect"
  # Set and display nfs_server_enable
  nfs_server_enable="NO"
  sysrc nfs_server_enable="$nfs_server_enable"
  echo -n "nfs_server_enable: "; add_color_output "$nfs_server_enable"
  # Set and display nfs_client_enable
  nfs_client_enable="NO"
  sysrc nfs_client_enable="$nfs_client_enable"
  echo -n "nfs_client_enable: "; add_color_output "$nfs_client_enable"
  # Set and display sshd_enable
  sshd_enable="NO"
  sysrc sshd_enable="$sshd_enable"
  echo -n "sshd_enable: "; add_color_output "$sshd_enable"
  # Set and display portmap_enable
  portmap_enable="NO"
  sysrc portmap_enable="$portmap_enable"
  echo -n "portmap_enable: "; add_color_output "$portmap_enable"
  # Set and display mixer_enable
  mixer_enable="YES"
  sysrc mixer_enable="$mixer_enable"
  echo -n "mixer_enable: "; add_color_output "$mixer_enable"
  # Set and display allscreens_flags
  allscreens_flags="-f vgarom-8x16.fnt"
  sysrc allscreens_flags="$allscreens_flags"
  echo -n "allscreens_flags: "; add_color_output "$allscreens_flags"
  # Set and display keyrate
  keyrate="fast"
  sysrc keyrate="$keyrate"
  echo -n "keyrate: "; add_color_output "$keyrate"
  # Set and display service_delete_empty
  service_delete_empty="YES"
  sysrc service_delete_empty="$service_delete_empty"
  echo -n "service_delete_empty: "; add_color_output "$service_delete_empty"
  # Set and display firewall_enable
  firewall_enable="YES"
  sysrc firewall_enable="$firewall_enable"
  echo -n "firewall_enable: "; add_color_output "$firewall_enable"
  # Set and display firewall_type
  firewall_type="workstation"
  sysrc firewall_type="$firewall_type"
  echo -n "firewall_type: "; add_color_output "$firewall_type"
  # Set and display firewall_quiet
  firewall_quiet="YES"
  sysrc firewall_quiet="$firewall_quiet"
  echo -n "firewall_quiet: "; add_color_output "$firewall_quiet"
  # Set and display firewall_logdeny
  firewall_logdeny="YES"
  sysrc firewall_logdeny="$firewall_logdeny"
  echo -n "firewall_logdeny: "; add_color_output "$firewall_logdeny"
  # Set and display autoboot
  autoboot="YES"
  sysrc autoboot="$autoboot"
  echo -n "autoboot: "; add_color_output "$autoboot"
  # Set and display rc_fast
  rc_fast="YES"
  sysrc rc_fast="$rc_fast"
  echo -n "rc_fast: "; add_color_output "$rc_fast"
  # Set and display rc_startmsgs
  rc_startmsgs="NO"
  sysrc rc_startmsgs="$rc_startmsgs"
  echo -n "rc_startmsgs: "; add_color_output "$rc_startmsgs"
  # Set and display background_dhclient
  background_dhclient="YES"
  sysrc background_dhclient="$background_dhclient"
  echo -n "background_dhclient: "; add_color_output "$background_dhclient"
  # Set and display dbus_enable
  dbus_enable="YES"
  sysrc dbus_enable="$dbus_enable"
  echo -n "dbus_enable: "; add_color_output "$dbus_enable"
  # Set and display blanktime
  blanktime="1200"
  sysrc blanktime="$blanktime"
  echo -n "blanktime: "; add_color_output "$blanktime"
  # Set and display savecore_enable
  savecore_enable="NO"
  sysrc savecore_enable="$savecore_enable"
  echo -n "savecore_enable: "; add_color_output "$savecore_enable"
  # Set and display virecover_enable
  virecover_enable="NO"
  sysrc virecover_enable="$virecover_enable"
  echo -n "virecover_enable: "; add_color_output "$virecover_enable"
  # Set and display smartd_enable
  smartd_enable="YES"
  sysrc smartd_enable="$smartd_enable"
  echo -n "smartd_enable: "; add_color_output "$smartd_enable"
  # Set and display dumpdev
  dumpdev="NO"
  sysrc dumpdev="$dumpdev"
  echo -n "dumpdev: "; add_color_output "$dumpdev"
  # Set and display apm_enable
  apm_enable="YES"
  sysrc apm_enable="$apm_enable"
  echo -n "apm_enable: "; add_color_output "$apm_enable"
  # Set and display defaultroute_delay
  defaultroute_delay="0"
  sysrc defaultroute_delay="$defaultroute_delay"
  echo -n "defaultroute_delay: "; add_color_output "$defaultroute_delay"
  # Set and display rcshutdown_timeout
  rcshutdown_timeout="10"
  sysrc rcshutdown_timeout="$rcshutdown_timeout"
  echo -n "rcshutdown_timeout: "; add_color_output "$rcshutdown_timeout"

  echo ""
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

# Automatically configure rc.conf variables
clear & configure_rc_conf

# End of script
