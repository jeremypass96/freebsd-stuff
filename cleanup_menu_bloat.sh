#!/bin/sh

# =============================
# KDE/Qt Desktop Entry Cleanup
# Jeremy's BeastieBox Edition 😈
# =============================

APP_DIR="/usr/local/share/applications"
BLOAT_DESKTOP_FILES="
org.kde.plasma.cuttlefish.desktop
org.kde.plasma.themeexplorer.desktop
org.kde.plasmaengineexplorer.desktop
org.kde.plasma.lookandfeelexplorer.desktop
org.kde.kuserfeedback-console.desktop
usr_local_lib_qt5_bin_assistant.desktop
usr_local_lib_qt5_bin_designer.desktop
usr_local_lib_qt5_bin_linguist.desktop
"

echo "🧹 Starting desktop entry cleanup..."

for FILE in $BLOAT_DESKTOP_FILES; do
  FULL_PATH="$APP_DIR/$FILE"

  if [ -f "$FULL_PATH" ]; then
    echo "[✔] Removing $FILE"
    rm -f "$FULL_PATH"
  else
    echo "[ℹ] $FILE not found (already gone?)"
  fi
done

echo "✅ Cleanup complete!"