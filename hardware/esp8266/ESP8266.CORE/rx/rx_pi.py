"""
rx/rx_pi.py
Raspberry Pi LI-FI receiver: Reads from ESP8266 via serial, prints decoded data.
# CHECK_SERIAL_PERMS: Ensure user is in 'dialout' group for serial access.
# HARDWARE_VERIFY: Test with real hardware.
"""

import time
from lib.utils.serial_utils import load_config, open_serial, safe_read, close_serial

def main():
    config = load_config()
    port = config['serial']['rx_port']
    baudrate = config['serial']['baudrate']
    timeout = config['serial']['timeout_sec']
    
    ser = open_serial(port, baudrate, timeout)
    print(f"[RX] Serial open on {port} @ {baudrate} baud.")
    try:
        while True:
            data = safe_read(ser, size=128)
            if data:
                print(f"[RX] Received: {data.decode('utf-8', errors='replace').strip()}")
            time.sleep(0.01)
    except KeyboardInterrupt:
        print("[RX] Interrupted.")
    finally:
        close_serial(ser)
        print("[RX] Serial closed.")

if __name__ == "__main__":
    main()
