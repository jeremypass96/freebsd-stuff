#!/usr/local/bin/bash
cmd=(dialog --separate-output --no-cancel --checklist "Would you like to install any extra 3rd party software?" 22 70 22)
options=(1 "Audacity (audio editor)" off
         2 "Xfburn (CD burner)" off
         3 "Handbrake (video file converter)" off
         4 "ISO Master (ISO file editor)" off
         5 "AbiWord (word processor)" off
         6 "Gnumeric (speadsheet)" off
         7 "Transmission (torrent downloader)" off
         8 "Asunder (CD ripper)" off
         9 "GIMP (image editor)" off
         10 "Inkskape (vector graphics editor)" off
         11 "Pinta (image editor similar to Paint.NET on Windows)" off
         12 "Shotwell (photo organizer/editor)" off
         13 "VirtualBox (run multiple operating systems on your PC)" off
         14 "Wine (run Windows applications)" off
         n "No, don't install any 3rd party software." off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1) pkg="audacity";;
        2) pkg="xfburn";;
        3) pkg="handbrake";;
        4) pkg="isomaster";;
        5) pkg="abiword";;
        6) pkg="gnumeric";;
        7) pkg="transmission-gtk";;
        8) pkg="asunder";;
        9) pkg="gimp";;
        10) pkg="inkscape";;
        11) pkg="pinta";;
        12) pkg="shotwell";;
        13) pkg="virtualbox-ose"
            sysrc vboxnet_enable="YES";;
        14) pkg="wine wine-mono wine-gecko"
            echo "Wine fix" >> /boot/loader.conf
            echo "machdep.max_ldt_segment=2048" >> /boot/loader.conf;;
        n) continue
    esac
    pkg install -y $pkg
    clear
done
