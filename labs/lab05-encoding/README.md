# Lab 5 — Encoding forensics

Name: Anuar Maratov · Date: 22.11.2026 · Tools: macOS Terminal (`file`, `iconv`), MacBook Air M5

## What I received
`staff-broken.csv` (852 bytes, 16 lines: a header and 15 staff rows, separator `;`).

- **Terminal (`cat`):** Russian text is shown as wrong symbols, because the terminal expects UTF-8 and the file is a one-byte-per-letter code page.
- **Excel / LibreOffice:** TODO — I did not open the file in them yet (see "What did not work").

## Diagnosis (made before the fix)
- `file` said: `Non-ISO extended-ASCII text, with CRLF line terminators` (evidence/file-before.txt). It does not name the code page.
- First 16 bytes: `49 44 3b d4 e0 ec e8 eb e8 ff 3b c8 ec ff 3b ce` (evidence/hexdump-before.txt)
- **Encoding: RK1048 (KZ-1048, the Kazakh variant of Windows-1251)** — because every Cyrillic letter is one byte (`Ф` = `D4`, `а` = `E0`, `я` = `FF`), and the Kazakh letters are single bytes too: `Ә` = `A3` (offset 0x2A, in `Әбдірахманова`) and `Қ` = `8D` (offset 0xA4, in `Қасымов`). Windows-1251 reads `A3` as `Ј` and `8D` is not a Kazakh letter there, so only RK1048 decodes every name correctly.
- **Line ending: CRLF** — because line 1 ends with `0D 0A` (`ee e4 0d 0a`); 16 CRLF, 0 bare LF.
- **BOM: no** — because the file starts with `49 44` ("ID"), not `EF BB BF` or `FF FE`.
- **Separator:** `;`
- In the fixed file I **added** a BOM, because Excel on Windows only recognises UTF-8 by double-click when the file starts with `EF BB BF`. The price is that a script can see the BOM as part of the first column name (`﻿ID`); for scripts the BOM can be stripped.
- I **kept CRLF**, because the source already is CRLF and Windows/Excel users expect it. A Linux script would need `sed -i 's/\r$//'`.

## Fix
`scripts/fix.sh` (run from `labs/lab05-encoding/`):

```sh
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv > evidence/.staff-fixed.tmp
printf '\357\273\277' | cat - evidence/.staff-fixed.tmp > evidence/staff-fixed.csv
```

## Verification
`evidence/file-after.txt`: `Unicode text, UTF-8 (with BOM) text, with CRLF line terminators`. Cyrillic letters are `D0 xx` / `D1 xx` pairs; the Kazakh names (Әбдірахманова, Қасымов, Нұрлан, Өмірзақова…) read correctly in `cat`. The original `evidence/staff-broken.csv` is unchanged (SHA-256 `fecc66e3…e41f`).

TODO: `evidence/opens-correctly.png` — the fixed file opened in Excel, LibreOffice Calc and the terminal, side by side.

## What did not work the first time
- `file` only said "Non-ISO extended-ASCII text": it cannot tell Windows-1251 from KZ-1048. My first guess, Windows-1251, gave wrong Kazakh letters (`Јбдірахманова`, `Ќасымов`, `Нўрлан`), so I looked at the bytes (`A3`, `8D`) and switched to RK1048.
- Excel and LibreOffice are not installed on this Mac, so the three-application check is not done yet.

## AI use
I used Claude (Anthropic) to run the diagnosis commands, write `scripts/fix.sh` and draft this README. TODO (Anuar): check the bytes and the BOM / line-ending decision yourself and be ready to explain them in 60 seconds.
