#!/bin/bash

# Check if dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: dialog not found. Please install dialog first."
  exit 1
fi

# Array of port options to be installed with descriptions
port_options=(
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
for option in "${port_options[@]}"; do
    checklist_options+=("$option" "" off)
done

# Display the checklist dialog and save the selected descriptions to the variable
selected_descriptions=$(dialog --title "Port Installation" --checklist "Select ports to install:" 21 35 21 "${checklist_options[@]}" 2>&1 >/dev/tty)

# Install the selected ports using portmaster
if [ -n "$selected_descriptions" ]; then
    echo "Installing selected ports with descriptions: $selected_descriptions"

    # Function to map descriptions to port names
    map_descriptions_to_ports() {
        case "$1" in
            "Audaicty") echo "audio/audacity" ;;
            "Handbrake") echo "multimedia/handbrake" ;;
            "ISO Master") echo "sysutils/isomaster" ;;
            "AbiWord") echo "editors/abiword" ;;
            "Gnumeric") echo "math/gnumeric" ;;
            "Transmission") echo "net-p2p/transmission-gtk" ;;
            "Asunder") echo "audio/asunder" ;;
            "GIMP") echo "graphics/gimp-app" ;;
            "Inkscape") echo "graphics/inkscape" ;;
            "Pinta") echo "graphics/pinta" ;;
            "Shotwell") echo "graphics/shotwell" ;;
            "VirtualBox") echo "emulators/virtualbox-ose" ;;
            "Wine") echo "emulators/wine" ;;
            *) echo "" ;;
        esac
    }

    selected_ports=""
    for description in $selected_descriptions; do
        port=$(map_descriptions_to_ports "$description")
        if [ -n "$port" ]; then
            selected_ports="$selected_ports $port"
        fi
    done

    # Count the number of ports to be installed
    num_ports=$(echo "$selected_ports" | tr -s ' ' '\n' | wc -l)

    # Initialize the progress bar
    dialog --title "Port Installation Progress" --gauge "Installing ports..." 7 50 0

    # Counter for installed ports
    installed_ports=0

    # Install the selected ports and update the progress bar
    for port in $selected_ports; do
        # Install the port
        portmaster -ad --no-confirm "$port"

        # Increment the counter
        ((installed_ports++))

        # Calculate the progress percentage
        progress=$((installed_ports * 100 / num_ports))

        # Update the progress bar
        echo "$progress" | dialog --title "Installation Progress" --gauge "Installing ports..." 7 50
    done

    # Execute post-install commands for specific ports
    for port in $selected_ports; do
        case "$port" in
        "emulators/virtualbox-ose")
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
        "emulators/wine")
            # Post-install commands for Wine.
            echo "Running post-install commands for Wine..."
            echo "# Wine fix." >> /boot/loader.conf
            echo machdep.max_ldt_segment=2048 >> /boot/loader.conf
            ;;
        *)
            echo "No post-install commands for port: $port"
            ;;
        esac
    done

    # Close the progress bar
    dialog --infobox "Installation complete!" 5 40
    sleep 2

    # Clean up
    dialog --clear

else
    echo "No ports selected. Exiting."
fi
