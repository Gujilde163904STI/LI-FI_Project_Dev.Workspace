"""
serial_receive.py
Example script to receive data over serial on Raspberry Pi.

NOTE: This is a standalone example. For main project operation, use rx/rx_controller.py which is config-driven and production-ready.
"""
import serial

def receive_serial(port, baudrate):
    """Receive data over serial port."""
    with serial.Serial(port, baudrate, timeout=1) as ser:
        while True:
            data = ser.readline().decode().strip()
            if data:
                print(f"Received: {data}")

if __name__ == "__main__":
    PORT = "/dev/ttyUSB0"  # Update as needed
    BAUDRATE = 9600
    receive_serial(PORT, BAUDRATE)
