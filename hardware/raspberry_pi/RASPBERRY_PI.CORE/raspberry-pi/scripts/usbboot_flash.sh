#!/bin/bash
# usbboot_flash.sh: Use usbboot to flash firmware to Raspberry Pi Pico or CM
# Usage: ./usbboot_flash.sh <file.uf2>

set -e
cd "$(dirname "$0")/../usbboot/usbboot"

if [ -z "$1" ]; then
  echo "Usage: $0 <file.uf2>"
  exit 1
fi

./usbboot -w "$1"

echo "USB boot flashing complete."
