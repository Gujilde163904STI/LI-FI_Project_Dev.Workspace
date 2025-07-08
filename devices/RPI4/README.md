# RPI4 Board - LI-FI Receiver

## 1. Overview

- **Purpose:** Receives data via photodiode (light) from ESP8266 transmitter.
- **Features:**
  - Standalone Python firmware
  - TCP/UDP handshake and data transfer
  - Auto-handshake and retry logic
  - Logs status to terminal

## 2. Wiring Diagram

| Signal         | RPi4 Pin (BCM) | Physical Pin |
|---------------|----------------|-------------|
| Photodiode RX | GPIO17         | 11          |
| GND           | GND            | 6           |
| 3.3V          | 3.3V           | 1           |

```
   +-------------------+
   |   Raspberry Pi 4  |
   |                   |
   |   [GPIO17] <------|---[Photodiode]---+--- GND
   |                   |
   +-------------------+
```

## 3. Flashing Instructions

- Use the unified build tool:

  ```sh
  python build/build.py --target rpi4 --flash
  ```

- Or manually copy firmware to SD card and insert into RPi4.

## 4. Boot Behavior

- On power-up, waits for photodiode handshake from ESP8266.
- Logs status and errors to terminal.
- Retries handshake 3x, blinks onboard LED if failed.

## 5. Photodiode Setup

- Connect photodiode anode to GPIO17, cathode to GND.
- Place photodiode to face ESP8266 LED/IR transmitter.

## 6. Network Info

- No Wi-Fi required for default operation.
- If fallback needed, connect to ESP8266 AP (SSID: LIFI-ESP8266, Pass: lifi1234).

## 7. Debugging

- **LED Codes:**
  - Fast blink: handshake fail
  - Slow blink: waiting for partner
  - Solid: link established
- **Serial Output:**
  - Use `screen /dev/ttyUSB0 115200` or similar to monitor logs.

## 8. Test Commands

- Test TCP connection:

  ```sh
  nc <rpi_ip> 9000
  ```

- Test UDP broadcast:

  ```sh
  nc -u -b 255.255.255.255 9001
  ```

---

> For protocol details, see `../docs/protocols.md`.
