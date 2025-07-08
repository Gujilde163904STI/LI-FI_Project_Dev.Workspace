# tcp_light_server_v2.py
# RPi3 Light TCP Server v2 - Improved Decoding & Retry Logic
#
# This script implements a TCP server that decodes light signals using GPIO.
# Includes retry logic for robust communication.
#
# GPIO Pin Assignments (update as needed):
# LIGHT_RX_PIN = 17  # Example: GPIO17 for light reception
#
# TODO: Implement improved light decoding
# TODO: Add retry logic and diagnostics

import socket
import RPi.GPIO as GPIO
import time

LIGHT_RX_PIN = 17  # BCM numbering
RETRY_LIMIT = 3

GPIO.setmode(GPIO.BCM)
GPIO.setup(LIGHT_RX_PIN, GPIO.IN)

def decode_light_signal():
    # TODO: Implement improved decoding logic
    # Placeholder for light signal decoding
    return GPIO.input(LIGHT_RX_PIN)

def handle_client(conn):
    retries = 0
    while retries < RETRY_LIMIT:
        try:
            data = decode_light_signal()
            # TODO: Process data
            conn.sendall(b'ACK')
            break
        except Exception as e:
            retries += 1
            print(f"Retry {retries}/{RETRY_LIMIT}: {e}")
            time.sleep(0.5)
    else:
        conn.sendall(b'FAIL')

def main():
    HOST = ''
    PORT = 12345
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        print(f"Listening on port {PORT}...")
        while True:
            conn, addr = s.accept()
            with conn:
                print(f"Connected by {addr}")
                handle_client(conn)

if __name__ == "__main__":
    try:
        main()
    finally:
        GPIO.cleanup() 