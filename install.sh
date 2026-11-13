#!/bin/bash
# Flipt installer (Ubuntu, GNOME + Wayland).
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"
AUTOSTART="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"
HOTKEY="${FLIPT_HOTKEY:-<Super>t}"

echo "==> Checking dependencies"
missing=()
command -v wl-paste >/dev/null || missing+=(wl-clipboard)
command -v ydotool  >/dev/null || missing+=(ydotool)
command -v zenity   >/dev/null || missing+=(zenity)
command -v notify-send >/dev/null || missing+=(libnotify-bin)
python3 -c 'import gi; gi.require_version("Gtk", "3.0")' 2>/dev/null || missing+=(python3-gi gir1.2-gtk-3.0)
python3 -c 'import gi; gi.require_version("AyatanaAppIndicator3", "0.1")' 2>/dev/null \
    || python3 -c 'import gi; gi.require_version("AppIndicator3", "0.1")' 2>/dev/null \
    || missing+=(gir1.2-ayatanaappindicator3-0.1)
if [ ${#missing[@]} -gt 0 ]; then
    echo "    Installing: ${missing[*]}"
    sudo apt install -y "${missing[@]}"
fi
if [ ! -x "$BIN/claude" ] && ! command -v claude >/dev/null; then
    echo "ERROR: Claude Code CLI not found. Install it first: https://claude.com/claude-code" >&2
    exit 1
fi

echo "==> Installing the script: $BIN/flipt"
mkdir -p "$BIN" "$APPS"
install -m 755 "$HERE/flipt" "$BIN/flipt"

echo "==> Menu entry: $APPS/flipt.desktop"
cat > "$APPS/flipt.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Flipt
GenericName=Translator
Comment=Translate the selected text with Claude — settings
Comment[uz]=Belgilangan matnni Claude orqali tarjima qilish — sozlamalar
Comment[ru]=Перевод выделенного текста через Claude — настройки
Exec=$BIN/flipt --settings
Icon=accessories-dictionary
Terminal=false
Categories=Utility;
Keywords=flipt;tarjima;translate;translator;claude;perevod;
Actions=translate;settings;about;

[Desktop Action translate]
Name=Translate the selected text
Name[uz]=Belgilangan matnni tarjima qilish
Name[ru]=Перевести выделенный текст
Exec=$BIN/flipt

[Desktop Action settings]
Name=Settings
Name[uz]=Sozlamalar
Name[ru]=Настройки
Exec=$BIN/flipt --settings

[Desktop Action about]
Name=About
Name[uz]=Dastur haqida
Name[ru]=О программе
Exec=$BIN/flipt --about
DESKTOP
update-desktop-database "$APPS" 2>/dev/null || true

# ydotool simulates key presses through /dev/uinput.
if [ ! -w /dev/uinput ]; then
    echo "==> Access to /dev/uinput (needs sudo)"
    echo 'KERNEL=="uinput", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/60-uinput.rules >/dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger /dev/uinput
fi

# Top-bar icon: start it at every login, and right now.
echo "==> Top-bar icon: $AUTOSTART/flipt-tray.desktop"
mkdir -p "$AUTOSTART"
cat > "$AUTOSTART/flipt-tray.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Flipt
Comment=Flipt top-bar icon
Exec=$BIN/flipt --tray
Icon=accessories-dictionary
Terminal=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
DESKTOP
"$BIN/flipt" --tray-stop
setsid -f "$BIN/flipt" --tray >/dev/null 2>&1 || true

echo "==> Hotkey: $HOTKEY"
SCHEMA=org.gnome.settings-daemon.plugins.media-keys
KPATH=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flipt/
current=$(gsettings get $SCHEMA custom-keybindings)
case "$current" in
    *"$KPATH"*) ;;                                              # already registered
    "@as []"|"[]") gsettings set $SCHEMA custom-keybindings "['$KPATH']" ;;
    *) gsettings set $SCHEMA custom-keybindings "${current%]}, '$KPATH']" ;;
esac
gsettings set $SCHEMA.custom-keybinding:$KPATH name 'Flipt (Claude)'
gsettings set $SCHEMA.custom-keybinding:$KPATH command "$BIN/flipt"
gsettings set $SCHEMA.custom-keybinding:$KPATH binding "$HOTKEY"

echo
echo "Done. Select some text and press $HOTKEY, or use the Flipt icon in the top bar."
echo "Settings: open \"Flipt\" from the applications menu, or run: flipt --settings"
