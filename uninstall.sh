#!/bin/bash
# Flipt uninstaller. Removes everything install.sh put in place.
#
#   ./uninstall.sh           keep the settings and the translation history
#   ./uninstall.sh --purge   remove them as well

BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"
AUTOSTART="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"
ICONS="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/flipt"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/flipt"

echo "==> Stopping the top-bar icon"
[ -x "$BIN/flipt" ] && "$BIN/flipt" --tray-stop
rm -f "${XDG_RUNTIME_DIR:-/tmp}/flipt-tray.pid"

echo "==> Removing the hotkey"
SCHEMA=org.gnome.settings-daemon.plugins.media-keys
KPATH=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flipt/
if command -v gsettings >/dev/null; then
    current=$(gsettings get $SCHEMA custom-keybindings 2>/dev/null)
    case "$current" in
        *"$KPATH"*)
            # Drop our entry from the list and keep everybody else's.
            new=$(printf '%s' "$current" | sed -e "s|, *'$KPATH'||" -e "s|'$KPATH', *||" -e "s|'$KPATH'||")
            [ "$new" = "[]" ] && new="@as []"
            gsettings set $SCHEMA custom-keybindings "$new"
            ;;
    esac
    for key in name command binding; do
        gsettings reset $SCHEMA.custom-keybinding:$KPATH $key 2>/dev/null
    done
fi

echo "==> Removing files"
rm -f "$BIN/flipt" \
      "$APPS/flipt.desktop" \
      "$AUTOSTART/flipt-tray.desktop" \
      "$ICONS/scalable/apps/flipt.svg" \
      "$ICONS/symbolic/apps/flipt-symbolic.svg"
update-desktop-database "$APPS" 2>/dev/null || true
gtk-update-icon-cache -q -t -f "$ICONS" 2>/dev/null || true

if [ "$1" = "--purge" ]; then
    echo "==> Removing the settings and the history"
    rm -rf "$CONF_DIR" "$DATA_DIR"
else
    echo "    Kept: $CONF_DIR (settings), $DATA_DIR (history). Use --purge to remove them."
fi

echo
echo "Done."
if [ -f /etc/udev/rules.d/60-uinput.rules ]; then
    echo "The /dev/uinput access rule was left in place (other tools may rely on it). To remove it:"
    echo "  sudo rm /etc/udev/rules.d/60-uinput.rules && sudo udevadm control --reload-rules"
fi
echo "Packages installed as dependencies (wl-clipboard, ydotool, ...) were not removed."
