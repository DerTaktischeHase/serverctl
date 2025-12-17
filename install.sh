#!/usr/bin/env bash
set -e

# ================================
# serverctl Installer
# ================================

REPO_RAW_URL="https://raw.githubusercontent.com/DerTaktischeHase/serverctl/main"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

echo "[serverctl] Installation startet …"
echo

# ----------------
# 1) Abhängigkeiten
# ----------------
if command -v apt >/dev/null 2>&1; then
  echo "[serverctl] Installiere empfohlene Abhängigkeiten (apt)…"
  sudo apt update
  sudo apt install -y \
    curl \
    htop \
    ncdu \
    iproute2 \
    util-linux \
    procps \
    lsof \
    lm-sensors
else
  echo "[serverctl] WARN: apt nicht gefunden – Abhängigkeiten übersprungen"
fi

# ----------------
# 2) serverctl installieren
# ----------------
echo
echo "[serverctl] Installiere serverctl …"
mkdir -p "$BIN_DIR"

curl -fsSL "$REPO_RAW_URL/serverctl" -o "$BIN_DIR/serverctl"
chmod +x "$BIN_DIR/serverctl"

# ----------------
# 3) PATH sicherstellen
# ----------------
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC" 2>/dev/null; then
    echo "[serverctl] Ergänze PATH in ~/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
  fi
fi

# ----------------
# 4) SSH-Hinweis einrichten
# ----------------
if ! grep -q "SERVERCTL_HINT_SHOWN" "$BASHRC" 2>/dev/null; then
  cat >> "$BASHRC" << 'EOF'

# serverctl Hinweis bei SSH-Login
if [[ -n "$SSH_CONNECTION" && -z "$SERVERCTL_HINT_SHOWN" ]]; then
  export SERVERCTL_HINT_SHOWN=1
  echo "Tipp: Nutze 'serverctl' für Server-Status & Wartung"
fi
EOF
fi

# ----------------
# 5) Abschluss
# ----------------
echo
echo "[serverctl] Installation abgeschlossen ✅"
echo
echo "➡️  Starte neue Shell, damit serverctl sofort verfügbar ist …"
echo "➡️  Danach ausführen:"
echo "    serverctl"
echo
exec bash
