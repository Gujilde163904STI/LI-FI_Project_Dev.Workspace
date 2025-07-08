# config/README.md

## LI-FI System Configuration

- `settings.json`: Central configuration for serial ports, baudrate, GPIO pins, and LI-FI modulation settings.

### Example

```json
{
  "serial": {
    "tx_port": "/dev/ttyUSB0",
    "rx_port": "/dev/ttyUSB1",
    "baudrate": 115200,
    "timeout_sec": 1
  },
  "gpio": {
    "tx_led_pin": 2,
    "rx_photodiode_pin": "A0",
    "active_high": true
  },
  "lifi": {
    "modulation_type": "basic_on_off",
    "pulse_delay_ms": 1
  }
}
```

---

# HARDWARE_VERIFY: Update config values to match your hardware setup before deployment.
