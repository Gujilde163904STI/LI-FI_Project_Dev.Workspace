#!/usr/bin/env python3
import argparse
import os
import sys
import subprocess
import glob
import platform

def detect_sd_cards():
    system = platform.system()
    if system == 'Windows':
        # Windows: Use wmic or diskpart (not implemented)
        return []
    elif system == 'Darwin':
        # macOS: /dev/diskN (external, removable)
        return glob.glob('/dev/disk*')
    else:
        # Linux: /dev/sdX (removable)
        return glob.glob('/dev/sd*')

def write_image_to_sd(image_path, device):
    print(f'[INFO] Would write {image_path} to {device} (simulated)')
    # TODO: Use dd (Linux/macOS) or Win32DiskImager (Windows)
    return True

def remote_exec_flash(host, user, image_path):
    print(f'[INFO] Would remotely flash {image_path} to {host} as {user} (simulated)')
    # TODO: Use ssh/scp to copy and flash on remote RPi
    return True

def main():
    parser = argparse.ArgumentParser(description='RPi3/4 Flash Helper')
    parser.add_argument('--target', required=True, choices=['rpi3', 'rpi4'])
    parser.add_argument('--flash', action='store_true')
    parser.add_argument('--image', help='Path to SD card image (optional)')
    parser.add_argument('--remote', help='Remote RPi hostname/IP (optional)')
    parser.add_argument('--user', default='pi', help='Remote user (default: pi)')
    args = parser.parse_args()

    print(f'[INFO] Building firmware for {args.target}...')
    # Simulate build (expand as needed)
    print(f'[INFO] Build complete for {args.target}.')

    if args.flash:
        if args.remote:
            remote_exec_flash(args.remote, args.user, args.image or 'firmware.img')
        else:
            cards = detect_sd_cards()
            print(f'[INFO] Detected SD card devices: {cards}')
            device = cards[0] if cards else None
            if not device:
                print('[ERROR] No SD card device found.')
                sys.exit(1)
            print(f'[INFO] Using device: {device}')
            write_image_to_sd(args.image or 'firmware.img', device)
    else:
        print(f'[INFO] Skipping flash step for {args.target}.')

if __name__ == '__main__':
    main() 