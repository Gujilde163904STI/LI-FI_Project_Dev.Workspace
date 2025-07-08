# ESP8266 Board - LI-FI Transmitter

## 1. Overview

- **Purpose:** Transmits data via LED/IR (light) to Raspberry Pi photodiode receiver.
- **Features:**
  - Standalone PlatformIO C++ firmware
  - TCP handshake and data transfer over light
  - Wi-Fi AP fallback and UDP discovery
  - Auto-handshake and retry logic
  - Status via onboard LED and serial

## 2. Wiring Diagram

| Signal         | ESP8266 Pin | NodeMCU Label |
|---------------|-------------|---------------|
| LED/IR TX     | GPIO2       | D4            |
| GND           | GND         | GND           |
| 3.3V          | 3.3V        | 3V3           |

```
   +-------------------+
   |     ESP8266       |
   |                   |
   |   [GPIO2/D4]------|---[LED/IR]---+--- GND
   |                   |
   +-------------------+
```

## 3. Flashing Instructions

- Use PlatformIO or unified build tool:

  ```sh
  python build/build.py --target esp8266 --flash
  # or
  platformio run --target upload
  ```

- Connect via USB, select correct port.

## 4. Boot Behavior

- On power-up, emits "HELLO" handshake via LED/IR (TCP SYN packet).
- Retries handshake 3x, blinks onboard LED if failed.
- If handshake fails, enables Wi-Fi AP mode (SSID: LIFI-ESP8266, Pass: lifi1234).

## 5. Photodiode/LED Setup

- Connect LED/IR anode to GPIO2 (D4), cathode to GND.
- Align LED/IR to face RPi photodiode.

## 6. Network Info

- Default: No Wi-Fi needed for light transfer.
- Fallback: Wi-Fi AP (SSID: LIFI-ESP8266, Pass: lifi1234).

## 7. Debugging

- **LED Codes:**
  - Fast blink: handshake fail
  - Slow blink: waiting for partner
  - Solid: link established
- **Serial Output:**
  - Use `screen /dev/ttyUSB0 115200` or PlatformIO serial monitor.

## 8. Test Commands

- Test TCP connection:

  ```sh
  nc <esp_ip> 9000
  ```

- Test UDP broadcast:

  ```sh
  nc -u -b 255.255.255.255 9001
  ```

---

> For protocol details, see `../docs/protocols.md`.
