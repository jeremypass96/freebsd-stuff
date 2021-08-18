#!/bin/sh
sudo pkg remove -y xorg xdm xsm hplip xf86-video-mga && sudo pkg autoremove -y
sudo pkg install -y xorg-minimal xorg-fonts xorg-libraries xorg-drivers
