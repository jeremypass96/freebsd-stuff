#!/bin/sh

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ]; then
echo "Please run this script as root via 'su'! Thanks."
exit
fi

# Symlink bash executable to /bin/bash so that scripts written on/for Linux can run properly.
echo "Making a bash symlink to /bin/bash for Linux shell script
compatibility..."
ln -sv /usr/local/bin/bash /bin/bash

# Symlink themes/icons directories to enable installation of Linux themes.
echo "Symlinking "/usr/local/share/themes" and "/usr/local/share/icons" to /usr/share/ for easy Linux themes and icons installation..."
ln -sv /usr/local/share/themes /usr/share && ln -sv /usr/local/share/icons /usr/share
