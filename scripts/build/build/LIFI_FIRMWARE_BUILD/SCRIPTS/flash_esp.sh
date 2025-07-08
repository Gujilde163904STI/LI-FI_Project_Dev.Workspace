#!/bin/bash
echo "🔧 Flashing ESP8266 firmware..."
cd "$(dirname "$0")/../ESP8266"
pio run --target upload
