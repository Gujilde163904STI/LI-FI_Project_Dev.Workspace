# Raspberry Pi Development Resources

This directory contains categorized resources and automation for Raspberry Pi and Pico development.

## Directory Structure

- `firmware/`
  - `linux-kernel/` — Raspberry Pi Linux kernel source
  - `rpi-eeprom/` — EEPROM tools and firmware
- `pico/`
  - `pico-sdk/` — C/C++ SDK for Raspberry Pi Pico
  - `pico-examples/` — Example projects for Pico
  - `pico-firmware/` — Firmware modules for Pico
  - `picotool/` — Utility for working with Pico
- `imager/`
  - `rpi-imager-qml/` — Qt-based Raspberry Pi Imager
- `usbboot/`
  - `usbboot/` — USB boot utilities
- `docs/` — Documentation and guides

## Quick Start

See the guides below for common workflows and automation scripts for each resource.

---

# Example Workflows & Automation

## 1. Build and Flash Raspberry Pi Kernel
- See `firmware/linux-kernel/README.md` (or official docs)
- Example automation: `scripts/build_kernel.sh`

## 2. Update EEPROM
- See `firmware/rpi-eeprom/README.md`
- Example automation: `scripts/update_eeprom.sh`

## 3. Build and Flash Pico Examples
- See `pico/pico-examples/README.md`
- Example automation: `scripts/build*flash*pico.sh`

## 4. Use PicoTool
- See `pico/picotool/README.md`
- Example automation: `scripts/picotool_flash.sh`

## 5. Use Raspberry Pi Imager
- See `imager/rpi-imager-qml/README.md`
- Launch the imager app for SD card flashing

## 6. Use USB Boot Utilities
- See `usbboot/usbboot/Readme.md`
- Example automation: `scripts/usbboot_flash.sh`

---

# See the scripts/ directory for ready-to-use automation scripts for each workflow.
