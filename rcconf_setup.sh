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

# Function to add color output for "YES" or "NO" values
add_color_output() {
  local value=$1
  if [ "$value" = "YES" ]; then
    echo -e "\033[1;32m$1\033[0m"  # Bold Green
  elif [ "$value" = "NO" ]; then
    echo -e "\033[1;31m$1\033[0m"  # Bold Red
  else
    echo "$1"  # Default color (no color change)
  fi
}

# Function to automatically configure rc.conf variables
configure_rc_conf() {
  echo -e "\033[1;36mConfiguring rc.conf variables...\033[0m"  # Bold Cyan
  echo ""

  # Display colorized variables in rc.conf
  sysrc sendmail_msp_queueenable=$(add_color_output "NO")
  sysrc sendmail_outbound_enable=$(add_color_output "NO")
  sysrc sendmail_submit_enable=$(add_color_output "NO")
  sysrc ntpd_enable=$(add_color_output "YES")
  sysrc ntpd_flags=$(add_color_output "-g")
  sysrc ntpd_sync_on_start=$(add_color_output "YES")
  sysrc ntpd_oomprotect=$(add_color_output "YES")
  sysrc inetd_enable=$(add_color_output "NO")
  sysrc icmp_drop_redirect=$(add_color_output "YES")
  sysrc icmp_log_redirect=$(add_color_output "YES")
  sysrc nfs_server_enable=$(add_color_output "NO")
  sysrc nfs_client_enable=$(add_color_output "NO")
  sysrc sshd_enable=$(add_color_output "NO")
  sysrc portmap_enable=$(add_color_output "NO")
  sysrc mixer_enable=$(add_color_output "YES")
  sysrc allscreens_flags=$(add_color_output "-f vgarom-8x16.fnt")
  sysrc keyrate=$(add_color_output "fast")
  sysrc service_delete_empty=$(add_color_output "YES")
  sysrc firewall_enable=$(add_color_output "YES")
  sysrc firewall_type=$(add_color_output "workstation")
  sysrc firewall_quiet=$(add_color_output "YES")
  sysrc firewall_logdeny=$(add_color_output "YES")
  sysrc autoboot=$(add_color_output "YES")
  sysrc rc_fast=$(add_color_output "YES")
  sysrc rc_startmsgs=$(add_color_output "NO")
  sysrc background_dhclient=$(add_color_output "YES")
  sysrc dbus_enable=$(add_color_output "YES")
  sysrc blanktime=$(add_color_output "1200")
  sysrc savecore_enable=$(add_color_output "NO")
  sysrc virecover_enable=$(add_color_output "NO")
  sysrc smartd_enable=$(add_color_output "YES")
  sysrc dumpdev=$(add_color_output "NO")
  sysrc apm_enable=$(add_color_output "YES")
  sysrc defaultroute_delay=$(add_color_output "0")
  sysrc rcshutdown_timeout=$(add_color_output "10")

  echo ""
  echo -e "\033[1;36mrc.conf variables configured.\033[0m"  # Bold Cyan
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
      pkg install -y drm-kmod xf86-video-amdgpu
      ;;
    2)
      sysrc kld_list+="radeonkms"
      pkg install -y drm-kmod xf86-video-ati
      ;;
    3)
      pkg install -y nvidia-drm-kmod nvidia-driver nvidia-xconfig
      sysrc kld_list+="nvidia nvidia-modeset"
      nvidia-xconfig
      ;;
    4)
      sysrc kld_list+="i915kms"
      pkg install -y drm-kmod xf86-video-intel
      ;;
    5)
      pkg install -y drm-kmod virtualbox-ose-additions xf86-video-vmware
      service vboxguest enable && service vboxservice enable
      sysrc kldload_vbox="vboxdrv"
      pw groupmod vboxusers -m $USER
      sed -i '' s/hw.acpi.power_button_state=S3/\#hw.acpi.power_button_state=S3/g /etc/sysctl.conf
      ;;
    6)
      pkg install -y drm-kmod xf86-video-vmware xf86-input-vmmouse open-vm-tools
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

# Filter out color escape codes in /etc/rc.conf using sed
sed -i -E 's/\x1B\[[0-9;]*[a-zA-Z]//g' /etc/rc.conf

# End of script
