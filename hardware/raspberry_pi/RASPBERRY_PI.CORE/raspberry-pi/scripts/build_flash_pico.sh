#!/bin/bash
# build_flash_pico.sh: Build and flash a Raspberry Pi Pico example
# Usage: ./build_flash_pico.sh [example_name]

set -e
cd "$(dirname "$0")/../pico/pico-examples"

EXAMPLE=${1:-blink}
mkdir -p build && cd build
cmake .. -DPICO_BOARD=pico
make -j$(nproc) $EXAMPLE

# Flash using picotool (Pico must be in BOOTSEL mode and mounted)
PICO_EXE="../$EXAMPLE/$EXAMPLE.uf2"
if [ -f "$PICO_EXE" ]; then
  echo "Flashing $PICO_EXE to Pico..."
  picotool load "$PICO_EXE" -f
else
  echo "Build complete. UF2 file: $PICO_EXE"
  echo "Manually copy to Pico USB drive or use picotool."
fi
