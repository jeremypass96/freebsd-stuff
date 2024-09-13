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
if [ $(id -u) -ne 0 ]; then
    echo -e "${RED}Please run this bootloader setup script as root! Thanks.${NC}"
    exit
fi

# Set various bootloader variables
echo -e "${BLUE}Configuring /boot/loader.conf...${NC}"

echo -e "${YELLOW}Enabling cuse_load and cc_cubic_load...${NC}"
sysrc -f /boot/loader.conf cuse_load="YES"
sysrc -f /boot/loader.conf cc_cubic_load="YES"
echo 'kern.random.fortuna.minpoolsize="512"' >> /boot/loader.conf
echo "" >> /boot/loader.conf

read -p "Do you have an AMD CPU installed in your computer? (Y/n): " resp
resp=${resp:-Y}
if [ "$resp" = Y ] || [ "$resp" = y ]; then
    echo -e "${YELLOW}Enabling AMD southbridge watchdog timers and CPU thermal sensor...${NC}"
    echo "# Load AMD southbridge watchdog timers and CPU thermal sensor." >> /boot/loader.conf
    sysrc -f /boot/loader.conf amdsbwd_load="YES"
    sysrc -f /boot/loader.conf amdtemp_load="YES"
    echo "" >> /boot/loader.conf
elif [ "$resp" = n ]; then
    echo -e "${YELLOW}Enabling Intel core temperature sensor...${NC}"
    sysrc -f /boot/loader.conf coretemp_load="YES"
    echo "" >> /boot/loader.conf
else
    echo -e "${RED}Invalid response. Proceeding without adding CPU specific modules.${NC}"
fi

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

read -p "Do you want to hide boot messages? (Y/n): " resp
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

echo -e "${YELLOW}Enabling CPU microcode...${NC}"
echo "# Load CPU microcode." >> /boot/loader.conf
sysrc -f /boot/loader.conf cpu_microcode_load="YES"
sysrc -f /boot/loader.conf cpu_microcode_name="/boot/firmware/intel-ucode.bin"
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Adding miscellaneous settings...${NC}"
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

echo -e "${YELLOW}Speeding up bootup and shutdown...${NC}"
echo "# Speed up bootup/shutdown." >> /boot/loader.conf
echo hw.usb.no_boot_wait=1 >> /boot/loader.conf
echo hw.usb.no_shutdown_wait=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Applying security mitigations...${NC}"
echo '# Protects against "Meltdown" security mitigation.' >> /boot/loader.conf
echo vm.pmap.pti=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo '# Protects against "Varient 4" security mitigation.' >> /boot/loader.conf
echo hw.spec_store_bypass_disable_active=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${YELLOW}Powering off devices without an attached driver...${NC}"
echo "# Power off devices without an attached driver." >> /boot/loader.conf
echo hw.pci.do_power_nodriver=1 >> /boot/loader.conf
echo "" >> /boot/loader.conf

echo -e "${CYAN}Adding custom VT colors...${NC}"
echo "##################################################################################" >> /boot/loader.conf
echo "### Custom VT Colors - Based off Firewatch, Andromeda, and PaulMillr themes.   ###" >> /boot/loader.conf
echo "### From the iTerm2 Color Schemes project. 					                   ###" >> /boot/loader.conf
echo "##################################################################################" >> /boot/loader.conf
echo 'kern.vt.color.0.rgb="#000000"' >> /boot/loader.conf
echo 'kern.vt.color.1.rgb="#d95360"' >> /boot/loader.conf
echo 'kern.vt.color.2.rgb="#5ab977"' >> /boot/loader.conf
echo 'kern.vt.color.3.rgb="#e5e512"' >> /boot/loader.conf
echo 'kern.vt.color.4.rgb="#4d89c4"' >> /boot/loader.conf
echo 'kern.vt.color.5.rgb="#bc3fbc"' >> /boot/loader.conf
echo 'kern.vt.color.6.rgb="#66ccff"' >> /boot/loader.conf
echo 'kern.vt.color.7.rgb="#e5e5e5"' >> /boot/loader.conf
echo 'kern.vt.color.8.rgb="#585f6d"' >> /boot/loader.conf
echo 'kern.vt.color.9.rgb="#d95360"' >> /boot/loader.conf
echo 'kern.vt.color.10.rgb="#5ab977"' >> /boot/loader.conf
echo 'kern.vt.color.11.rgb="#e5e512"' >> /boot/loader.conf
echo 'kern.vt.color.12.rgb="#4c89c5"' >> /boot/loader.conf
echo 'kern.vt.color.13.rgb="#bc3fbc"' >> /boot/loader.conf
echo 'kern.vt.color.14.rgb="#7adff2"' >> /boot/loader.conf
echo 'kern.vt.color.15.rgb="#e6e5ff"' >> /boot/loader.conf
echo "##################################################################################" >> /boot/loader.conf

echo -e "${GREEN}FreeBSD bootloader configuration completed.${NC}"
