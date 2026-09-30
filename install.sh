#!/usr/bin/env bash
# 3xFactor
#   bash <(curl -fsSL https://raw.githubusercontent.com/neoauroraproject/3xfactor/main/install.sh)
#   bash <(curl -fsSL https://raw.githubusercontent.com/neoauroraproject/3xfactor/main/install.sh) install | update | license | password | uninstall | status
#   LICENSE_KEY=HM-XXXX-XXXX-XXXX bash <(curl -fsSL https://raw.githubusercontent.com/neoauroraproject/3xfactor/main/install.sh) install --yes
set -euo pipefail

RELEASES="https://github.com/neoauroraproject/3xfactor/releases/latest/download"
INSTALLED="/usr/local/3xfactor/3xfactor"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this installer as root." >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64|amd64)   ARCH="amd64" ;;
  aarch64|arm64)  ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required." >&2
  exit 1
fi

TTY=/dev/tty
[ -r "$TTY" ] || TTY=/dev/stdin

read_key() {
  local key="${LICENSE_KEY:-}"
  while true; do
    key="$(printf '%s' "$key" | tr '[:lower:]' '[:upper:]' | tr -d '[:space:]')"
    if [[ "$key" =~ ^HM-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$ ]]; then
      KEY="$key"
      return 0
    fi
    if [ -n "$key" ]; then
      echo "License key format is HM-XXXX-XXXX-XXXX." >&2
    fi
    if [ "${NONINTERACTIVE:-0}" = "1" ]; then
      echo "Set LICENSE_KEY=HM-XXXX-XXXX-XXXX for a non-interactive install." >&2
      exit 1
    fi
    read -r -s -p "License key (input hidden): " key <"$TTY"
    echo >&2
    if [ -z "$key" ]; then
      echo "A license key is required." >&2
      exit 1
    fi
  done
}

download_release() {
  local dest
  dest="$(mktemp /tmp/3xfactor.XXXXXX)"
  echo "Downloading 3xFactor for linux-$ARCH ..." >&2
  if ! curl -fsSL --retry 3 --connect-timeout 20 -o "$dest" "$RELEASES/3xfactor-linux-$ARCH"; then
    rm -f "$dest"
    echo "Download failed." >&2
    exit 1
  fi
  if [ "$(head -c 4 "$dest" | od -An -tx1 | tr -d ' \n')" != "7f454c46" ]; then
    rm -f "$dest"
    echo "Downloaded file is not a Linux binary." >&2
    exit 1
  fi
  chmod +x "$dest"
  printf '%s\n' "$dest"
}

require_installed() {
  if [ ! -x "$INSTALLED" ]; then
    echo "3xFactor is not installed. Choose Install first." >&2
    exit 1
  fi
}

if [ "$#" -eq 0 ]; then
  if [ ! -r /dev/tty ]; then
    echo "Run: install | update | license | password | uninstall | status" >&2
    exit 1
  fi
  cat >&2 <<'EOF'

  3xFactor

  1) Install
  2) Update
  3) Change license
  4) Change password
  5) Uninstall
  6) Status
  0) Exit

EOF
  while true; do
    read -r -p "Select: " choice </dev/tty
    case "$choice" in
      1|install) CMD="install"; break ;;
      2|update) CMD="update"; break ;;
      3|license) CMD="license"; break ;;
      4|password) CMD="password"; break ;;
      5|uninstall|remove) CMD="uninstall"; break ;;
      6|status) CMD="status"; break ;;
      0|q|exit) exit 0 ;;
      *) echo "Enter a number from the menu." >&2 ;;
    esac
  done
  set --
else
  CMD="$1"
  shift
fi

for a in "$@"; do
  [ "$a" = "--yes" ] && NONINTERACTIVE=1
done

case "$CMD" in
  install)
    read_key
    BIN="$(download_release)"
    trap 'rm -f "$BIN"' EXIT
    LICENSE_KEY="$KEY" "$BIN" install "$@" <"$TTY"
    ;;
  update)
    require_installed
    exec "$INSTALLED" update "$@"
    ;;
  license)
    require_installed
    exec "$INSTALLED" license set "$@" <"$TTY"
    ;;
  password|uninstall)
    require_installed
    exec "$INSTALLED" "$CMD" "$@" <"$TTY"
    ;;
  status)
    require_installed
    exec "$INSTALLED" status
    ;;
  *)
    echo "Unknown command: $CMD (install | update | license | password | uninstall | status)" >&2
    exit 1
    ;;
esac
