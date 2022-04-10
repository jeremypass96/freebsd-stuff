#!/usr/local/bin/bash
cmd=(dialog --separate-output --no-cancel --checklist "Would you like to install any extra 3rd party software?" 21 70 21)
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
        1) port="audio/audacity";;
        2) port="sysutils/xfburn";;
        3) port="multimedia/handbrake";;
        4) port="sysutils/somaster";;
        5) port="editors/abiword";;
        6) port="math/gnumeric";;
        7) port="net-p2p/transmission-gtk";;
        8) port="audio/asunder";;
        9) port="graphics/gimp";;
        10) port="graphics/inkscape";;
        11) port="graphics/pinta";;
        12) port="graphics/shotwell";;
        13) port="emulators/virtualbox-ose";;
        14) port="emulators/wine";;
        n) continue
    esac
    portmaster -y $port
    clear
done
