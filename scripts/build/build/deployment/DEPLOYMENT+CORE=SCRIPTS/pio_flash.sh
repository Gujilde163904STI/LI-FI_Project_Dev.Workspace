#!/bin/bash
# Flash firmware to ESP8266/Arduino using PlatformIO

PROJECT_DIR="$(dirname "$0")/../ESP8266.CORE"

cd "$PROJECT_DIR" || exit 1
pio run
pio run --target upload
