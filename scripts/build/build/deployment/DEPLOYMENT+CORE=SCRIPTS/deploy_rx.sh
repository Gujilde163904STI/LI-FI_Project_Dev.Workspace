#!/bin/bash
# scripts/deploy_rx.sh
# Deploy and flash LI-FI receiver (ESP8266 RX) code
#
# Usage:
#   bash scripts/deploy_rx.sh

set -e

# Use the existing PlatformIO project for ESP8266 RX
PIO_PROJECT_DIR="$(dirname "$0")/../platformio/lifi_esp8266"
INO_PATH="$PIO_PROJECT_DIR/src/lifi_esp8266_main.ino"
PORT="/dev/ttyUSB1" # Update if needed or read from config
BAUD=115200

# Check for PlatformIO
if command -v pio &>/dev/null; then
  pio run -d "$PIO_PROJECT_DIR" -t upload --upload-port "$PORT"
  echo "[INFO] Receiver firmware flashed successfully via PlatformIO."
  exit 0
fi

# Fallback: Arduino CLI
if command -v arduino-cli &>/dev/null; then
  arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 "$INO_PATH"
  arduino-cli upload -p "$PORT" --fqbn esp8266:esp8266:nodemcuv2 "$INO_PATH"
  echo "[INFO] Receiver firmware flashed successfully via Arduino CLI."
  exit 0
fi

echo "[ERROR] Neither PlatformIO nor arduino-cli found. Please install one."
exit 1
