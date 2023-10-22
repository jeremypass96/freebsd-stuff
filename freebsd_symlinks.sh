#!/bin/sh

# Check if the script is running as root.
if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root using 'su' or 'sudo'. Thanks."
  exit 1
fi

# Symlink the bash executable to /bin/bash for Linux shell script compatibility.
echo "Creating a symlink to /bin/bash for Linux shell script compatibility..."
ln -sv /usr/local/bin/bash /bin/bash

# Symlink theme and icon directories for Linux themes and icons installation.
echo "Symlinking theme and icon directories for easy Linux themes and icons installation..."
ln -sv /usr/local/share/themes /usr/share
ln -sv /usr/local/share/icons /usr/share