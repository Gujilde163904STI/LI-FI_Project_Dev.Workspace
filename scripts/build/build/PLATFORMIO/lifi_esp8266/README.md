# LI-FI ESP8266 NodeMCU V3 (CH340G) Firmware

This firmware is for the ESP8266 NodeMCU V3 (CH340G) board, designed to work as a LI-FI transmitter/receiver with Raspberry Pi 3 and 4 controllers.

## Features
- Serial communication with Raspberry Pi (115200 baud, USB CH340G)
- Controls LED for LI-FI transmission (D1/GPIO5)
- Reads photodiode signal for LI-FI reception (A0/ADC)
- Simple command protocol: "on", "off", "read"

## Pin Mapping
- **LED (TX):** D1 (GPIO5)
- **Photodiode (RX):** A0 (ADC)

## How to Build & Flash (PlatformIO)

1. Connect your ESP8266 NodeMCU V3 (CH340G) to your computer via USB.
2. Navigate to the firmware directory:
   ```bash
   cd platformio/lifi_esp8266
   ```
3. Build the firmware:
   ```bash
   pio run
   ```
4. Upload (flash) the firmware:
   ```bash
   pio run --target upload
   ```
5. Open the serial monitor (optional):
   ```bash
   pio device monitor
   ```

## Compatibility
- Works with Raspberry Pi 3 and 4 LI-FI controller scripts
- Compatible with CH340G USB-to-Serial driver (see [driver link](http://en.doit.am/CH341SER.zip))

## Hardware Reference
- See `hardware/` for photodiode and detector circuit details.

---

# LI-FI Project - ESP8266 NodeMCU V3 Firmware
- Transmits and receives LI-FI data via serial commands and photodiode/LED
