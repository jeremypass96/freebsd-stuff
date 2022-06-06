#!/bin/sh
cd
#
clear
# Get wallpaper!
echo "Getting wallpaper..."
fetch https://gitlab.com/dwt1/wallpapers/-/raw/master/0188.jpg?inline=false -o /usr/local/share/backgrounds/0188.jpg
doas chown root:wheel /usr/local/share/backgrounds/0188.jpg
clear
# Set wallpaper.
gsettings set org.mate.background picture-options zoom && gsettings set org.mate.background picture-filename /usr/local/share/backgrounds/0188.jpg
# Set window titlebar font.
gsettings set org.mate.Marco.general titlebar-font "Poppins Bold 10"
# Set window theme.
gsettings set org.mate.Marco.general theme "Skeuos-Blue-Dark"
# Turn off middle click on window titlebar.
gsettings set org.mate.Marco.general action-middle-click-titlebar none
# Set theme.
gsettings set org.mate.interface gtk-theme "Skeuos-Blue-Dark"
# Set icon theme.
gsettings set org.mate.interface icon-theme Papirus-Dark
# Set fonts.
gsettings set org.mate.interface monospace-font-name "IBM Plex Mono 10"
gsettings set org.mate.interface font-name "Roboto 10"
gsettings set org.mate.caja.desktop font "Roboto 10"
# Turn off a couple useless menus.
gsettings set org.mate.interface show-input-method-menu false
gsettings set org.mate.interface show-unicode-menu false
# Set mouse cursor.
gsettings set org.mate.peripherals-mouse cursor-theme volantes_light_cursors
gsettings set org.mate.peripherals-mouse cursor-szie 32
# Set up FreeDesktop sound theme.
gsettings set org.mate.sound enable-esd true
gsettings set org.mate.sound event-sounds true
gsettings set org.mate.sound input-feedback-sounds true
# Setup Caja preferences.
gsettings set org.mate.caja.preferences enable-delete true
gsettings set org.mate.caja.preferences preview-sound never
cd
#
echo "Your FreeBSD MATE desktop has been set up for you automatically! Enjoy."
