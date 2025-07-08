#!/bin/bash
# scripts/deploy_tx.sh
# Deploy and flash LI-FI transmitter (ESP8266 TX) code
#
# Usage:
#   bash scripts/deploy_tx.sh

set -e

INO_PATH="$(dirname "$0")/../ESP8266.CORE/esp8266/tx.ino"
PORT="/dev/ttyUSB0" # Update if needed or read from config
BAUD=115200

# Check for PlatformIO
if command -v pio &>/dev/null; then
  pio run -d $(dirname "$INO_PATH") -t upload --upload-port "$PORT"
  echo "[INFO] Transmitter firmware flashed successfully via PlatformIO."
  exit 0
fi

# Fallback: Arduino CLI
if command -v arduino-cli &>/dev/null; then
  arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 "$INO_PATH"
  arduino-cli upload -p "$PORT" --fqbn esp8266:esp8266:nodemcuv2 "$INO_PATH"
  echo "[INFO] Transmitter firmware flashed successfully via Arduino CLI."
  exit 0
fi

echo "[ERROR] Neither PlatformIO nor arduino-cli found. Please install one."
exit 1
