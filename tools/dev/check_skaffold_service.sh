#!/usr/bin/env bash
set -e

SERVICE="skaffold.service"

if ! systemctl --user is-active --quiet "$SERVICE"; then
  echo "[WARN] $SERVICE is not running. Live sync/deploy may fail."
  read -p "Start $SERVICE now? [Y/n]: " yn
  yn=${yn:-Y}
  if [[ "$yn" =~ ^[Yy]$ ]]; then
    systemctl --user start "$SERVICE"
    echo "Started $SERVICE."
  else
    echo "Aborting. Please start $SERVICE with: systemctl --user start $SERVICE"
    exit 1
  fi
else
  echo "$SERVICE is active."
fi 