#!/bin/bash
# Script to install Posy's cursors on *BSD.
# Use logname instead of $USER to get the actual invoking user when run as root.
logged_in_user=$(logname)

echo ">>> Installing Posy cursors..."
echo ">>> Cloning Posy cursors GitHub repo..."
git -C /home/"$logged_in_user" clone https://github.com/Icelk/posy-cursors.git

echo ">>> Copying cursors to /usr/local/share/icons..."
sudo cp -rp /home/"$logged_in_user"/posy-cursors/themes/posy-white /usr/local/share/icons/posy-cursors
sudo cp -rp /home/"$logged_in_user"/posy-cursors/themes/posy-black /usr/local/share/icons/posy-cursors-black

echo ">>> Applying correct user permissions..."
sudo chown -R root:wheel /usr/local/share/icons/posy-cursors /usr/local/share/icons/posy-cursors-black
sudo find /usr/local/share/icons/posy-cursors /usr/local/share/icons/posy-cursors-black -type d -exec chmod 755 {} \;
sudo find /usr/local/share/icons/posy-cursors /usr/local/share/icons/posy-cursors-black -type f -exec chmod 644 {} \;

echo ">>> Removing GitHub repo directory from current directory..."
rm -rf /home/"$logged_in_user"/posy-cursors

echo ">>> Done. Posy cursors are now installed."
