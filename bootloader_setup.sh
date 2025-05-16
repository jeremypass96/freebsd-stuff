#!/bin/sh

# Define color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # No color

echo -e "${CYAN}This script sets up FreeBSD's loader.conf bootloader variables for desktop use.${NC}"

# Checking to see if we're running as root
echo -e "${YELLOW}Checking if we are running as root...${NC}"
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Please run this bootloader setup script as root! Thanks.${NC}"
    exit
fi

# Set various bootloader variables
echo -e "${BLUE}Configuring /boot/loader.conf...${NC}"

echo -e "${YELLOW}Enabling cuse_load and cc_cubic_load...${NC}"
sysrc -f /boot/loader.conf cuse_load="YES"
sysrc -f /boot/loader.conf cc_cubic_load="YES"
grep -q 'kern.random.fortuna.minpoolsize' /boot/loader.conf || \
  echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Disabling boot menu and making booting faster...${NC}"
echo "# Disable boot menu/make booting faster." >> /boot/loader.conf
sysrc -f /boot/loader.conf loader_delay=0
sysrc -f /boot/loader.conf autoboot_delay=-1
sysrc -f /boot/loader.conf beastie_disable="YES"
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Enabling AES and SHA accelerator driver...${NC}"
echo "# Driver for the AES and SHA accelerator on x86 CPUs." >> /boot/loader.conf
sysrc -f /boot/loader.conf aesni_load="YES"
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Enabling GELI disk encryption...${NC}"
echo "# Load GELI disk encryption." >> /boot/loader.conf
sysrc -f /boot/loader.conf crypto_load="YES"
sysrc -f /boot/loader.conf geom_eli_load="YES"
echo "" >> /boot/loader.conf

read -rp "Do you want to hide boot messages? (Y/n): " resp
resp=${resp:-Y}
if [ "$resp" = Y ] || [ "$resp" = y ]; then
    echo -e "${YELLOW}Hiding boot messages...${NC}"
    echo "# Hide boot messages." >> /boot/loader.conf
    sysrc -f /boot/loader.conf boot_mute="YES"
    echo "" >> /boot/loader.conf
elif [ "$resp" = n ]; then
    echo -e "${CYAN}Boot messages will be shown.${NC}"
else
    echo -e "${RED}Invalid response. Proceeding without hiding boot messages.${NC}"
fi

read -rp "Do you have an AMD CPU installed in your computer? (Y/n): " resp
resp=${resp:-Y}
if [ "$resp" = Y ] || [ "$resp" = y ]; then
    echo -e "${YELLOW}Enabling AMD southbridge watchdog timers and CPU thermal sensor...${NC}"
    echo "# Load AMD southbridge watchdog timers and CPU thermal sensor." >> /boot/loader.conf
    sysrc -f /boot/loader.conf amdsbwd_load="YES"
    sysrc -f /boot/loader.conf amdtemp_load="YES"
    echo "" >> /boot/loader.conf
    echo -e "${YELLOW}Enabling AMD CPU microcode...${NC}"
    echo "# Load CPU microcode." >> /boot/loader.conf
    sysrc -f /boot/loader.conf cpu_microcode_load="YES"
    sysrc -f /boot/loader.conf cpu_microcode_name="/boot/firmware/amd-ucode.bin"
    echo "" >> /boot/loader.conf
elif [ "$resp" = n ]; then
    echo -e "${YELLOW}Enabling Intel core temperature sensor...${NC}"
    sysrc -f /boot/loader.conf coretemp_load="YES"
    echo "" >> /boot/loader.conf
    echo -e "${YELLOW}Enabling Intel CPU microcode...${NC}"
    sysrc -f /boot/loader.conf cpu_microcode_load="YES"
    sysrc -f /boot/loader.conf cpu_microcode_name="/boot/firmware/intel-ucode.bin"
    echo "" >> /boot/loader.conf
else
    echo -e "${RED}Invalid response. Proceeding without adding CPU specific modules.${NC}"
fi

echo -e "${YELLOW}Adding miscellaneous settings...${NC}"
echo "# Misc. other stuff." >> /boot/loader.conf
sysrc -f /boot/loader.conf fusefs_load="YES"
sysrc -f /boot/loader.conf libiconv_load="YES"
sysrc -f /boot/loader.conf libmchain_load="YES"
sysrc -f /boot/loader.conf cd9660_iconv_load="YES"
sysrc -f /boot/loader.conf msdosfs_iconv_load="YES"
grep -q 'kern.ipc.shmseg=10000' /boot/loader.conf || \
  echo 'kern.ipc.shmseg=10000' >> /boot/loader.conf
grep -q 'kern.ipc.shmmni=10000' /boot/loader.conf || \
  echo 'kern.ipc.shmmni=10000' >> /boot/loader.conf
grep -q 'kern.geom.label.disk_ident.enable=0' /boot/loader.conf || \
  echo 'kern.geom.label.disk_ident.enable=0' >> /boot/loader.conf
grep -q 'kern.geom.label.gptid.enable=0' /boot/loader.conf || \
  echo 'kern.geom.label.gptid.enable=0' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Speeding up bootup and shutdown...${NC}"
echo "# Speed up bootup/shutdown." >> /boot/loader.conf
grep -q 'hw.usb.no_boot_wait=1' /boot/loader.conf || \
  echo 'hw.usb.no_boot_wait=1' >> /boot/loader.conf
grep -q 'hw.usb.no_shutdown_wait=1' /boot/loader.conf || \
  echo 'hw.usb.no_shutdown_wait=1' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Applying security mitigations...${NC}"
echo '# Protects against "Meltdown" security mitigation.' >> /boot/loader.conf
grep -q 'vm.pmap.pti=1' /boot/loader.conf || \
  echo 'vm.pmap.pti=1' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo '# Protects against "Varient 4" security mitigation.' >> /boot/loader.conf
grep -q 'hw.spec_store_bypass_disable_active=1' /boot/loader.conf || \
  echo 'hw.spec_store_bypass_disable_active=1' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Powering off devices without an attached driver...${NC}"
echo "# Power off devices without an attached driver." >> /boot/loader.conf
grep -q 'hw.pci.do_power_nodriver=1' /boot/loader.conf || \
  echo 'hw.pci.do_power_nodriver=1' >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${CYAN}Adding custom VT colors...${NC}"
tee -a /boot/loader.conf > /dev/null << EOF
###########################################################
### Ayu Mirage VT Colors.				###
### From the iTerm2 Color Schemes project.		###
###########################################################
kern.vt.color.0.rgb="#191e2a"
kern.vt.color.1.rgb="#ed8274"
kern.vt.color.2.rgb="#a6cc70"
kern.vt.color.3.rgb="#fad07b"
kern.vt.color.4.rgb="#6dcbfa"
kern.vt.color.5.rgb="#cfbafa"
kern.vt.color.6.rgb="#90e1c6"
kern.vt.color.7.rgb="#cbccc6"
kern.vt.color.8.rgb="#686868"
kern.vt.color.9.rgb="#f28779"
kern.vt.color.10.rgb="#bae67e"
kern.vt.color.11.rgb="#ffd580"
kern.vt.color.12.rgb="#73d0ff"
kern.vt.color.13.rgb="#d4bfff"
kern.vt.color.14.rgb="#95e6cb"
kern.vt.color.15.rgb="#ffffff"
##########################################################
EOF

echo -e "${GREEN}FreeBSD bootloader configuration completed.${NC}"