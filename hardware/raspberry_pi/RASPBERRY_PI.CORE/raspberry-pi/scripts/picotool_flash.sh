#!/bin/bash
# picotool_flash.sh: Use picotool to flash a UF2 or ELF to Raspberry Pi Pico
# Usage: ./picotool_flash.sh <file.uf2|file.elf>

set -e
cd "$(dirname "$0")/../pico/picotool"

if [ -z "$1" ]; then
  echo "Usage: $0 <file.uf2|file.elf>"
  exit 1
fi

./picotool load "$1" -f

echo "Flashing complete."
