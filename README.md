# Flipt

[English](#english) · [Русский](#русский) · [O'zbekcha](#ozbekcha)

---

## English

A small Linux app that translates the selected text with the [Claude Code](https://claude.com/claude-code) CLI
and, once you approve the result, puts it in place of the original.
(Flipt = flip + text: one key flips your text into another language.)

1. Select text in any application.
2. Press `Super+T`.
3. The translation appears in a window — edit it if needed.
4. Click **Almashtirish** (Replace) and the selected text is replaced with the translation.

> The app's interface is in Uzbek.

### Requirements

- Ubuntu, GNOME, Wayland session (tested on 22.04)
- [Claude Code CLI](https://claude.com/claude-code) installed and signed in (the `claude` command must work)
- `wl-clipboard`, `ydotool`, `zenity`, `python3-gi` — the installer sets these up

### Installation

```bash
git clone git@github.com:firefoxuz/inplace-translator.git
cd inplace-translator
./install.sh
```

The installer:

- copies the script to `~/.local/bin/flipt`;
- adds a **Flipt** entry to the applications menu;
- grants access to `/dev/uinput` so that `ydotool` works (asks for `sudo`);
- registers the `Super+T` hotkey. For a different key: `FLIPT_HOTKEY='<Super>y' ./install.sh`

> Access to `/dev/uinput` lets any program running under your user simulate key presses.
> Intended for a personal computer.

### Settings

Open **Flipt** from the applications menu, or run `flipt --settings`:

- **Tarjima tili** (target language) — pick from the list or type one (English name: `French`, `Korean`…)
- **Model** — Haiku / Sonnet / Opus / Fable, latest or a pinned version
- **Qoidalar** (rules) — an extra prompt for the translation, for example:
  "Translate in a formal tone. Do not translate technical terms."

Everything is stored in `~/.config/flipt/config.conf`, which you can also edit by hand:

```
LANG=Russian
MODEL=sonnet

[PROMPT]
Translate in a formal tone.
Do not translate technical terms (API, deploy, commit).
```

### Commands

| Command | What it does |
|---|---|
| `flipt` | translates the selected text into the configured language (this is what the hotkey runs) |
| `flipt Russian` | one-off translation into another language |
| `flipt --settings` | settings window |
| `flipt --show` | current settings |
| `echo "text" \| flipt --stdin` | no window, the result is printed to the terminal |

### Limitations

- Automatic paste does not work inside a terminal (paste there is `Ctrl+Shift+V`). The translation stays in the clipboard.
- Each translation starts `claude` from scratch, so a reply takes 2–5 seconds.
- Does not work in an X11 session (`wl-clipboard` is Wayland-only).

---

## Русский

Небольшое приложение для Linux: переводит выделенный текст через CLI [Claude Code](https://claude.com/claude-code)
и после вашего подтверждения вставляет перевод на место оригинала.
(Flipt = flip + text: одна клавиша «переворачивает» текст на другой язык.)

1. Выделите текст в любом приложении.
2. Нажмите `Super+T`.
3. Перевод появится в окне — при необходимости отредактируйте его.
4. Нажмите **Almashtirish** (Заменить), и выделенный текст заменится переводом.

> Интерфейс приложения — на узбекском языке.

### Требования

- Ubuntu, GNOME, сессия Wayland (проверено на 22.04)
- Установленный [Claude Code CLI](https://claude.com/claude-code) с выполненным входом (команда `claude` должна работать)
- `wl-clipboard`, `ydotool`, `zenity`, `python3-gi` — установщик поставит их сам

### Установка

```bash
git clone git@github.com:firefoxuz/inplace-translator.git
cd inplace-translator
./install.sh
```

Установщик:

- копирует скрипт в `~/.local/bin/flipt`;
- добавляет ярлык **Flipt** в меню приложений;
- выдаёт доступ к `/dev/uinput`, чтобы работал `ydotool` (запросит `sudo`);
- регистрирует горячую клавишу `Super+T`. Для другой клавиши: `FLIPT_HOTKEY='<Super>y' ./install.sh`

> Доступ к `/dev/uinput` позволяет любой программе, запущенной от вашего имени, имитировать
> нажатия клавиш. Рассчитано на личный компьютер.

### Настройки

Откройте **Flipt** в меню приложений или выполните `flipt --settings`:

- **Tarjima tili** (язык перевода) — выберите из списка или введите вручную (название по-английски: `French`, `Korean`…)
- **Model** — Haiku / Sonnet / Opus / Fable, последняя или конкретная версия
- **Qoidalar** (правила) — дополнительный промпт для перевода, например:
  «Переводи в официальном стиле. Технические термины не переводи.»

Всё хранится в файле `~/.config/flipt/config.conf`, его можно править и вручную:

```
LANG=Russian
MODEL=sonnet

[PROMPT]
Переводи в официальном стиле.
Технические термины (API, deploy, commit) не переводи.
```

### Команды

| Команда | Что делает |
|---|---|
| `flipt` | переводит выделенный текст на язык из настроек (её вызывает горячая клавиша) |
| `flipt Russian` | разовый перевод на другой язык |
| `flipt --settings` | окно настроек |
| `flipt --show` | текущие настройки |
| `echo "текст" \| flipt --stdin` | без окна, результат выводится в терминал |

### Ограничения

- В терминале автоматическая вставка не работает (там вставка — `Ctrl+Shift+V`). Перевод остаётся в буфере обмена.
- Каждый перевод запускает `claude` заново, поэтому ответ занимает 2–5 секунд.
- Не работает в сессии X11 (`wl-clipboard` — только для Wayland).

---

## O'zbekcha

Belgilangan matnni [Claude Code](https://claude.com/claude-code) CLI orqali tarjima qilib,
tasdiqlaganingizdan keyin o'rniga qo'yadigan kichik Linux ilovasi.
(Flipt = flip + text: bitta tugma matnni boshqa tilga «ag'daradi».)

1. Istalgan ilovada matnni belgilaysiz.
2. `Super+T` bosasiz.
3. Tarjima oynada chiqadi — kerak bo'lsa tahrirlaysiz.
4. **Almashtirish** bossangiz, belgilangan matn tarjimaga almashadi.

### Talablar

- Ubuntu, GNOME, Wayland sessiyasi (22.04 da sinalgan)
- [Claude Code CLI](https://claude.com/claude-code) o'rnatilgan va tizimga kirilgan (`claude` buyrug'i ishlashi kerak)
- `wl-clipboard`, `ydotool`, `zenity`, `python3-gi` — o'rnatuvchi o'zi qo'yadi

### O'rnatish

```bash
git clone git@github.com:firefoxuz/inplace-translator.git
cd inplace-translator
./install.sh
```

O'rnatuvchi:

- skriptni `~/.local/bin/flipt` ga ko'chiradi;
- ilovalar menyusiga **Flipt** yorlig'ini qo'shadi;
- `ydotool` ishlashi uchun `/dev/uinput` ga ruxsat beradi (`sudo` so'raydi);
- `Super+T` hotkey'ini ro'yxatdan o'tkazadi. Boshqa tugma uchun: `FLIPT_HOTKEY='<Super>y' ./install.sh`

> `/dev/uinput` ruxsati sizning nomingizdan ishlayotgan har qanday dasturga klaviatura
> bosishini simulyatsiya qilish imkonini beradi. Shaxsiy kompyuter uchun mo'ljallangan.

### Sozlamalar

Ilovalar menyusidan **Flipt**ni oching yoki `flipt --settings`:

- **Tarjima tili** — ro'yxatdan yoki qo'lda (inglizcha nom: `French`, `Korean`…)
- **Model** — Haiku / Sonnet / Opus / Fable, eng so'nggi yoki aniq versiya
- **Qoidalar** — tarjima uchun qo'shimcha prompt, masalan:
  «Rasmiy uslubda tarjima qil. Texnik atamalarni tarjima qilma.»

Hammasi `~/.config/flipt/config.conf` faylida saqlanadi, uni qo'lda ham tahrirlash mumkin:

```
LANG=Russian
MODEL=sonnet

[PROMPT]
Rasmiy uslubda tarjima qil.
Texnik atamalarni (API, deploy, commit) tarjima qilma.
```

### Buyruqlar

| Buyruq | Vazifasi |
|---|---|
| `flipt` | belgilangan matnni config'dagi tilga tarjima qiladi (hotkey shuni chaqiradi) |
| `flipt Russian` | bir martalik boshqa tilga |
| `flipt --settings` | sozlamalar oynasi |
| `flipt --show` | joriy sozlamalar |
| `echo "matn" \| flipt --stdin` | oynasiz, natija terminalga chiqadi |

### Cheklovlar

- Terminal ichida avtomatik qo'yish ishlamaydi (u yerda paste `Ctrl+Shift+V`). Tarjima clipboard'da qoladi.
- Har bir tarjima `claude` ni yangidan ishga tushiradi, shuning uchun javob 2–5 soniya oladi.
- X11 sessiyasida ishlamaydi (`wl-clipboard` Wayland uchun).
