#!/usr/local/bin/bash
cmd=(dialog --separate-output --no-cancel --checklist "Would you like to install any extra 3rd party software?" 21 70 21)
options=(1 "Audacity (audio editor)" off
         2 "Handbrake (video file converter)" off
         3 "ISO Master (ISO file editor)" off
         4 "AbiWord (word processor)" off
         5 "Gnumeric (speadsheet)" off
         6 "Transmission (torrent downloader)" off
         7 "Asunder (CD ripper)" off
         8 "GIMP (image editor)" off
         9 "Inkskape (vector graphics editor)" off
         10 "Pinta (image editor similar to Paint.NET on Windows)" off
         11 "Shotwell (photo organizer/editor)" off
         12 "VirtualBox (run multiple operating systems on your PC)" off
         13 "Wine (run Windows applications)" off
         n "No, don't install any 3rd party software." off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1) port="audio/audacity";;
        2) port="multimedia/handbrake";;
        3) port="sysutils/isomaster";;
        4) port="editors/abiword";;
        5) port="math/gnumeric";;
        6) port="net-p2p/transmission-gtk";;
        7) port="audio/asunder";;
        8) port="graphics/gimp";;
        9) port="graphics/inkscape";;
        10) port="graphics/pinta";;
        11) port="graphics/shotwell";;
        12) port="emulators/virtualbox-ose emulators/virtualbox-ose-kmod"
        echo "" >> /etc/make.conf
        echo "# VirtualBox Options" >> /etc/make.conf
        echo "emulators_virtualbox-ose_SET=GUESTADDITIONS" >> /etc/make.conf
        sysrc vboxnet_enable="YES"
        echo "### VirtualBox stuff ###" >> /etc/sysctl.conf
        echo vfs.aio.max_buf_aio=8192 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_queue_per_proc=65536 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_per_proc=8192 >> /etc/sysctl.conf
        echo vfs.aio.max_aio_queue=65536 >> /etc/sysctl.conf;;
        13) port="emulators/wine"
        echo "" >> /etc/make.conf
        echo "# Wine Options" >> /etc/make.conf
        echo "emulators_wine_SET=MONO" >> /etc/make.conf
        echo "" >> /boot/loader.conf
        echo "# Wine fix" >> /boot/loader.conf
        echo machdep.max_ldt_segment=2048 >> /boot/loader.conf;;
        n) continue
    esac
    portmaster --no-confirm $port
    clear
done
