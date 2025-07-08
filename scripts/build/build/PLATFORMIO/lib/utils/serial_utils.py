"""
utils/serial_utils.py
Utility functions for serial communication using pyserial.
"""

import serial
import time
import json
import os

CONFIG_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'config', 'settings.json')

def load_config():
    """Load configuration from settings.json."""
    with open(CONFIG_PATH, 'r') as f:
        return json.load(f)

def open_serial(port, baudrate, timeout):
    """Open and return a serial.Serial object."""
    try:
        ser = serial.Serial(port=port, baudrate=baudrate, timeout=timeout)
        return ser
    except serial.SerialException as e:
        raise RuntimeError(f"Serial open failed: {e}")

def safe_write(ser, data):
    """Write bytes to serial port, handle exceptions."""
    try:
        ser.write(data)
    except serial.SerialException as e:
        raise RuntimeError(f"Serial write failed: {e}")

def safe_read(ser, size=1):
    """Read bytes from serial port, handle exceptions."""
    try:
        return ser.read(size)
    except serial.SerialException as e:
        raise RuntimeError(f"Serial read failed: {e}")

def close_serial(ser):
    """Close serial port safely."""
    try:
        ser.close()
    except Exception:
        pass
