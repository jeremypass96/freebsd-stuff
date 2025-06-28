#!/bin/sh

# BeastieBox Hook Installer
# Installs cleanup_menu_bloat script to run at boot and shutdown

BOOT_SCRIPT="/etc/rc.local"
SHUTDOWN_SCRIPT="/usr/local/etc/rc.d/cleanup_menu_bloat"
CLEANUP_SCRIPT="/root/cleanup_menu_bloat"

# --- Verify the cleanup script exists ---
if [ ! -f "$CLEANUP_SCRIPT" ]; then
  echo "❌ Error: $CLEANUP_SCRIPT not found. Aborting."
  exit 1
fi

# --- Install rc.local for boot-time cleanup ---
echo "Installing boot-time cleanup to $BOOT_SCRIPT..."
cat <<EOF > "$BOOT_SCRIPT"
#!/bin/sh
$CLEANUP_SCRIPT
EOF
chmod +x "$BOOT_SCRIPT"
echo "Boot cleanup installed."

# --- Install shutdown rc.d script ---
echo "Installing shutdown-time cleanup to $SHUTDOWN_SCRIPT..."
cat <<EOF > "$SHUTDOWN_SCRIPT"
#!/bin/sh

# PROVIDE: cleanup_menu_bloat
# REQUIRE: LOGIN
# BEFORE:  shutdown
# KEYWORD: shutdown

. /etc/rc.subr

name="cleanup_menu_bloat"
start_cmd=":"

stop_cmd="$CLEANUP_SCRIPT"

load_rc_config \$name
run_rc_command "\$1"
EOF

chmod +x "$SHUTDOWN_SCRIPT"
echo "Shutdown cleanup installed."

echo "All set! cleanup_menu_bloat will now run at boot and shutdown."