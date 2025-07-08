#!/usr/bin/env python3
"""
List all connected serial/USB devices (cross-platform).
- Works on Windows, macOS, Linux
- Shows port, description, and hardware ID
- Can be run locally or remotely (e.g., via VS Code Remote/Live Share)
"""
import sys
try:
    import serial.tools.list_ports
except ImportError:
    print("pyserial is required. Run: pip install pyserial")
    sys.exit(1)

def list_serial_devices():
    ports = serial.tools.list_ports.comports()
    if not ports:
        print("No serial/USB devices found.")
        return
    print("Connected serial/USB devices:")
    for port in ports:
        print(f"- Port: {port.device}")
        print(f"  Description: {port.description}")
        print(f"  HWID: {port.hwid}\n")

if __name__ == "__main__":
    list_serial_devices()
