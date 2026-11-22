#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8
# Run from labs/lab05-encoding/:  sh scripts/fix.sh
set -e
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
tmp=evidence/.staff-fixed.tmp

# 1. encoding: RK1048 (Kazakh variant of Windows-1251) -> UTF-8
iconv -f RK1048 -t UTF-8 "$in" > "$tmp"

# 2. line endings: source is CRLF (0D 0A); kept as CRLF on purpose (see README)

# 3. BOM: added on purpose so Excel on Windows opens the UTF-8 file by double-click
printf '\357\273\277' | cat - "$tmp" > "$out"
rm -f "$tmp"
