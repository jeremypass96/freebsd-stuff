#!/bin/bash

# Function to run gsettings commands
run_gsettings() {
    local command="$1"
    sudo -u $USER sh -c "$command"
    sudo sh -c "$command"
}

# Set up MATE settings
mate_settings=(
    "gsettings set org.mate.background picture-options zoom && gsettings set org.mate.background picture-filename /usr/local/share/backgrounds/freebsd-think-correctly-black.png"
    "gsettings set org.mate.Marco.general titlebar-font 'Poppins Bold 10'"
    "gsettings set org.mate.Marco.general theme 'Skeuos-Blue-Dark'"
    "gsettings set org.mate.Marco.general action-middle-click-titlebar none"
    "gsettings set org.mate.interface gtk-theme 'Skeuos-Blue-Dark'"
    "gsettings set org.mate.interface icon-theme Papirus-Dark"
    "gsettings set org.mate.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 10'"
    "gsettings set org.mate.interface font-name 'Source Sans 3 10'"
    "gsettings set org.mate.caja.desktop font 'Source Sans 3 10'"
    "gsettings set org.mate.interface show-input-method-menu false"
    "gsettings set org.mate.interface show-unicode-menu false"
    "gsettings set org.mate.peripherals-mouse cursor-theme 'Bibata-Modern-Ice'"
    "gsettings set org.mate.peripherals-mouse cursor-size 24"
    "gsettings set org.mate.sound enable-esd true"
    "gsettings set org.mate.sound event-sounds true"
    "gsettings set org.mate.sound input-feedback-sounds true"
    "gsettings set org.mate.caja.preferences enable-delete true"
    "gsettings set org.mate.caja.preferences preview-sound never"
)

# Checking to see if we're running as a normal user.
if [ $(whoami) != $USER ]; then
    echo "Please run this MATE post-install setup script as a normal user! Thanks."
    exit
fi

clear

# Loop through and run the gsettings commands
for setting in "${mate_settings[@]}"; do
    run_gsettings "$setting"
done

echo "Your FreeBSD MATE desktop has been set up for you automatically! Enjoy."
