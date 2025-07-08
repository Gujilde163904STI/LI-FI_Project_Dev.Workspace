"""
TX Controller: Sends data over serial to ESP8266 LI-FI TX.
# CHECK_SERIAL_PERMS: Ensure /dev/ttyUSB0 has correct permissions (adduser pi dialout)
# HARDWARE_VERIFY: This section must be tested with real hardware!
"""

import serial
import json
import time

def load_settings():
    with open("../config/settings.json") as f:
        return json.load(f)

def main():
    settings = load_settings()
    port = settings["serial"]["tx_port"]
    baudrate = settings["serial"]["baudrate"]
    timeout = settings["serial"]["timeout_sec"]

    try:
        with serial.Serial(port, baudrate, timeout=timeout) as ser:
            while True:
                data = "HELLO_LIFI"
                ser.write((data + "\n").encode())
                print(f"[TX] Sent: {data}")
                time.sleep(1)
    except serial.SerialException as e:
        print(f"[ERROR] Serial failed: {e}")

if __name__ == "__main__":
    main()