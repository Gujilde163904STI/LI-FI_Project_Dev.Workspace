"""
tx/tx_pi.py
Raspberry Pi LI-FI transmitter: Reads data from stdin or file, sends to ESP8266 via serial.
# CHECK_SERIAL_PERMS: Ensure user is in 'dialout' group for serial access.
# HARDWARE_VERIFY: Test with real hardware.
"""

import sys
import time
from lib.utils.serial_utils import load_config, open_serial, safe_write, close_serial


def main():
    config = load_config()
    port = config['serial']['tx_port']
    baudrate = config['serial']['baudrate']
    timeout = config['serial']['timeout_sec']
    
    ser = open_serial(port, baudrate, timeout)
    print(f"[TX] Serial open on {port} @ {baudrate} baud.")
    try:
        print("[TX] Enter text to transmit (Ctrl+D to end):")
        for line in sys.stdin:
            data = line.strip().encode('utf-8')
            if data:
                safe_write(ser, data + b'\n')
                print(f"[TX] Sent: {data}")
                time.sleep(0.01)
    except KeyboardInterrupt:
        print("[TX] Interrupted.")
    finally:
        close_serial(ser)
        print("[TX] Serial closed.")

if __name__ == "__main__":
    main()
