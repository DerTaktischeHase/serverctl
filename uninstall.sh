#!/usr/bin/env bash
set -e

BIN="$HOME/.local/bin/serverctl"
BASHRC="$HOME/.bashrc"

echo "[serverctl] Deinstallation startet …"
echo

# 1) Binary entfernen
if [ -f "$BIN" ]; then
  rm -f "$BIN"
  echo "[serverctl] Entfernt: $BIN"
else
  echo "[serverctl] Hinweis: serverctl war nicht installiert ($BIN nicht gefunden)"
fi

# 2) SSH-Hinweis aus ~/.bashrc entfernen (falls vorhanden)
if [ -f "$BASHRC" ] && grep -q "SERVERCTL_HINT_SHOWN" "$BASHRC"; then
  echo "[serverctl] Entferne SSH-Hinweis aus ~/.bashrc"
  sed -i '/serverctl Hinweis bei SSH-Login/,+6d' "$BASHRC"
else
  echo "[serverctl] Kein SSH-Hinweis in ~/.bashrc gefunden"
fi

echo
echo "[serverctl] Deinstallation abgeschlossen ✅"
echo
echo "➡️  Startet neue Shell, damit die Änderungen wirksam werden"
echo

exec bash
