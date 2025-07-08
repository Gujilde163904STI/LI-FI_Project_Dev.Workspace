#!/bin/bash
# scripts/check_serial_perms.sh
# CHECK_SERIAL_PERMS: Add user to dialout group for serial port access (Linux/Raspberry Pi)
#
# Usage:
#   bash scripts/check_serial_perms.sh

USER=$(whoami)
if groups $USER | grep &>/dev/null '\bdialout\b'; then
  echo "[INFO] User $USER already in 'dialout' group."
else
  echo "[INFO] Adding $USER to 'dialout' group (requires sudo)."
  sudo usermod -a -G dialout $USER
  echo "[INFO] Please log out and log back in for group changes to take effect."
fi
