#!/bin/bash
set -e

case "$1" in
  build)
    if [ "$TARGET_BOARD" = "esp8266" ]; then
      platformio run
    elif [ "$TARGET_BOARD" = "rpi3" ]; then
      python RPI3/src/main.py
    elif [ "$TARGET_BOARD" = "rpi4" ]; then
      python RPI4/src/main.py
    else
      echo "Unknown or generic board, running default build."
      platformio run || true
    fi
    ;;
  flash)
    if [ "$TARGET_BOARD" = "esp8266" ]; then
      platformio run --target upload
    else
      echo "Flashing only supported for ESP8266 in this script."
    fi
    ;;
  monitor)
    if [ "$TARGET_BOARD" = "esp8266" ]; then
      platformio device monitor
    else
      minicom -D /dev/ttyUSB0
    fi
    ;;
  healthcheck)
    # Simple healthcheck: check if serial device is present
    if [ -e /dev/ttyUSB0 ] || [ -e /dev/tty.SLAB_USBtoUART ]; then
      exit 0
    else
      exit 1
    fi
    ;;
  *)
    exec "$@"
    ;;
esac 