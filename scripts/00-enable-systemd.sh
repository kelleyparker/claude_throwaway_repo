#!/usr/bin/env bash
# Enables systemd inside Ubuntu WSL2 (required for `systemctl` / Jenkins service).
# After running, execute `wsl --shutdown` from Windows PowerShell, then reopen Ubuntu.
set -euo pipefail

if [ "$(ps -p 1 -o comm=)" = "systemd" ]; then
  echo "systemd is already running. Nothing to do."; exit 0
fi

if grep -q '^\[boot\]' /etc/wsl.conf 2>/dev/null; then
  echo "/etc/wsl.conf already has a [boot] section; add 'systemd=true' manually."; exit 1
fi

sudo tee -a /etc/wsl.conf >/dev/null <<'CONF'
[boot]
systemd=true
CONF

echo "Done. Now run in PowerShell:  wsl --shutdown   then reopen Ubuntu."
