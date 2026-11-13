#!/bin/bash
# Tarjima o'rnatuvchisi (Ubuntu, GNOME + Wayland).
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"
HOTKEY="${TARJIMA_HOTKEY:-<Super>t}"

echo "==> Bog'liqliklar tekshirilmoqda"
missing=()
command -v wl-paste >/dev/null || missing+=(wl-clipboard)
command -v ydotool  >/dev/null || missing+=(ydotool)
command -v zenity   >/dev/null || missing+=(zenity)
command -v notify-send >/dev/null || missing+=(libnotify-bin)
python3 -c 'import gi; gi.require_version("Gtk", "3.0")' 2>/dev/null || missing+=(python3-gi gir1.2-gtk-3.0)
if [ ${#missing[@]} -gt 0 ]; then
    echo "    O'rnatilmoqda: ${missing[*]}"
    sudo apt install -y "${missing[@]}"
fi
if [ ! -x "$BIN/claude" ] && ! command -v claude >/dev/null; then
    echo "XATO: Claude Code CLI topilmadi. Avval uni o'rnating: https://claude.com/claude-code" >&2
    exit 1
fi

echo "==> Skript o'rnatilmoqda: $BIN/tarjima"
mkdir -p "$BIN" "$APPS"
install -m 755 "$HERE/tarjima" "$BIN/tarjima"

echo "==> Menyu yorlig'i: $APPS/tarjima.desktop"
cat > "$APPS/tarjima.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Tarjima
GenericName=Translator
Comment=Belgilangan matnni Claude orqali tarjima qilish — sozlamalar
Exec=$BIN/tarjima --settings
Icon=accessories-dictionary
Terminal=false
Categories=Utility;
Keywords=tarjima;translate;claude;perevod;
Actions=translate;

[Desktop Action translate]
Name=Belgilangan matnni tarjima qilish
Exec=$BIN/tarjima
DESKTOP
update-desktop-database "$APPS" 2>/dev/null || true

# ydotool klaviatura bosishini /dev/uinput orqali simulyatsiya qiladi.
if [ ! -w /dev/uinput ]; then
    echo "==> /dev/uinput ruxsati (sudo kerak)"
    echo 'KERNEL=="uinput", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/60-uinput.rules >/dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger /dev/uinput
fi

echo "==> Hotkey: $HOTKEY"
SCHEMA=org.gnome.settings-daemon.plugins.media-keys
KPATH=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/tarjima/
current=$(gsettings get $SCHEMA custom-keybindings)
case "$current" in
    *"$KPATH"*) ;;                                              # allaqachon ro'yxatda
    "@as []"|"[]") gsettings set $SCHEMA custom-keybindings "['$KPATH']" ;;
    *) gsettings set $SCHEMA custom-keybindings "${current%]}, '$KPATH']" ;;
esac
gsettings set $SCHEMA.custom-keybinding:$KPATH name 'Tarjima (Claude)'
gsettings set $SCHEMA.custom-keybinding:$KPATH command "$BIN/tarjima"
gsettings set $SCHEMA.custom-keybinding:$KPATH binding "$HOTKEY"

echo
echo "Tayyor. Matnni belgilang va $HOTKEY bosing."
echo "Sozlamalar: ilovalar menyusidan «Tarjima» yoki: tarjima --settings"
