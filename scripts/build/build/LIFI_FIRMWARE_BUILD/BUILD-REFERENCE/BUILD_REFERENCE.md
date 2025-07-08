# LI-FI Project: Build Reference & Advanced Protocols

## 1. Project Structure Overview

- **ESP8266/**: NodeMCU firmware (PlatformIO, Arduino, C++)
- **RPI3/**, **RPI4/**: Raspberry Pi firmware (Python, GPIO, serial)
- **PROTOCOLS/**: Protocol libraries, message formats, and integration logic
- **SCRIPTS/**: Automation for flashing, validation, deployment
- **BUILD-REFERENCE/**: Schematics, wiring, PCB, and protocol reference (this doc)
- **DOCS/**, **DOCUMENTATIONS/**: Guides, API, and integration notes
- **NETWORK.DEV@...**: Advanced libraries for IoT, security, database, and protocol integration

## 2. Hardware Integration Reference

- **ESP8266 ↔ RPi**: Serial UART (3.3V logic), 115200 baud, GND shared
- **Photodiode/LED**: Connect to GPIO as per `hardware_docs/` diagrams
- **Wiring**: See `WIRING-CORE.DIAGRAM/` and `hardware_docs/`

## 3. Advanced LI-FI Protocol (Reference)

- **Physical Layer**: On-Off Keying (OOK) via LED/photodiode
- **Bit Rate**: 1 kHz (configurable)
- **Frame Format**: JSON over serial, e.g. `{ "cmd": "lifi_tx", "data": [1,0,1,1] }`
- **Error Handling**: Add CRC or checksum field in JSON for robust comms
- **Timing**: Use `LIFI*FREQ` and `LIFI*DUTY_CYCLE` for precise bit timing
- **Handshake**: Optional `{ "cmd": "handshake", "role": "rpi3" }` before data exchange
- **ACK/NACK**: `{ "cmd": "ack" }` or `{ "cmd": "nack" }` after each frame

## 4. Protocol Extension Points

- **Security**: Integrate with `NETWORK.DEV@DTLS-TLS` for encrypted payloads
- **IoT/Cloud**: Use `NETWORK.DEV@FRAMEWORKS` (e.g., MQTT, Node-RED) for remote control
- **Database**: Log frames or events to `NETWORK.DEV@DATABASE` (e.g., SQLite, InfluxDB)
- **Binary Protocols**: Use `NETWORK.DEV@BINARY-LIBRARY` for efficient encoding
- **DNSSEC**: Secure device discovery with `NETWORK.DEV@DNS-SEC`
- **Custom Protocols**: Extend via `PROTOCOLS/` and `NETWORK.DEV@PROTOCOL`

## 5. Build & Deployment Automation

- Use `SCRIPTS/flash*esp.sh`, `flash*rpi3.sh`, `flash_rpi4.sh` for device flashing
- Use `SCRIPTS/deploy*lifi*rpi.sh` for automated RPi deployment
- PlatformIO (`ESP8266/platformio.ini`) for firmware builds
- Python virtualenv for RPi builds (`requirements.txt`)

## 6. Example: Advanced Protocol JSON Frame

```json
{
  "cmd": "lifi_tx",
  "data": [1,0,1,1,0,1],
  "crc": "a1b2c3",
  "ts": 1720000000,
  "role": "rpi3"
}
```

## 7. Further Reading & Integration

- See `DOCS/main/` and `DOCUMENTATIONS/` for detailed guides
- Reference `PROTOCOLS/lib/` for protocol code
- Use `DEPLOYMENT+CORE=SCRIPTS/` for cross-platform automation
- Integrate with `IOT/`, `INTEGRATIONS/`, and `HARDWARES/` as needed

---

**This document is a living reference. Update as protocols, hardware, and integration points evolve.**

