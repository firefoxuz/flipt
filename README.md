# Tarjima

**English** · [Русский](README.ru.md) · [O'zbekcha](README.uz.md)

A small Linux app that translates the selected text with the [Claude Code](https://claude.com/claude-code) CLI
and, once you approve the result, puts it in place of the original.
("Tarjima" is Uzbek for "translation".)

1. Select text in any application.
2. Press `Super+T`.
3. The translation appears in a window — edit it if needed.
4. Click **Almashtirish** (Replace) and the selected text is replaced with the translation.

> The app's interface is in Uzbek.

## Requirements

- Ubuntu, GNOME, Wayland session (tested on 22.04)
- [Claude Code CLI](https://claude.com/claude-code) installed and signed in (the `claude` command must work)
- `wl-clipboard`, `ydotool`, `zenity`, `python3-gi` — the installer sets these up

## Installation

```bash
git clone git@github.com:firefoxuz/inplace-translator.git
cd inplace-translator
./install.sh
```

The installer:

- copies the script to `~/.local/bin/tarjima`;
- adds a **Tarjima** entry to the applications menu;
- grants access to `/dev/uinput` so that `ydotool` works (asks for `sudo`);
- registers the `Super+T` hotkey. For a different key: `TARJIMA_HOTKEY='<Super>y' ./install.sh`

> Access to `/dev/uinput` lets any program running under your user simulate key presses.
> Intended for a personal computer.

## Settings

Open **Tarjima** from the applications menu, or run `tarjima --settings`:

- **Tarjima tili** (target language) — pick from the list or type one (English name: `French`, `Korean`…)
- **Model** — Haiku / Sonnet / Opus / Fable, latest or a pinned version
- **Qoidalar** (rules) — an extra prompt for the translation, for example:
  "Translate in a formal tone. Do not translate technical terms."

Everything is stored in `~/.config/tarjima/config.conf`, which you can also edit by hand:

```
LANG=Russian
MODEL=sonnet

[PROMPT]
Translate in a formal tone.
Do not translate technical terms (API, deploy, commit).
```

## Commands

| Command | What it does |
|---|---|
| `tarjima` | translates the selected text into the configured language (this is what the hotkey runs) |
| `tarjima Russian` | one-off translation into another language |
| `tarjima --settings` | settings window |
| `tarjima --show` | current settings |
| `echo "text" \| tarjima --stdin` | no window, the result is printed to the terminal |

## Limitations

- Automatic paste does not work inside a terminal (paste there is `Ctrl+Shift+V`). The translation stays in the clipboard.
- Each translation starts `claude` from scratch, so a reply takes 2–5 seconds.
- Does not work in an X11 session (`wl-clipboard` is Wayland-only).
