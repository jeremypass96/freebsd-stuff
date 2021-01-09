#!/usr/local/bin/bash
clear
# Symlink bash executable to /bin/bash so that scripts written on/for Linux can run properly.
echo "Making a Bash symlink to /bin/bash for Linux shell script compatability."
doas ln -sv /usr/local/bin/bash /bin/bash
# Symlink themes/icons directories to enable installation of Linux themes.
echo "Symlinking "/usr/local/share/themes" and "/usr/local/share/icons" to /usr/share/ for easy Linux themes and icons installation."
doas ln -sv /usr/local/share/themes /usr/share/
doas ln -sv /usr/local/share/icons /usr/share/