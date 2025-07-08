"""
RX Controller: Reads data from ESP8266 LI-FI RX.
# CHECK_SERIAL_PERMS: Ensure /dev/ttyUSB1 has correct permissions (adduser pi dialout)
# HARDWARE_VERIFY: This section must be tested with real hardware!
"""

import serial
import json

def load_settings():
    with open("../config/settings.json") as f:
        return json.load(f)

def main():
    settings = load_settings()
    port = settings["serial"]["rx_port"]
    baudrate = settings["serial"]["baudrate"]
    timeout = settings["serial"]["timeout_sec"]

    try:
        with serial.Serial(port, baudrate, timeout=timeout) as ser:
            while True:
                if ser.in_waiting:
                    line = ser.readline().decode().strip()
                    print(f"[RX] Received: {line}")
    except serial.SerialException as e:
        print(f"[ERROR] Serial failed: {e}")

if __name__ == "__main__":
    main()