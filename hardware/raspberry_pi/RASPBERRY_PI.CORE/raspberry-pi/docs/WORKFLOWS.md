# Raspberry Pi Example Workflows & Automation

This document provides step-by-step guides and automation for using the resources in this directory.

---

## 1. Build and Flash Raspberry Pi Kernel

1. Open a terminal and navigate to the project root.
2. Run:
   ```sh
   bash raspberry-pi/scripts/build_kernel.sh
   ```
3. The kernel will be built in `firmware/linux-kernel/arch/arm/boot/`.
4. Copy the kernel image to your SD card or use as needed.

---

## 2. Update EEPROM

1. Open a terminal and navigate to the project root.
2. Run:
   ```sh
   sudo bash raspberry-pi/scripts/update_eeprom.sh
   ```
3. Reboot your Raspberry Pi to apply changes.

---

## 3. Build and Flash Pico Example

1. Open a terminal and navigate to the project root.
2. Run:
   ```sh
   bash raspberry-pi/scripts/build*flash*pico.sh blink
   ```
   (Replace `blink` with any example in `pico/pico-examples/`)
3. If a Pico is connected in BOOTSEL mode, it will be flashed automatically.

---

## 4. Use PicoTool to Flash

1. Open a terminal and navigate to the project root.
2. Run:
   ```sh
   bash raspberry-pi/scripts/picotool_flash.sh <file.uf2|file.elf>
   ```

---

## 5. Use Raspberry Pi Imager

1. Open the `imager/rpi-imager-qml/` directory.
2. Follow the README or run the app to flash SD cards.

---

## 6. Use USB Boot Utilities

1. Open a terminal and navigate to the project root.
2. Run:
   ```sh
   bash raspberry-pi/scripts/usbboot_flash.sh <file.uf2>
   ```

---

For more details, see the README files in each resource subfolder.
