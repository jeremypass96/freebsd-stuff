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
