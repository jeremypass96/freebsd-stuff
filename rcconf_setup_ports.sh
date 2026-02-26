#!/bin/sh
# This shell script sets up FreeBSD rc.conf variables for desktop use.

# Checking to see if we're running as root.
if [ "$(id -u)" -ne 0 ]; then
	echo "Please run this script as root! Thanks."
	exit
fi

# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

clear

# Function to colorize terminal output only (not rc.conf)
add_color_output() {
	case "$1" in
	YES) echo -e "\033[1;32mYES\033[0m" ;; # Bold Green
	NO) echo -e "\033[1;31mNO\033[0m" ;;   # Bold Red
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
	echo "# --- Mail ---" >>/etc/rc.conf
	set_rc sendmail_msp_queueenable NO
	set_rc sendmail_outbound_enable NO
	set_rc sendmail_submit_enable NO

	echo "" >>/etc/rc.conf

	# --- Time Sync ---
	echo "# --- Time Sync ---" >>/etc/rc.conf
	set_rc ntpd_enable YES
	set_rc ntpd_sync_on_start YES
	set_rc ntpd_oomprotect YES

	echo "" >>/etc/rc.conf

	# --- Networking ---
	echo "# --- Networking ---" >>/etc/rc.conf
	set_rc inetd_enable NO
	set_rc icmp_drop_redirect YES
	set_rc icmp_log_redirect YES
	set_rc nfs_server_enable NO
	set_rc nfs_client_enable NO
	set_rc sshd_enable NO
	set_rc portmap_enable NO

	echo "" >>/etc/rc.conf

	# --- Desktop / Services ---
	echo "# --- Desktop / Services ---" >>/etc/rc.conf
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

# Function to install graphics driver from ports tree
install_graphics_driver() {
	selected_driver=$(dialog --title "Install Graphics Driver" --menu "Select a graphics driver to install from the FreeBSD ports tree:" 15 45 6 \
		1 "AMD GPU" \
		2 "ATI" \
		3 "NVIDIA" \
		4 "Intel" \
		5 "VirtualBox Additions" \
		6 "VMware" \
		2>&1 >/dev/tty)

	case "$selected_driver" in
	1)
		sysrc kld_list+=amdgpu
		sed -i '' '20s/$/AMDGPU/' /etc/make.conf
		cd /usr/ports/graphics/gpu-firmware-radeon-kmod && make install clean
		cd /usr/ports/graphics/drm-61-kmod && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-video-amdgpu && make install clean
		;;
	2)
		sysrc kld_list+=radeonkms
		sed -i '' '20s/$/ATI/' /etc/make.conf
		cd /usr/ports/graphics/gpu-firmware-radeon-kmod && make install clean
		cd /usr/ports/graphics/drm-61-kmod && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-video-ati && make install clean
		;;
	3)
		cd /usr/ports/graphics/nvidia-drm-kmod && make install clean
		cd /usr/ports/x11/nvidia-driver && make install clean
		cd /usr/ports/x11/nvidia-xconfig && make install clean
		sysrc kld_list+=nvidia nvidia-modeset
		nvidia-xconfig
		;;
	4)
		sysrc kld_list+=i915kms
		sed -i '' '20s/$/INTEL/' /etc/make.conf
		cd /usr/ports/graphics/gpu-firmware-intel-kmod && make install clean
		cd /usr/ports/graphics/drm-61-kmod && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-video-intel && make install clean
		;;
	5)
		sed -i '' '20s/$/VMWARE/' /etc/make.conf
		cd /usr/ports/graphics/drm-61-kmod && make install clean
		cd /usr/ports/emulators/virtualbox-ose-additions && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-video-vmware && make install clean
		service vboxguest enable && service vboxservice enable
		sysrc kldload_vbox="vboxdrv"
		pw groupmod vboxusers -m "$logged_in_user"
		sed -i '' 's/^hw.acpi.power_button_state=S3/#&/' /etc/sysctl.conf
		;;
	6)
		sed -i '' '20s/$/VMWARE VMMOUSE/' /etc/make.conf
		cd /usr/ports/graphics/drm-61-kmod && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-video-vmware && make install clean
		cd /usr/ports/x11-drivers/xlibre-xf86-input-vmmouse && make install clean
		cd /usr/ports/emulators/open-vm-tools && make install clean
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
clear &
configure_rc_conf
