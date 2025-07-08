#!/usr/bin/env bash
set -e

SERVICES=(coder.service wayvnc.service skaffold.service)
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
SYSTEMD_SYSTEM_DIR="/etc/systemd/system"

install_service() {
  local service_file=$1
  local mode=$2
  echo "[SYSTEMD INSTALLER] Installing $service_file ($mode mode)"
  if [ "$mode" = "user" ]; then
    mkdir -p "$SYSTEMD_USER_DIR"
    cp "$service_file" "$SYSTEMD_USER_DIR/"
    systemctl --user daemon-reload
    systemctl --user enable --now $(basename "$service_file")
  else
    sudo cp "$service_file" "$SYSTEMD_SYSTEM_DIR/"
    sudo systemctl daemon-reload
    sudo systemctl enable --now $(basename "$service_file")
  fi
}

MODE="user"
if [ "$1" = "--system" ]; then
  MODE="system"
fi

for svc in "${SERVICES[@]}"; do
  if [ -f "$(dirname "$0")/$svc" ]; then
    install_service "$(dirname "$0")/$svc" "$MODE"
  else
    echo "[SYSTEMD INSTALLER] Skipping missing $svc"
  fi

done

echo "[SYSTEMD INSTALLER] All available services installed and enabled ($MODE mode)." 