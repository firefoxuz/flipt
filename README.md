# Tarjima

Belgilangan matnni [Claude Code](https://claude.com/claude-code) CLI orqali tarjima qilib,
tasdiqlaganingizdan keyin o'rniga qo'yadigan kichik Linux ilovasi.

1. Istalgan ilovada matnni belgilaysiz.
2. `Super+T` bosasiz.
3. Tarjima oynada chiqadi — kerak bo'lsa tahrirlaysiz.
4. **Almashtirish** bossangiz, belgilangan matn tarjimaga almashadi.

## Talablar

- Ubuntu, GNOME, Wayland sessiyasi (22.04 da sinalgan)
- [Claude Code CLI](https://claude.com/claude-code) o'rnatilgan va tizimga kirilgan (`claude` buyrug'i ishlashi kerak)
- `wl-clipboard`, `ydotool`, `zenity`, `python3-gi` — o'rnatuvchi o'zi qo'yadi

## O'rnatish

```bash
git clone git@github.com:firefoxuz/tarjima.git
cd tarjima
./install.sh
```

O'rnatuvchi:

- skriptni `~/.local/bin/tarjima` ga ko'chiradi;
- ilovalar menyusiga **Tarjima** yorlig'ini qo'shadi;
- `ydotool` ishlashi uchun `/dev/uinput` ga ruxsat beradi (`sudo` so'raydi);
- `Super+T` hotkey'ini ro'yxatdan o'tkazadi. Boshqa tugma uchun: `TARJIMA_HOTKEY='<Super>y' ./install.sh`

> `/dev/uinput` ruxsati sizning nomingizdan ishlayotgan har qanday dasturga klaviatura
> bosishini simulyatsiya qilish imkonini beradi. Shaxsiy kompyuter uchun mo'ljallangan.

## Sozlamalar

Ilovalar menyusidan **Tarjima**ni oching yoki `tarjima --settings`:

- **Tarjima tili** — ro'yxatdan yoki qo'lda (inglizcha nom: `French`, `Korean`…)
- **Model** — Haiku / Sonnet / Opus / Fable, eng so'nggi yoki aniq versiya
- **Qoidalar** — tarjima uchun qo'shimcha prompt, masalan:
  «Rasmiy uslubda tarjima qil. Texnik atamalarni tarjima qilma.»

Hammasi `~/.config/tarjima/config.conf` faylida saqlanadi, uni qo'lda ham tahrirlash mumkin:

```
LANG=Russian
MODEL=sonnet

[PROMPT]
Rasmiy uslubda tarjima qil.
Texnik atamalarni (API, deploy, commit) tarjima qilma.
```

## Buyruqlar

| Buyruq | Vazifasi |
|---|---|
| `tarjima` | belgilangan matnni config'dagi tilga tarjima qiladi (hotkey shuni chaqiradi) |
| `tarjima Russian` | bir martalik boshqa tilga |
| `tarjima --settings` | sozlamalar oynasi |
| `tarjima --show` | joriy sozlamalar |
| `echo "matn" \| tarjima --stdin` | oynasiz, natija terminalga chiqadi |

## Cheklovlar

- Terminal ichida avtomatik qo'yish ishlamaydi (u yerda paste `Ctrl+Shift+V`). Tarjima clipboard'da qoladi.
- Har bir tarjima `claude` ni yangidan ishga tushiradi, shuning uchun javob 2–5 soniya oladi.
- X11 sessiyasida ishlamaydi (`wl-clipboard` Wayland uchun).
