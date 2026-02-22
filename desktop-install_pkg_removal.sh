#!/bin/sh
sudo pkg remove -y xorg xdm xsm xf86-video-mga
sudo pkg autoremove -y
sudo pkg install -y xlibre-minimal xlibre-drivers xorg-fonts xorg-libraries
