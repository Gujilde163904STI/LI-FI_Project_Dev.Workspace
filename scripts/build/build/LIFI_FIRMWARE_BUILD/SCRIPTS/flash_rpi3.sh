#!/bin/bash
echo "🔧 Flashing RPI3 firmware..."
cd "$(dirname "$0")/../RPI3"
python3 lifi_rpi3_main.py
