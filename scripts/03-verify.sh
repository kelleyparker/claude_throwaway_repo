#!/usr/bin/env bash
# Quick health check of the WSL Jenkins install.
set -u
ok(){ echo "[ OK ] $*"; }; bad(){ echo "[FAIL] $*"; }

[ "$(ps -p 1 -o comm=)" = "systemd" ] && ok "systemd running" || bad "systemd not running"
java -version 2>&1 | head -1 | grep -Eq '"(21|25)\.' && ok "Java 21+" || bad "Java 21+ required"
systemctl is-active --quiet jenkins && ok "jenkins service active" || bad "jenkins service not active"
curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/login | grep -q 200 \
  && ok "Web UI answers on :8080" || bad "Web UI not reachable"
if sudo -n true 2>/dev/null; then
  sudo -n -u jenkins docker ps >/dev/null 2>&1 && ok "jenkins user can use Docker" \
    || bad "jenkins cannot use Docker (restart service after group change)"
else
  echo "[SKIP] Docker check needs sudo; run: sudo -u jenkins docker ps"
fi
git --version >/dev/null 2>&1 && ok "git installed" || bad "git missing"
