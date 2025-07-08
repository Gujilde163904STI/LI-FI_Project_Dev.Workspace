#!/bin/bash
# update_eeprom.sh: Update Raspberry Pi EEPROM firmware
# Usage: sudo ./update_eeprom.sh

set -e
cd "$(dirname "$0")/../firmware/rpi-eeprom"

sudo ./rpi-eeprom-update
sudo ./rpi-eeprom-update -d -f firmware-2711/latest/pieeprom.bin

echo "EEPROM update complete. Reboot your Raspberry Pi to apply changes."
