#!/bin/bash

# Checking if the script is running as root.
if [ "$(id -u)" -ne 0 ]; then
    dialog --title "Permission Denied" --msgbox "Please run this script as root via 'sudo' or 'su'. Thanks." 10 40
    exit 1
fi

# Define an array of wallpaper URLs.
wallpaper_urls=(
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0004.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0011.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0023.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0036.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0037.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0042.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0057.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0058.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0065.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0076.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0188.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0230.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0252.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0256.jpg"
    "https://gitlab.com/dwt1/wallpapers/-/raw/master/0257.jpg"
    "https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Field_Of_Lightning.jpg"
    "https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Lake_View.jpg"
    "https://raw.githubusercontent.com/ghostbsd/ghostbsd-wallpapers/master/Mountain_View.jpg"
)

# Destination directory for wallpapers.
wallpaper_dir="/usr/local/share/backgrounds"

# Initialize a counter for the progress bar.
count=0

# Calculate the total number of wallpapers to download.
total_wallpapers=${#wallpaper_urls[@]}

# Create a function to download wallpapers and update the progress bar.
download_wallpapers() {
    for url in "${wallpaper_urls[@]}"; do
        filename="$(basename "$url")"
        curl -s -L "$url" -o "$wallpaper_dir/$filename"
        count=$((count + 1))
        percent=$((count * 100 / total_wallpapers))
        echo "$percent"
    done
}

# Use dialog to create a progress bar.
dialog --title "Downloading Wallpapers" --gauge "Downloading wallpapers..." 10 50 < <(
    download_wallpapers
)

# Check if any errors occurred during the download.
if [ $? -ne 0 ]; then
    dialog --title "Error" --msgbox "An error occurred while downloading wallpapers." 10 40
    exit 1
fi

# Download and extract some FreeBSD-based wallpapers.
cd && fetch -q -o "$HOME/wallpapers-freebsd.tar.gz" "https://github.com/vermaden/scripts/raw/master/distfiles/wallpapers-freebsd.tar.gz"

# Extract tar.gz archive.
extract() {
destdir="$(basename "$1" .tar.gz)"
mkdir "$destdir"
tar -C "$destdir" -xf "$1"
}
extract wallpapers-freebsd.tar.gz

# Check if any errors occurred during the extraction.
if [ $? -ne 0 ]; then
    dialog --title "Error" --msgbox "An error occurred while extracting wallpapers-freebsd.tar.gz." 10 40
    exit 1
fi

# Copy the specified wallpapers to /usr/share/wallpapers.
cp "$HOME/wallpapers-freebsd/freebsd-think-correctly-black.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/freebsd-x-black-small.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/freebsd-warm-grey-computer.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/jurasic-park-unix-system.jpg" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/unix-highway-to-shell-white.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/unix-too-hot.jpg" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/freebsd-stripes-light-colors.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/freebsd-stripes-dark-colors.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/freebsd-11.png" "$wallpaper_dir"
cp "$HOME/wallpapers-freebsd/unix-this-is-mdh3ll.jpg" "$wallpaper_dir"

# Remove base directory and .tar.gz file.
rm -rf $HOME/wallpapers-freebsd && rm -f $HOME/wallpapers-freebsd.tar.gz

dialog --title "Download Complete" --msgbox "Wallpapers downloaded and saved to $wallpaper_dir." 10 40
