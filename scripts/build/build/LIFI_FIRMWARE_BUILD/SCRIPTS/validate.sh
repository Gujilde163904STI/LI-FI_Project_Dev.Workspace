#!/bin/bash
echo "🔍 Validating firmware builds..."
cd "$(dirname "$0")/.."
echo "Checking RPI3..."
test -f RPI3/lifi_rpi3_main.py && echo "✅ RPI3 firmware found" || echo "❌ RPI3 firmware missing"
echo "Checking RPI4..."
test -f RPI4/lifi_rpi4_main.py && echo "✅ RPI4 firmware found" || echo "❌ RPI4 firmware missing"
echo "Checking ESP8266..."
test -f ESP8266/platformio.ini && echo "✅ ESP8266 project found" || echo "❌ ESP8266 project missing"
