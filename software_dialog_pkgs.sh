#!/bin/bash

# Check if dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: dialog not found. Please install dialog first."
  exit 1
fi

# Array of software options to be installed with descriptions
software_options=(
    "Audaicty"
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
            "Audaicty") echo "audacity" ;;
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
            "VirtualBox") echo "virtualBox-ose virtualbox-ose-kmod" ;;
            "Wine") echo "wine wine-mono wine-gecko" ;;
            *) echo "" ;;
        esac
    }

    selected_packages=""
    for description in $selected_descriptions; do
        package=$(map_descriptions_to_packages "$description")
        if [ -n "$package" ]; then
        selected_packages="$selected_packages $package"
        fi
    done

    # Count the number of packages to be installed
    num_packages=$(echo "$selected_packages" | tr -s ' ' '\n' | wc -l)

   # Initialize the progress bar
    dialog --title "Installation Progress" --gauge "Installing software..." 7 50 0

    # Counter for installed packages
    installed_packages=0

    # Install the selected software packages and update the progress bar
    for package in $selected_packages; do
    # Install the package
    pkg install -y "$package"

    # Increment the counter
    ((installed_packages++))

    # Calculate the progress percentage
    progress=$((installed_packages * 100 / num_packages))

    # Update the progress bar in the dialog
    echo "$progress"
done

    # Execute post-install commands for specific packages
    for package in $selected_packages; do
        case "$package" in
        "virtualBox-ose")
            # Post-install commands for VirtualBox.
            echo "Running post-install commands for VirtualBox..."
            sysrc vboxnet_enable="YES"
            sysrc kldload_vbox="vboxdrv"
            echo "# VirtualBox stuff." >> /etc/sysctl.conf
            echo vfs.aio.max_buf_aio=8192 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_queue_per_proc=65536 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_per_proc=8192 >> /etc/sysctl.conf
            echo vfs.aio.max_aio_queue=65536 >> /etc/sysctl.conf
            pw group mod vboxusers -m $USER
            ;;
        "wine")
            # Post-install commands for Wine.
            echo "Running post-install commands for Wine..."
            echo "# Wine fix." >> /boot/loader.conf
            echo machdep.max_ldt_segment=2048 >> /boot/loader.conf
            ;;
        *)
            echo "No post-install commands for package: $package"
            ;;
        esac
    done

    # Close the progress bar
    dialog --infobox "Installation complete!" 5 40
    sleep 2

    # Clean up
    dialog --clear

else
    echo "No software selected. Exiting."
fi
