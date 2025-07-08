#!/bin/bash
# flash_all.sh
# Flash all supported devices (ESP8266, RPi3, RPi4) in one go (macOS/Linux)
#
# Usage: ./flash_all.sh [--check-services]
#
# NOTE: Update device paths and flashing commands as needed for your setup.

set -e

REQUIRED_SERVICES=("coder.service" "wayvnc.service" "skaffold.service")

check_services() {
  local missing=()
  for svc in "${REQUIRED_SERVICES[@]}"; do
    if ! systemctl --user is-active --quiet "$svc"; then
      missing+=("$svc")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "[WARN] The following required services are not active: ${missing[*]}"
    read -p "Start them now? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      for svc in "${missing[@]}"; do
        systemctl --user start "$svc"
        echo "Started $svc."
      done
    else
      echo "Aborting. Please start required services with: systemctl --user start ${missing[*]}"
      exit 1
    fi
  fi
}

if [[ "$1" == "--check-services" ]]; then
  check_services
fi

check_services

# Flash ESP8266
if [ -d "../ESP8266/" ]; then
  echo "Flashing ESP8266..."
  # TODO: Replace with actual flashing command (e.g., using esptool or PlatformIO)
  # Example: platformio run --target upload -d ../ESP8266/
fi

# Flash RPi3
if [ -d "../RPI3/" ]; then
  echo "Flashing RPi3..."
  # TODO: Replace with actual flashing command (e.g., using custom script or dd)
fi

# Flash RPi4
if [ -d "../RPI4/" ]; then
  echo "Flashing RPi4..."
  # TODO: Replace with actual flashing command (e.g., using custom script or dd)
fi

echo "All devices flashed (if connected)." 