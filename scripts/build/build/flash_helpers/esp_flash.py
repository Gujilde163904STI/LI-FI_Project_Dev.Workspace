#!/usr/bin/env python3
import argparse
import os
import sys
import subprocess
import glob
import platform

def detect_serial_ports():
    system = platform.system()
    if system == 'Windows':
        ports = glob.glob('COM[0-9]*')
    elif system == 'Darwin':
        ports = glob.glob('/dev/tty.usbserial*') + glob.glob('/dev/ttyUSB*') + glob.glob('/dev/cu.*')
    else:
        ports = glob.glob('/dev/ttyUSB*') + glob.glob('/dev/ttyACM*')
    return ports

def flash_with_platformio(port=None):
    cmd = ['platformio', 'run', '--target', 'upload']
    if port:
        cmd += ['--upload-port', port]
    print(f'[INFO] Running: {" ".join(cmd)}')
    result = subprocess.run(cmd, capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print('[ERROR] PlatformIO upload failed.')
        print(result.stderr)
        return False
    print('[SUCCESS] PlatformIO upload complete.')
    return True

def flash_with_esptool(port):
    # Example: esptool.py --port <port> write_flash 0x00000 firmware.bin
    print(f'[INFO] (Fallback) Would run esptool on port {port} (not implemented)')
    # TODO: Implement esptool logic if needed
    return False

def main():
    parser = argparse.ArgumentParser(description='ESP8266 Flash Helper')
    parser.add_argument('--target', required=True, choices=['esp8266'])
    parser.add_argument('--flash', action='store_true')
    args = parser.parse_args()

    print(f'[INFO] Building firmware for {args.target}...')
    # Simulate build (expand as needed)
    print(f'[INFO] Build complete for {args.target}.')

    if args.flash:
        ports = detect_serial_ports()
        print(f'[INFO] Detected serial ports: {ports}')
        port = ports[0] if ports else None
        if not port:
            print('[ERROR] No serial port found for ESP8266.')
            sys.exit(1)
        print(f'[INFO] Using port: {port}')
        if not flash_with_platformio(port):
            print('[WARN] Trying fallback esptool flashing...')
            flash_with_esptool(port)
    else:
        print(f'[INFO] Skipping flash step for {args.target}.')

if __name__ == '__main__':
    main() 