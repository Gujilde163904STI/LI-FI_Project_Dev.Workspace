# rx/README.md

## LI-FI Receiver Code

- `rx_pi.py`: Python script for Raspberry Pi to receive data from ESP8266 via serial.
- `rx_esp8266.ino`: ESP8266 Arduino code to decode light pulses from photodiode (A0) and send data over serial.

### Hardware
- Raspberry Pi 3B/4B (Python 3.x, pyserial)
- NodeMCU ESP8266 (V3/CH340G/ESP-12E)
- Photodiode on A0 analog input

---

# HARDWARE_VERIFY: Test receiver with real hardware for production deployment.
