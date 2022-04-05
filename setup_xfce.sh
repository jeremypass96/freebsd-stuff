#!/bin/sh
# This script will set up a complete FreeBSD desktop for you, ready to go when you reboot.

# Checking to see if we're running as root.
if [ $(id -u) -ne 0 ] ; then
echo "Please run this setup script as root via 'su'! Thanks."
exit
fi

clear

echo "Welcome to the FreeBSD Xfce setup script."
echo "This script will setup Xorg, Xfce, some useful software for you, along with the rc.conf file being tweaked for desktop use."
echo ""
read -p "Press any key to continue..." resp

clear

read -p "Do you plan to install software via pkg (binary packages) or ports (FreeBSD Ports tree)? (pkg/ports): " resp
if [ 0"$resp" = 0pkg ]; then

# Update repo to use latest packages.
mkdir -p /usr/local/etc/pkg/repos
cat << EOF > /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { 
  url: "http://pkg0.nyi.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
EOF
pkg update
echo ""

read -p "Do you plan to use a printer? (y/n): " resp
if [ 0"$resp" = 0y ]; then
pkg install -y cups
sysrc cupsd_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ 0"$resp" = 0Letter ]; then
pkg install -y papersize-default-letter
fi
if [ 0"$resp" = 0A4 ]; then
pkg install -y papersize-default-a4
fi
fi
if [ 0"$resp" = 0n ]; then
continue
fi

clear

# Install packages.
pkg install -y sudo xorg-minimal xorg-drivers xorg-fonts xorg-libraries noto-basic noto-emoji xfce xfce4-goodies skeuos-gtk-themes papirus-icon-theme epdfview catfish galculator xarchiver xfce4-docklike-plugin xfce4-pulseaudio-plugin font-manager qt5ct qt5-style-plugins firefox webfonts micro xclip zsh ohmyzsh neofetch lightdm slick-greeter mp4v2 numlockx devcpu-data automount unix2dos smartmontools ubuntu-font office-code-pro webfonts droid-fonts-ttf materialdesign-ttf roboto-fonts-ttf xdg-user-dirs duf colorize
pkg clean -y

# Setup rc.conf file.
./rcconf_setup.sh

clear

read -p "Do you want to install any extra 3rd party software?

1. Audacity (audio editor)
2. Xfburn (CD burner)
3. Handbrake (video file converter)
4. ISO Master (ISO file editor)
5. AbiWord (word processor)
6. Gnumeric (speadsheet)
7. Transmission (Torrent downloader)
8. Asunder (CD ripper)
9. GIMP (image editor)
10. Inkskape (vector graphics editor)
11. Pinta (image editor similar to Paint.NET on Windows)
12. Shotwell (photo organizer/editor)
13. VirtualBox (run multiple operating systems on your PC)
14. Wine (run Windows applications)

15. All of the above.
16. None of the above.
-> " resp
if [ 0"$resp" = 01 ]; then
pkg install -y audacity
if [ 0"$resp" = 02 ]; then
pkg install -y xfburn
if [ 0"$resp" = 03 ]; then
pkg install -y handbrake
if [ 0"$resp" = 04 ]; then
pkg install -y isomaster
if [ 0"$resp" = 05 ]; then
pkg install -y abiword
if [ 0"$resp" = 06 ]; then
pkg install -y gnumeric
if [ 0"$resp" = 07 ]; then
pkg install -y transmission-gtk
if [ 0"$resp" = 08 ]; then
pkg install -y asunder
if [ 0"$resp" = 09 ]; then
pkg install -y gimp
if [ 0"$resp" = 010 ]; then
pkg install -y inkscape
if [ 0"$resp" = 011 ]; then
pkg install -y pinta
if [ 0"$resp" = 012 ]; then
pkg install -y shotwell
if [ 0"$resp" = 013 ]; then
pkg install -y virtualbox-ose
if [ 0"$resp" = 014 ]; then
pkg install -y wine wine-mono wine-gecko
if [ 0"$resp" = 015 ]; then
pkg install -y audacity xfburn handbrake isomaster abiword gnumeric transmission-gtk asunder gimp inkscape pinta shotwell virtualbox-ose wine wine-mono wine-gecko
if [ 0"$resp" = 016 ]; then
continue
fi

if [ 0"$resp" = 0ports ]; then

# Copying over make.conf file.
cp -v make.conf /etc/

# Configure the MAKE_JOBS_NUMBER line in make.conf
sed -i '' s/MAKE_JOBS_NUMBER=/MAKE_JOBS_NUMBER=`sysctl -n hw.ncpu`/g /etc/make.conf

# Avoid pulling in Ports tree categories with non-English languages.
sed -i '' s/"#REFUSE arabic chinese french german hebrew hungarian japanese/REFUSE arabic chinese french german hebrew hungarian japanese"/g /etc/portsnap.conf
sed -i '' s/"#REFUSE korean polish portuguese russian ukrainian vietnamese/REFUSE korean polish portuguese russian ukrainian vietnamese"/g /etc/portsnap.conf

# Pull in Ports tree, extract, and update it.
portsnap auto

clear

read -p "Do you plan to use a printer? (y/n): " resp
if [ 0"$resp" = 0y ]; then
sed -i '' '13s/$/ CUPS/' /etc/make.conf
cd /usr/ports/print/cups && make install clean
sysrc cupsd_enable="YES"
read -p "Paper size? (Letter/A4): " resp
if [ 0"$resp" = 0Letter ]; then
cd /usr/ports/print/papersize-default-letter && make install clean
fi
if [ 0"$resp" = 0A4 ]; then
cd /usr/ports/print/papersize-default-a4 && make install clean
fi
fi
if [ 0"$resp" = 0n ]; then
sed -i '' '14s/$/ CUPS/' /etc/make.conf
continue
fi

# Adding in make.conf options for Xfce.
echo "Xfce Options" >> /etc/make.conf
echo "x11-wm_xfce4_SET=LIGHTDM" >> /etc/make.conf
echo "x11-wm_xfce4_UNSET=GREYBIRD" >> /etc/make.conf

clear

# Install Ports.
cd /usr/ports/security/sudo && make install clean
cd /usr/ports/editors/micro && make install clean
cd /usr/ports/x11/xclip && make install clean
cd /usr/ports/shells/zsh && make install clean
cd /usr/ports/shells/ohmyzsh && make install clean
cd /usr/ports/sysutils/neofetch && make install clean
cd /usr/ports/x11/xorg && make install clean
cd /usr/ports/x11-wm/xfce4 && make install clean
cd /usr/ports/x11/xfce4-goodies && make install clean
cd /usr/ports/x11-themes/skeuos-gtk-themes && make install clean
cd /usr/ports/x11-themes/papirus-icon-theme && make install clean
cd /usr/ports/graphics/epdfview && make install clean
cd /usr/ports/sysutils/catfish && make install clean
cd /usr/ports/math/galculator && make install clean
cd /usr/ports/archivers/xarchiver && make install clean
cd /usr/ports/x11/xfce4-docklike-plugin && make install clean
cd /usr/ports/audio/xfce4-pulseaudio-plugin && make install clean
cd /usr/ports/x11-fonts/font-manager && make install clean
cd /usr/ports/misc/qt5ct && make install clean
cd /usr/ports/x11-themes/qt5-style-plugins && make install clean
cd /usr/ports/www/firefox && make install clean
cd /usr/ports/x11-fonts/noto && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/sysutils/gksu && make install clean
cd /usr/ports/x11/slick-greeter && make install clean
cd /usr/ports/multimedia/mp4v2 && make install clean
cd /usr/ports/x11/numlockx && make install clean
cd /usr/ports/sysutils/devcpu-data && make install clean
cd /usr/ports/sysutils/automount && make install clean
cd /usr/ports/converters/unix2dos && make install clean
cd /usr/ports/sysutils/smartmontools && make install clean
cd /usr/ports/x11-fonts/ubuntu-font && make install clean
cd /usr/ports/x11-fonts/office-code-pro && make install clean
cd /usr/ports/x11-fonts/webfonts && make install clean
cd /usr/ports/x11-fonts/droid-fonts-ttf && make install clean
cd /usr/ports/x11-fonts/materialdesign-ttf && make install clean
cd /usr/ports/x11-fonts/roboto-fonts-ttf && make install clean
cd /usr/ports/devel/xdg-user-dirs && make install clean
cd /usr/ports/sysutils/duf && make install clean
cd /usr/ports/sysutils/colorize && make install clean
cd /usr/ports/ports-mgmt/portmaster && make install clean

# Setup rc.conf file.
cd /home/$USER/freebsd-setup-scripts
./rcconf_setup_ports.sh

clear

read -p "Do you want to install any extra 3rd party software?

1. Audacity (audio editor)
2. Xfburn (CD burner)
3. Handbrake (video file converter)
4. ISO Master (ISO file editor)
5. AbiWord (word processor)
6. Gnumeric (speadsheet)
7. Transmission (Torrent downloader)
8. Asunder (CD ripper)
9. GIMP (image editor)
10. Inkskape (vector graphics editor)
11. Pinta (image editor similar to Paint.NET on Windows)
12. Shotwell (photo organizer/editor)
13. VirtualBox (run multiple operating systems on your PC)
14. Wine (run Windows applications)

15. All of the above.
16. None of the above.
-> " resp
if [ 0"$resp" = 01 ]; then
cd /usr/ports/audio/audacity && make install clean
if [ 0"$resp" = 02 ]; then
cd /usr/ports/sysutils/xfburn && make install clean
if [ 0"$resp" = 03 ]; then
cd /usr/ports/multimedia/handbrake && make install clean
if [ 0"$resp" = 04 ]; then
cd /usr/ports/sysutils/isomaster && make install clean
if [ 0"$resp" = 05 ]; then
cd /usr/ports/editors/abiword && make install clean
if [ 0"$resp" = 06 ]; then
cd /usr/ports/math/gnumeric && make install clean
if [ 0"$resp" = 07 ]; then
cd /usr/ports/net-p2p/transmission-gtk && make install clean
if [ 0"$resp" = 08 ]; then
cd /usr/ports/audio/asunder && make install clean
if [ 0"$resp" = 09 ]; then
cd /usr/ports/graphics/gimp && make install clean
if [ 0"$resp" = 010 ]; then
cd /usr/ports/graphics/inkscape && make install clean
if [ 0"$resp" = 011 ]; then
cd /usr/ports/graphics/pinta && make install clean
if [ 0"$resp" = 012 ]; then
cd /usr/ports/graphics/shotwell && make install clean
if [ 0"$resp" = 013 ]; then
cd /usr/ports/emulators/virtualbox-ose && make install clean
if [ 0"$resp" = 014 ]; then
cd /usr/ports/emulators/wine && make install clean
cd /usr/ports/emulators/wine-gecko && make install clean
if [ 0"$resp" = 015 ]; then
portmaster -y audio/audacity sysutils/xfburn multimedia/handbrake sysutils/isomaster editors/abiword math/gnumeric net-p2p/transmission-gtk audio/asunder graphics/gimp graphics/inkscape graphics/pinta graphics/shotwell emulators/virtualbox-ose emulators/wine emulators/wine-gecko
if [ 0"$resp" = 016 ]; then
continue
fi

# Install Mousepad text editor color scheme.
fetch https://raw.githubusercontent.com/isdampe/gedit-gtk-one-dark-style-scheme/master/onedark-bright.xml -o /usr/local/share/gtksourceview-3.0/styles/onedark-bright.xml

# Setup Xfce4 Terminal colors.
mkdir -p /home/$USER/.config/xfce4/terminal/colorschemes
chown $USER:$USER /home/$USER/.config/xfce4/terminal
chown $USER:$USER /home/$USER/.config/xfce4/terminal/colorschemes
fetch https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/xfce4terminal/colorschemes/Andromeda.theme -o /home/$USER/.config/xfce4/terminal/colorschemes/Andromeda.theme
cat << EOF > /home/$USER/.config/xfce4/terminal/terminalrc
[Configuration]
ColorForeground=#e5e5e5
ColorBackground=#262a33
ColorCursor=#f8f8f0
ColorPalette=#000000;#cd3131;#05bc79;#e5e512;#2472c8;#bc3fbc;#0fa8cd;#e5e5e5;#666666;#cd3131;#05bc79;#e5e512;#2472c8;#bc3fbc;#0fa8cd;#e5e5e5
MiscAlwaysShowTabs=FALSE
MiscBell=TRUE
MiscBellUrgent=TRUE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=155x40
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=TRUE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=TRUE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=TRUE
MiscSearchDialogOpacity=100
MiscShowUnsafePasteDialog=TRUE
FontUseSystem=TRUE
ShortcutsNoMenukey=TRUE
EOF
chown $USER:$USER /home/$USER/.config/xfce4/terminal/terminalrc
cp -v /home/$USER/.config/xfce4/terminal/terminalrc /usr/share/skel/dot.config/xfce4/terminal/terminalrc
#####

# Setup shutdown/sleep rules for Xfce.
cat << EOF > /usr/local/etc/polkit-1/rules.d/60-shutdown.rules
polkit.addRule(function (action, subject) {
  if ((action.id == "org.freedesktop.consolekit.system.restart" ||
      action.id == "org.freedesktop.consolekit.system.stop")
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
cat << EOF > /usr/local/etc/polkit-1/rules.d/70-sleep.rules
polkit.addRule(function (action, subject) {
  if (action.id == "org.freedesktop.consolekit.system.suspend"
      && subject.isInGroup("operator")) {
    return polkit.Result.YES;
  }
});
EOF
#####
pw group mod operator -m $USER

# Install cursor theme.
echo "Installing the "Volantes Light Cursors" cursor theme..."
tar -xf volantes_light_cursors.tar.gz -C /usr/local/share/icons
rm -rf volantes_light_cursors.tar.gz

# Setup Xfce preferences.
mkdir -p /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml
chown $USER:$USER /home/$USER/.config/xfce4/xfconf
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml
cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/local/share/backgrounds/xfce/xfce-verticals.png"/>
        </property>
        <property name="workspace1" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/local/share/backgrounds/xfce/xfce-verticals.png"/>
        </property>
        <property name="workspace2" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/local/share/backgrounds/xfce/xfce-verticals.png"/>
        </property>
        <property name="workspace3" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/local/share/backgrounds/xfce/xfce-verticals.png"/>
        </property>
      </property>
    </property>
  </property>
  <property name="desktop-menu" type="empty">
    <property name="show-icons" type="bool" value="false"/>
    <property name="show" type="bool" value="false"/>
  </property>
  <property name="windowlist-menu" type="empty">
    <property name="show-icons" type="bool" value="true"/>
    <property name="show-workspace-names" type="bool" value="true"/>
    <property name="show-submenus" type="bool" value="false"/>
    <property name="show-add-remove-workspaces" type="bool" value="false"/>
  </property>
  <property name="desktop-icons" type="empty">
    <property name="file-icons" type="empty">
      <property name="show-filesystem" type="bool" value="false"/>
    </property>
  </property>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
mkdir -p /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="dark-mode" type="bool" value="false"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=960;y=963"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="24"/>
      <property name="size" type="uint" value="40"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="8"/>
        <value type="int" value="7"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="10"/>
        <value type="int" value="13"/>
        <value type="int" value="16"/>
        <value type="int" value="17"/>
      </property>
      <property name="mode" type="uint" value="0"/>
      <property name="disable-struts" type="bool" value="false"/>
      <property name="nrows" type="uint" value="1"/>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-3" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-4" type="string" value="pager">
      <property name="rows" type="uint" value="2"/>
      <property name="miniature-view" type="bool" value="true"/>
    </property>
    <property name="plugin-5" type="string" value="separator">
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-6" type="string" value="systray">
      <property name="square-icons" type="bool" value="true"/>
      <property name="hidden-items" type="array">
      </property>
      <property name="icon-size" type="int" value="0"/>
      <property name="hidden-legacy-items" type="array">
      </property>
      <property name="single-row" type="bool" value="true"/>
      <property name="hide-new-items" type="bool" value="false"/>
    </property>
    <property name="plugin-10" type="string" value="notification-plugin"/>
    <property name="plugin-7" type="string" value="docklike"/>
    <property name="plugin-8" type="string" value="whiskermenu"/>
    <property name="clipman" type="empty">
      <property name="settings" type="empty">
        <property name="enable-actions" type="bool" value="true"/>
      </property>
      <property name="tweaks" type="empty">
        <property name="never-confirm-history-clear" type="bool" value="true"/>
      </property>
    </property>
    <property name="plugin-13" type="string" value="pulseaudio">
      <property name="enable-keyboard-shortcuts" type="bool" value="true"/>
    </property>
    <property name="plugin-16" type="string" value="datetime"/>
    <property name="plugin-17" type="string" value="showdesktop"/>
  </property>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="activate_action" type="string" value="bring"/>
    <property name="borderless_maximize" type="bool" value="true"/>
    <property name="box_move" type="bool" value="false"/>
    <property name="box_resize" type="bool" value="false"/>
    <property name="button_layout" type="string" value="O|HMC"/>
    <property name="button_offset" type="int" value="0"/>
    <property name="button_spacing" type="int" value="0"/>
    <property name="click_to_focus" type="bool" value="true"/>
    <property name="cycle_apps_only" type="bool" value="false"/>
    <property name="cycle_draw_frame" type="bool" value="true"/>
    <property name="cycle_raise" type="bool" value="false"/>
    <property name="cycle_hidden" type="bool" value="true"/>
    <property name="cycle_minimum" type="bool" value="true"/>
    <property name="cycle_minimized" type="bool" value="false"/>
    <property name="cycle_preview" type="bool" value="true"/>
    <property name="cycle_tabwin_mode" type="int" value="0"/>
    <property name="cycle_workspaces" type="bool" value="false"/>
    <property name="double_click_action" type="string" value="maximize"/>
    <property name="double_click_distance" type="int" value="5"/>
    <property name="double_click_time" type="int" value="250"/>
    <property name="easy_click" type="string" value="Alt"/>
    <property name="focus_delay" type="int" value="250"/>
    <property name="focus_hint" type="bool" value="true"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="frame_opacity" type="int" value="100"/>
    <property name="frame_border_top" type="int" value="0"/>
    <property name="full_width_title" type="bool" value="true"/>
    <property name="horiz_scroll_opacity" type="bool" value="false"/>
    <property name="inactive_opacity" type="int" value="100"/>
    <property name="maximized_offset" type="int" value="0"/>
    <property name="mousewheel_rollup" type="bool" value="true"/>
    <property name="move_opacity" type="int" value="100"/>
    <property name="placement_mode" type="string" value="center"/>
    <property name="placement_ratio" type="int" value="20"/>
    <property name="popup_opacity" type="int" value="100"/>
    <property name="prevent_focus_stealing" type="bool" value="true"/>
    <property name="raise_delay" type="int" value="250"/>
    <property name="raise_on_click" type="bool" value="true"/>
    <property name="raise_on_focus" type="bool" value="false"/>
    <property name="raise_with_any_button" type="bool" value="true"/>
    <property name="repeat_urgent_blink" type="bool" value="false"/>
    <property name="resize_opacity" type="int" value="100"/>
    <property name="scroll_workspaces" type="bool" value="false"/>
    <property name="shadow_delta_height" type="int" value="0"/>
    <property name="shadow_delta_width" type="int" value="0"/>
    <property name="shadow_delta_x" type="int" value="0"/>
    <property name="shadow_delta_y" type="int" value="-3"/>
    <property name="shadow_opacity" type="int" value="50"/>
    <property name="show_app_icon" type="bool" value="false"/>
    <property name="show_dock_shadow" type="bool" value="true"/>
    <property name="show_frame_shadow" type="bool" value="true"/>
    <property name="show_popup_shadow" type="bool" value="true"/>
    <property name="snap_resist" type="bool" value="false"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="snap_width" type="int" value="10"/>
    <property name="vblank_mode" type="string" value="auto"/>
    <property name="theme" type="string" value="Skeuos-Blue-Dark-XFWM"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="title_alignment" type="string" value="center"/>
    <property name="title_font" type="string" value="Poppins Bold 10"/>
    <property name="title_horizontal_offset" type="int" value="0"/>
    <property name="titleless_maximize" type="bool" value="false"/>
    <property name="title_shadow_active" type="string" value="false"/>
    <property name="title_shadow_inactive" type="string" value="false"/>
    <property name="title_vertical_offset_active" type="int" value="0"/>
    <property name="title_vertical_offset_inactive" type="int" value="0"/>
    <property name="toggle_workspaces" type="bool" value="false"/>
    <property name="unredirect_overlays" type="bool" value="true"/>
    <property name="urgent_blink" type="bool" value="false"/>
    <property name="use_compositing" type="bool" value="true"/>
    <property name="workspace_count" type="int" value="4"/>
    <property name="wrap_cycle" type="bool" value="true"/>
    <property name="wrap_layout" type="bool" value="true"/>
    <property name="wrap_resistance" type="int" value="10"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="wrap_workspaces" type="bool" value="false"/>
    <property name="zoom_desktop" type="bool" value="true"/>
    <property name="zoom_pointer" type="bool" value="true"/>
    <property name="workspace_names" type="array">
      <value type="string" value="Workspace 1"/>
      <value type="string" value="Workspace 2"/>
      <value type="string" value="Workspace 3"/>
      <value type="string" value="Workspace 4"/>
    </property>
  </property>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Skeuos-Blue-Dark"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
    <property name="DoubleClickTime" type="empty"/>
    <property name="DoubleClickDistance" type="empty"/>
    <property name="DndDragThreshold" type="empty"/>
    <property name="CursorBlink" type="empty"/>
    <property name="CursorBlinkTime" type="empty"/>
    <property name="SoundThemeName" type="freedesktop"/>
    <property name="EnableEventSounds" type="bool" value="true"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="true"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="empty"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="empty"/>
    <property name="ColorPalette" type="empty"/>
    <property name="FontName" type="string" value="Roboto 9"/>
    <property name="MonospaceFontName" type="string" value="Office Code Pro 12"/>
    <property name="IconSizes" type="empty"/>
    <property name="KeyThemeName" type="empty"/>
    <property name="ToolbarStyle" type="empty"/>
    <property name="ToolbarIconSize" type="empty"/>
    <property name="MenuImages" type="empty"/>
    <property name="ButtonImages" type="empty"/>
    <property name="MenuBarAccel" type="empty"/>
    <property name="CursorThemeName" type="string" value="volantes_light_cursors"/>
    <property name="CursorThemeSize" type="32"/>
    <property name="DecorationLayout" type="empty"/>
    <property name="DialogsUseHeader" type="empty"/>
    <property name="TitlebarMiddleClick" type="empty"/>
  </property>
  <property name="Gdk" type="empty">
    <property name="WindowScalingFactor" type="empty"/>
  </property>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="thunar" version="1.0">
  <property name="last-view" type="string" value="ThunarIconView"/>
  <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
  <property name="last-separator-position" type="int" value="170"/>
  <property name="last-window-width" type="int" value="1049"/>
  <property name="last-window-height" type="int" value="677"/>
  <property name="last-window-maximized" type="bool" value="false"/>
  <property name="last-show-hidden" type="bool" value="false"/>
  <property name="misc-single-click" type="bool" value="false"/>
  <property name="misc-directory-specific-settings" type="bool" value="true"/>
  <property name="misc-thumbnail-draw-frames" type="bool" value="false"/>
  <property name="misc-show-delete-action" type="bool" value="true"/>
  <property name="default-view" type="string" value="ThunarIconView"/>
  <property name="last-location-bar" type="string" value="ThunarLocationButtons"/>
  <property name="misc-recursive-permissions" type="string" value="THUNAR_RECURSIVE_PERMISSIONS_ALWAYS"/>
  <property name="tree-icon-size" type="string" value="THUNAR_ICON_SIZE_16"/>
  <property name="shortcuts-icon-size" type="string" value="THUNAR_ICON_SIZE_16"/>
  <property name="shortcuts-icon-emblems" type="bool" value="true"/>
  <property name="misc-volume-management" type="bool" value="false"/>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-session" version="1.0">
  <property name="general" type="empty">
    <property name="FailsafeSessionName" type="empty"/>
    <property name="LockCommand" type="empty"/>
    <property name="SessionName" type="string" value="Default"/>
    <property name="SaveOnExit" type="bool" value="false"/>
  </property>
  <property name="sessions" type="empty">
    <property name="Failsafe" type="empty">
      <property name="IsFailsafe" type="empty"/>
      <property name="Count" type="empty"/>
      <property name="Client0_Command" type="empty"/>
      <property name="Client0_Priority" type="empty"/>
      <property name="Client0_PerScreen" type="empty"/>
      <property name="Client1_Command" type="empty"/>
      <property name="Client1_Priority" type="empty"/>
      <property name="Client1_PerScreen" type="empty"/>
      <property name="Client2_Command" type="empty"/>
      <property name="Client2_Priority" type="empty"/>
      <property name="Client2_PerScreen" type="empty"/>
      <property name="Client3_Command" type="empty"/>
      <property name="Client3_Priority" type="empty"/>
      <property name="Client3_PerScreen" type="empty"/>
      <property name="Client4_Command" type="empty"/>
      <property name="Client4_Priority" type="empty"/>
      <property name="Client4_PerScreen" type="empty"/>
    </property>
  </property>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml 
#####

cat << EOF > /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-notifyd" version="1.0">
  <property name="plugin" type="empty">
    <property name="hide-clear-prompt" type="bool" value="true"/>
  </property>
  <property name="primary-monitor" type="uint" value="0"/>
  <property name="notify-location" type="uint" value="2"/>
  <property name="log-level" type="uint" value="1"/>
  <property name="log-level-apps" type="uint" value="1"/>
  <property name="theme" type="string" value="Default"/>
  <property name="do-slideout" type="bool" value="true"/>
  <property name="do-fadeout" type="bool" value="true"/>
</channel>
EOF
chown $USER:$USER /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
cp -v /home/$USER/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml /usr/share/skel/dot.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
#####

mkdir -p /home/$USER/.config/xfce4/panel/
cat << EOF > /home/$USER/.config/xfce4/panel/whiskermenu-8.rc
favorites=firefox.desktop,thunar.desktop,org.xfce.mousepad.desktop,xfburn.desktop,xfce4-terminal.desktop,xfce4-taskmanager.desktop
button-icon=distributor-logo-freebsd
button-single-row=true
show-button-title=false
show-button-icon=true
launcher-show-name=true
launcher-show-description=true
launcher-show-tooltip=true
launcher-icon-size=2
hover-switch-category=false
category-show-name=true
category-icon-size=1
sort-categories=true
view-mode=1
default-category=0
recent-items-max=10
favorites-in-recent=true
position-search-alternate=false
position-commands-alternate=false
position-categories-alternate=true
position-categories-horizontal=false
stay-on-focus-out=false
profile-shape=0
confirm-session-command=true
menu-width=450
menu-height=532
menu-opacity=100
command-settings=xfce4-settings-manager
show-command-settings=true
command-lockscreen=xflock4
show-command-lockscreen=true
command-switchuser=dm-tool switch-to-greeter
show-command-switchuser=false
command-logoutuser=xfce4-session-logout --logout --fast
show-command-logoutuser=false
command-restart=xfce4-session-logout --reboot --fast
show-command-restart=false
command-shutdown=xfce4-session-logout --halt --fast
show-command-shutdown=false
command-suspend=xfce4-session-logout --suspend
show-command-suspend=false
command-hibernate=xfce4-session-logout --hibernate
show-command-hibernate=false
command-logout=xfce4-session-logout
show-command-logout=true
command-menueditor=menulibre
show-command-menueditor=false
command-profile=mugshot
show-command-profile=false
search-actions=4

[action0]
name=Search for Files
pattern=-
command=catfish --path=~ --start %s
regex=false

[action1]
name=Wikipedia
pattern=!w
command=exo-open --launch WebBrowser https://en.wikipedia.org/wiki/%u
regex=false

[action2]
name=Run in Terminal
pattern=!
command=exo-open --launch TerminalEmulator %s
regex=false

[action3]
name=Open URI
pattern=^(file|http|https):\\/\\/(.*)$
command=exo-open \\0
regex=true
EOF
chown $USER:$USER /home/$USER/.config/xfce4/panel/whiskermenu-8.rc
mkdir -p /usr/share/skel/dot.config/xfce4/panel
cp -v /home/$USER/.config/xfce4/panel/whiskermenu-8.rc /usr/share/skel/dot.config/xfce4/panel/whiskermenu-8.rc
#####

cat << EOF > /home/$USER/.config/xfce4/panel/docklike-7.rc
[user]
noWindowsListIfSingle=false
onlyDisplayVisible=true
showPreviews=true
showWindowCount=false
indicatorStyle=0
indicatorOrientation=0
pinned=/usr/local/share/applications//firefox.desktop;/usr/local/share/applications//xfce4-terminal.desktop;/usr/local/share/applications//org.xfce.mousepad.desktop;/usr/local/share/applications//xfburn.desktop;/usr/local/share/applications//galculator.desktop;
EOF
chown $USER:$USER /home/$USER/.config/xfce4/panel/docklike-7.rc
cp -v /home/$USER/.config/xfce4/panel/docklike-7.rc /usr/share/skel/dot.config/xfce4/panel/docklike-7.rc
#####

cat << EOF > /home/$USER/.config/xfce4/panel/datetime-16.rc
layout=1
date_font=Roboto 9
time_font=Roboto 9
date_format=%m/%d/%Y
time_format=%l:%M %p
EOF
chown $USER:$USER /home/$USER/.config/xfce4/panel/datetime-16.rc
cp -v /home/$USER/.config/xfce4/panel/datetime-16.rc /usr/share/skel/dot.config/xfce4/panel/datetime-16.rc
#####

# Setup LightDM.
sysrc lightdm_enable="YES"
sed -i '' s/#pam-autologin-service=lightdm-autologin/pam-autologin-service=lightdm-autologin/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-user-switching=true/allow-user-switching=true/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#allow-guest=true/allow-guest=false/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/"#greeter-setup-script=/greeter-setup-script=numlockx on"/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user=/autologin-user=$USER/g /usr/local/etc/lightdm/lightdm.conf
sed -i '' s/#autologin-user-timeout=0/autologin-user-timeout=0/g /usr/local/etc/lightdm/lightdm.conf
mkdir /usr/local/etc/lightdm/wallpaper
fetch https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate13.0/files/wallpaper/centerFlat_grey-4k.png -o /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
chown root:wheel /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png

# Setup slick greeter.
cat << EOF > /usr/local/etc/lightdm/slick-greeter.conf
[Greeter]
background = /usr/local/etc/lightdm/wallpaper/centerFlat_grey-4k.png
draw-user-backgrounds = false
draw-grid = false
show-hostname = true
show-a11y = false
show-keyboard = false
clock-format = %I:%M %p
theme-name = Skeuos-Red-Light
icon-theme-name = Papirus-Light
EOF
