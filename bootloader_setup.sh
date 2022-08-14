#!/bin/sh
# This shell script sets up FreeBSD's loader.conf bootloader variables for desktop use.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this bootloader setup script as root! Thanks."
exit
fi

sysrc -f /boot/loader.conf cuse_load="YES"
sysrc -f /boot/loader.conf cc_cubic_load="YES"
echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf
echo "" >> /boot/loader.conf

read -p "Do you have an AMD CPU installed in your computer? (y/n): " resp
if [ "$resp" = y ]; then
echo "# Load AMD southbridge watchdog timers and CPU thermal sensor." >> /boot/loader.conf
sysrc -f /boot/loader.conf amdsbwd_load="YES"
sysrc -f /boot/loader.conf amdtemp_load="YES"
echo "" >> /boot/loader.conf
fi
if [ "$resp" = n ]; then
sysrc -f /boot/loader.conf coretemp_load="YES"
echo "" >> /boot/loader.conf
fi

# Disable boot menu/make booting faster.
echo "# Disable boot menu/make booting faster." >> /boot/loader.conf
sysrc -f /boot/loader.conf loader_delay=0
sysrc -f /boot/loader.conf autoboot_delay=-1
sysrc -f /boot/loader.conf beastie_disable="YES"
echo "" >> /boot/loader.conf

# Driver for the AES and SHA accelerator on	x86 CPUs.
echo "# Driver for the AES and SHA accelerator on x86 CPUs." >> /boot/loader.conf
sysrc -f /boot/loader.conf aesni_load="YES"
echo "" >> /boot/loader.conf

# Load GELI disk encryption.
echo "# Load GELI disk encryption." >> /boot/loader.conf
sysrc -f /boot/loader.conf crypto_load="YES"
sysrc -f /boot/loader.conf geom_eli_load="YES"
echo "" >> /boot/loader.conf

# Hide boot messages.
echo "# Hide boot messages." >> /boot/loader.conf
sysrc -f /boot/loader.conf boot_mute="YES"
echo "" >> /boot/loader.conf

# Load CPU microcode.
echo "# Load CPU microcode." >> /boot/loader.conf
sysrc -f /boot/loader.conf cpu_microcode_load="YES"
sysrc -f /boot/loader.conf cpu_microcode_name="/boot/firmware/intel-ucode.bin"
echo "" >> /boot/loader.conf

# Misc. other stuff.
echo "# Misc. other stuff." >> /boot/loader.conf
sysrc -f /boot/loader.conf fusefs_load="YES"
sysrc -f /boot/loader.conf libiconv_load="YES"
sysrc -f /boot/loader.conf libmchain_load="YES"
sysrc -f /boot/loader.conf cd9660_iconv_load="YES"
sysrc -f /boot/loader.conf msdosfs_iconv_load="YES"
echo kern.ipc.shmseg=10000 >> /boot/loader.conf
echo kern.ipc.shmmni=10000 >> /boot/loader.conf
echo kern.geom.label.disk_ident.enable=0 >> /boot/loader.conf
echo kern.geom.label.gptid.enable=0 >> /boot/loader.conf
echo "" >> /boot/loader.conf

# Speed up bootup/shutdown.
echo "# Speed up bootup/shutdown." >> /boot/loader.conf
echo hw.usb.no_boot_wait=1 >> /boot/loader.conf
echo hw.usb.no_shutdown_wait=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

# Protects against "Meltdown" security mitigation.
echo '# Protects against "Meltdown" security mitigation.' >> /boot/loader.conf
echo vm.pmap.pti=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

# Protects against "Varient 4" security mitigation.
echo '# Protects against "Varient 4" security mitigation.' >> /boot/loader.conf
echo hw.spec_store_bypass_disable_active=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

# Power off devices without an attached driver.
echo "# Power off devices without an attached driver." >> /boot/loader.conf
echo hw.pci.do_power_nodriver=2 >> /boot/loader.conf
echo "" >> /boot/loader.conf

########################################################################
### Custom VT Colors - Firewatch (from iTerm2 Color Schemes project) ###
### Console background color is black instead of dark grey           ###
### (console was too bright and made the text barely readable.)      ###
########################################################################
kern.vt.color.0.rgb="#000000"
kern.vt.color.1.rgb="#d95360"
kern.vt.color.2.rgb="#5ab977"
kern.vt.color.3.rgb="#dfb563"
kern.vt.color.4.rgb="#4d89c4"
kern.vt.color.5.rgb="#d55119"
kern.vt.color.6.rgb="#44a8b6"
kern.vt.color.7.rgb="#9ba2b2"
kern.vt.color.8.rgb="#585f6d"
kern.vt.color.9.rgb="#d95360"
kern.vt.color.10.rgb="#5ab977"
kern.vt.color.11.rgb="#dfb563"
kern.vt.color.12.rgb="#4c89c5"
kern.vt.color.13.rgb="#d55119"
kern.vt.color.14.rgb="#44a8b6"
kern.vt.color.15.rgb="#e6e5ff"
########################################################################
