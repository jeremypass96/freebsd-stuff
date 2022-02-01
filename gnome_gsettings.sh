#!/bin/sh

if [ $(id -u) = 0 ] ; then
echo "This setup script MUST be run as a normal user! DO NOT run as root! Thanks."
exit
fi

gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set org.gnome.desktop.background picture-uri /usr/local/share/backgrounds/gnome/Loveles.jpg
gsettings set org.gnome.desktop.interface font-name "Roboto 10"
gsettings set org.gnome.desktop.interface gtk-theme "Pop"
gsettings set org.gnome.desktop.interface toolbar-style icons
gsettings set org.gnome.desktop.interface icon-theme "Newaita-reborn-pop-os"
gsettings set org.gnome.desktop.interface cursor-theme "macOSBigSur"
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false
gsettings set org.gnome.desktop.sound input-feedback-sounds true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
