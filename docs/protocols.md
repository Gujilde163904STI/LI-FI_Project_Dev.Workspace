# LI-FI Communication Protocols

## Overview

This document describes the communication protocols used for light-based data transfer between Raspberry Pi (RPi3/RPi4) and ESP8266 boards in the LI-FI system.

---

## 1. Device Roles

- **RPI3/RPI4:** Server (TCP/UDP listener, photodiode RX, handshake responder)
- **ESP8266:** Client/Bridge (TCP/UDP initiator, LED/IR TX, handshake initiator)

---

## 2. Protocol Stack

- **Primary:** TCP over light
- **Fallback:** UDP broadcast for discovery
- **Wi-Fi:** ESP8266 supports AP/Station fallback

---

## 3. Handshake Pattern

### TCP Handshake

1. **ESP8266** (TX) boots, attempts to connect to RPi (server) via TCP over light.
2. Sends `HELLO` message (encoded as light pulses).
3. **RPi** (RX) receives `HELLO`, replies with `ACK` (light pulses back, or via TCP if Wi-Fi fallback).
4. If no `ACK` received, ESP8266 retries up to 3 times, blinking onboard LED each time.
5. After sync, both enable light-transfer mode.

### UDP Fallback

1. If TCP handshake fails, ESP8266 sends UDP broadcast `HELLO` on port 9001.
2. **RPi** listens for UDP, replies with `ACK`.
3. If still no response, ESP8266 enables Wi-Fi AP mode (SSID: LIFI-ESP8266, Pass: lifi1234).

---

## 4. Timeout and Retry Logic

- **Handshake Timeout:** 2 seconds per attempt
- **Retry Limit:** 3 attempts before fallback
- **LED Codes:**
  - Fast blink: handshake fail
  - Slow blink: waiting for partner
  - Solid: link established

---

## 5. Light/Blink Encoding Strategy

- **Manchester Encoding** (recommended):
  - Logical '1': 100ms HIGH, 100ms LOW
  - Logical '0': 100ms LOW, 100ms HIGH
  - Ensures clock recovery and noise immunity
- **Alternative: PWM**
  - Use 50% duty cycle, 1kHz for '1', 500Hz for '0'
- **Packet Structure:**
  - `[HEADER][DATA][CHECKSUM]`
  - HEADER: 0xAA55 (sync), LEN, TYPE
  - DATA: Payload (max 256 bytes)
  - CHECKSUM: XOR of all bytes

---

## 6. Example Sequence

1. ESP8266 powers up, blinks LED, sends `HELLO` via light (Manchester encoded)
2. RPi detects light pulses, decodes `HELLO`, replies with `ACK`
3. ESP8266 receives `ACK`, both enter data transfer mode
4. If no `ACK`, ESP8266 retries, then falls back to UDP or Wi-Fi AP

---

## 7. Error Handling

- **Checksum/XOR**: All packets verified before processing
- **Timeouts**: Retries and fallback as above

---

## 8. Test Commands

- Test TCP: `nc <rpi_ip> 9000`
- Test UDP: `nc -u -b 255.255.255.255 9001`

---

> For wiring and flashing, see board-specific READMEs.
