#!/usr/local/bin/bash

# Check if dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: dialog not found. Please install dialog first."
  exit 1
fi

# Array of software options to be installed with descriptions
software_options=(
    "Audacity"
    "Handbrake"
    "ISO Master"
    "AbiWord"
    "Gnumeric"
    "Transmission"
    "Asunder"
    "GIMP"
    "Inkscape"
    "Pinta"
    "Shotwell"
    "VirtualBox"
    "Wine"
)

# Create a string containing the options and their statuses (initially all options are off)
checklist_options=()
for option in "${software_options[@]}"; do
    checklist_options+=("$option" "" off)
done

# Display the checklist dialog and save the selected descriptions to the variable
selected_descriptions=$(dialog --title "Software Installation" --checklist "Select software to install:" 21 35 21 "${checklist_options[@]}" 2>&1 >/dev/tty)

# Install the selected software packages using the package manager (pkg in FreeBSD)
if [ -n "$selected_descriptions" ]; then
    echo "Installing selected software packages with descriptions: $selected_descriptions"

    # Function to map descriptions to package names
    map_descriptions_to_packages() {
        case "$1" in
            "Audacity") echo "audacity" ;;
            "Handbrake") echo "handbrake" ;;
            "ISO Master") echo "isomaster" ;;
            "AbiWord") echo "abiword" ;;
            "Gnumeric") echo "gnumeric" ;;
            "Transmission") echo "transmission-gtk" ;;
            "Asunder") echo "asunder" ;;
            "GIMP") echo "gimp" ;;
            "Inkscape") echo "inkscape" ;;
            "Pinta") echo "pinta" ;;
            "Shotwell") echo "shotwell" ;;
            "VirtualBox") echo "virtualbox-ose virtualbox-ose-kmod" ;;
            "Wine") echo "wine wine-mono wine-gecko" ;;
            *) echo "" ;;
        esac
    }

    selected_packages=""
    for desc in $(echo "$selected_descriptions" | tr -d '"'); do
        pkgname=$(map_descriptions_to_packages "$desc")
        if [ -n "$pkgname" ]; then
            pkg install -y "$pkgname"
        else
            echo "Skipping unrecognized entry: $desc"
        fi
    done

    # Execute post-install commands for specific packages
    for pkgname in $selected_packages; do
        case "$pkgname" in
        "virtualbox-ose")
            # Post-install commands for VirtualBox.
            echo "Running post-install commands for VirtualBox..."
            sysrc vboxnet_enable="YES"
            sysrc kldload_vbox="vboxdrv"
            echo "# VirtualBox stuff." >> /etc/sysctl.conf
            echo vfs.aio.max_buf_aio=8192 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_queue_per_proc=65536 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_per_proc=8192 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_queue=65536 >> /etc/sysctl.conf
            pw group mod vboxusers -m "$USER"
            ;;
        "wine")
            # Post-install commands for Wine.
            echo "Running post-install commands for Wine..."
            echo "# Wine fix." >> /boot/loader.conf
            echo machdep.max_ldt_segment=2048 >> /boot/loader.conf
            ;;
        *)
            echo "No post-install commands for package: $pkgname"
            ;;
        esac
    done

    # Close the progress message
    dialog --infobox "Installation complete!" 5 40
    sleep 2

    # Clean up
    dialog --clear

else
    echo "No software selected. Exiting."
fi
