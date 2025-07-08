# tx/README.md

## LI-FI Transmitter Code

- `tx_pi.py`: Python script for Raspberry Pi to send data over serial to ESP8266.
- `tx_esp8266.ino`: ESP8266 Arduino code to modulate LED (GPIO2/D4) for light transmission.

### Hardware
- Raspberry Pi 3B/4B (Python 3.x, pyserial)
- NodeMCU ESP8266 (V3/CH340G/ESP-12E)
- LED on GPIO2 (D4)

---

# HARDWARE_VERIFY: Test transmitter with real hardware for production deployment.
