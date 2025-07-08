#!/bin/bash
echo "🔧 Flashing RPI4 firmware..."
cd "$(dirname "$0")/../RPI4"
python3 lifi_rpi4_main.py
