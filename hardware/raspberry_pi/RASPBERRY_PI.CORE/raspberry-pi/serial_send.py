"""
serial_send.py
Example script to send data over serial from Raspberry Pi.

NOTE: This is a standalone example. For main project operation, use tx/tx_controller.py which is config-driven and production-ready.
"""
import serial
import time

def send_serial(port, baudrate, data):
    """Send data over serial port."""
    with serial.Serial(port, baudrate, timeout=1) as ser:
        ser.write(data.encode())
        print(f"Sent: {data}")

if __name__ == "__main__":
    PORT = "/dev/ttyUSB0"  # Update as needed
    BAUDRATE = 9600
    DATA = "Hello, LI-FI!"
    send_serial(PORT, BAUDRATE, DATA)
