#!/bin/sh
# This shell script installs graphics drivers and configures rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root! Thanks."
  exit
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

clear

# Check if dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: dialog not found. Please install dialog first."
  exit 1
fi

# Function to colorize terminal output only (not rc.conf)
add_color_output() {
  case "$1" in
    YES) echo -e "\033[1;32mYES\033[0m" ;;  # Bold Green
    NO) echo -e "\033[1;31mNO\033[0m" ;;    # Bold Red
    *) echo "$1" ;;
  esac
}

# Function to safely apply a sysrc setting and echo it with color
set_rc() {
  local var="$1"
  local val="$2"
  sysrc "${var}=${val}" >/dev/null
  echo "${var} = $(add_color_output "$val")"
}

configure_rc_conf() {
  echo -e "\033[1;36mConfiguring rc.conf variables...\033[0m"
  echo ""

  # --- Mail ---
  echo "# --- Mail ---" >> /etc/rc.conf
  set_rc sendmail_msp_queueenable NO
  set_rc sendmail_outbound_enable NO
  set_rc sendmail_submit_enable NO

  echo "" >> /etc/rc.conf

  # --- Time Sync ---
  echo "# --- Time Sync ---" >> /etc/rc.conf
  set_rc ntpd_enable YES
  set_rc ntpd_sync_on_start YES
  set_rc ntpd_oomprotect YES

  echo "" >> /etc/rc.conf

  # --- Networking ---
  echo "# --- Networking ---" >> /etc/rc.conf
  set_rc inetd_enable NO
  set_rc icmp_drop_redirect YES
  set_rc icmp_log_redirect YES
  set_rc nfs_server_enable NO
  set_rc nfs_client_enable NO
  set_rc sshd_enable NO
  set_rc portmap_enable NO

  echo "" >> /etc/rc.conf

  # --- Desktop / Services ---
  echo "# --- Desktop / Services ---" >> /etc/rc.conf
  set_rc mixer_enable YES
  set_rc allscreens_flags "-f spleen-8x16.fnt"
  set_rc keyrate fast
  set_rc service_delete_empty YES
  set_rc firewall_enable YES
  set_rc firewall_type workstation
  set_rc firewall_quiet YES
  set_rc firewall_logdeny YES
  set_rc autoboot YES
  set_rc rc_fast YES
  set_rc rc_startmsgs NO
  set_rc background_dhclient YES
  set_rc dbus_enable YES
  set_rc blanktime 1200
  set_rc savecore_enable NO
  set_rc virecover_enable NO
  set_rc smartd_enable YES
  set_rc dumpdev NO
  set_rc apmd_enable YES
  set_rc defaultroute_delay 0
  set_rc rcshutdown_timeout 10
  set_rc cleanvar_enable YES

  echo ""
  echo -e "\033[1;36mrc.conf variables configured.\033[0m"
}

# Function to install graphics driver based on selection
install_graphics_driver() {
  selected_driver=$(dialog --title "Install/Enable Graphics Driver" --menu "Select a graphics driver:" 15 30 6 \
    1 "AMD GPU" \
    2 "ATI Radeon" \
    3 "NVIDIA" \
    4 "Intel" \
    5 "VirtualBox" \
    6 "VMware" \
    2>&1 >/dev/tty)

  case "$selected_driver" in
    1)
      if ! pkg info | grep -q "^gpu-firmware-amd-kmod"; then
      pkg install -y drm-kmod
      else
      pkg install -y xf86-video-amdgpu drm-61-kmod
      sysrc kld_list+="amdgpu"
      fi
      ;;
    2)
      if ! pkg info | grep -q "^gpu-firmware-radeon-kmod"; then
      pkg install -y drm-kmod
      else
      pkg install -y xf86-video-ati drm-61-kmod
      sysrc kld_list+="radeonkms"
      fi
      ;;
    3)
      if ! pkg info | grep -q "^nvidia-drm-kmod"; then
      pkg install -y nvidia-drm-kmod drm-kmod
      else
      pkg install -y nvidia-driver nvidia-xconfig drm-61-kmod
      sysrc kld_list+="nvidia nvidia-modeset"
      nvidia-xconfig
      fi
      ;;
    4)
      if ! pkg info | grep -q "^gpu-firmware-intel-kmod"; then
      pkg install -y drm-kmod
      else
      pkg install -y xf86-video-intel drm-61-kmod
      sysrc kld_list+="i915kms"
      fi
      ;;
    5)
      pkg install -y drm-61-kmod virtualbox-ose-additions xf86-video-vmware
      service vboxguest enable && service vboxservice enable
      sysrc kldload_vbox="vboxdrv"
      pw groupmod vboxusers -m "$logged_in_user"
      sed -i '' 's/^hw.acpi.power_button_state=S3/#&/' /etc/sysctl.conf
      ;;
    6)
      pkg install -y drm-61-kmod xf86-video-vmware xf86-input-vmmouse open-vm-tools
      sed -i '' 's/^hw.acpi.power_button_state=S3/#&/' /etc/sysctl.conf
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