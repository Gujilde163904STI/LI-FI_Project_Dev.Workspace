import RPi.GPIO as GPIO
import json
import numpy as np
import os
import serial
import sys
import time
from pathlib import Path

# --- Integration: Reference root resources ---
ROOT_DIR = Path(__file__).resolve().parents[2]
CONFIG_PATH = ROOT_DIR / 'config' / 'project_config.json'
TOOLS_PATH = ROOT_DIR / 'TOOLS'
ARDUINO_CORE_PATH = ROOT_DIR / 'ARDUINO-CORE'

# --- Serial Communication Settings ---
SERIAL_PORT = '/dev/ttyUSB0'  # Update as needed for your RPi
BAUD_RATE = 115200
TIMEOUT = 2

# --- LI-FI GPIO Pin Definitions ---
PHOTODIODE_PIN = 17  # BCM numbering, update as needed
LED_PIN = 27         # BCM numbering, update as needed

# --- LI-FI Protocol Parameters ---
LIFI_FREQ = 1000  # Hz
LIFI_DUTY_CYCLE = 50  # %

# --- Example: Message format (JSON) ---
def send_message(ser, data):
    msg = json.dumps(data) + '\n'
    ser.write(msg.encode('utf-8'))
    print(f"[TX] {msg.strip()}")

def receive_message(ser):
    line = ser.readline().decode('utf-8').strip()
    if line:
        try:
            data = json.loads(line)
            print(f"[RX] {data}")
            return data
        except json.JSONDecodeError:
            print(f"[RX-ERR] Invalid JSON: {line}")
    return None

# --- GPIO Setup ---
GPIO.setmode(GPIO.BCM)
GPIO.setup(PHOTODIODE_PIN, GPIO.IN)
GPIO.setup(LED_PIN, GPIO.OUT)

# --- LI-FI Transmit Function ---
def lifi_transmit_bit(bit):
    GPIO.output(LED_PIN, GPIO.HIGH if bit else GPIO.LOW)
    time.sleep(1.0 / LIFI_FREQ)
    GPIO.output(LED_PIN, GPIO.LOW)

# --- LI-FI Receive Function ---
def lifi_receive_bit():
    # Simple thresholding, can be replaced with ADC or advanced logic
    return GPIO.input(PHOTODIODE_PIN)

# --- Main Loop: LI-FI Protocol + Serial ---
if __name__ == "__main__":
    # --- Ensure all resources are accessible ---
    print(f"Using config: {CONFIG_PATH}")
    print(f"Using tools: {TOOLS_PATH}")
    print(f"Using Arduino core: {ARDUINO_CORE_PATH}")

    # --- Open serial port ---
    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=TIMEOUT)
        print(f"Opened serial port {SERIAL_PORT} at {BAUD_RATE} baud.")
    except serial.SerialException as e:
        print(f"[ERROR] Could not open serial port: {e}")
        sys.exit(1)

    # --- Main loop: Example send/receive ---
    try:
        while True:
            # Example: Send a test message
            send_message(ser, {"role": "rpi3", "cmd": "ping", "ts": time.time()})
            # Example: Wait for a response
            response = receive_message(ser)
            # Example: Receive command from serial (e.g., {"cmd": "lifi_tx", "data": [1,0,1,1]})
            msg = receive_message(ser)
            if msg and msg.get("cmd") == "lifi_tx":
                for bit in msg.get("data", []):
                    lifi_transmit_bit(bit)
                send_message(ser, {"role": "rpi3", "status": "tx_done", "ts": time.time()})
            # Example: Periodically sample photodiode and send result
            rx_bit = lifi_receive_bit()
            send_message(ser, {"role": "rpi3", "cmd": "lifi_rx", "bit": int(rx_bit), "ts": time.time()})
            time.sleep(2)
    except KeyboardInterrupt:
        print("Exiting...")
    finally:
        ser.close()
        GPIO.cleanup()
