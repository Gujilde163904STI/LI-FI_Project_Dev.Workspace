#!/usr/bin/env python3
import argparse
import os
import sys
import subprocess
from datetime import datetime

# Supported targets
TARGETS = {
    'rpi3': {
        'desc': 'Raspberry Pi 3 (Python firmware)',
        'flash_helper': 'rpi_flash.py',
    },
    'rpi4': {
        'desc': 'Raspberry Pi 4 (Python firmware)',
        'flash_helper': 'rpi_flash.py',
    },
    'esp8266': {
        'desc': 'ESP8266 (PlatformIO C++ firmware)',
        'flash_helper': 'esp_flash.py',
    },
}

LOG_DIR = os.path.join(os.path.dirname(__file__), 'logs')
FLASH_HELPERS = os.path.join(os.path.dirname(__file__), 'flash_helpers')

os.makedirs(LOG_DIR, exist_ok=True)


def list_targets():
    print("Supported targets:")
    for t, v in TARGETS.items():
        print(f"  {t}: {v['desc']}")


def run_flash_helper(target, flash):
    helper = os.path.join(FLASH_HELPERS, TARGETS[target]['flash_helper'])
    if not os.path.exists(helper):
        print(f"[ERROR] Flash helper not found: {helper}")
        sys.exit(1)
    cmd = [sys.executable, helper, '--target', target]
    if flash:
        cmd.append('--flash')
    log_file = os.path.join(LOG_DIR, f"{target}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log")
    with open(log_file, 'w') as log:
        print(f"[INFO] Running: {' '.join(cmd)}")
        proc = subprocess.Popen(cmd, stdout=log, stderr=subprocess.STDOUT)
        proc.communicate()
        print(f"[INFO] Log saved to {log_file}")
    if proc.returncode != 0:
        print(f"[ERROR] Flash/build failed for {target}. See log: {log_file}")
        sys.exit(proc.returncode)
    print(f"[SUCCESS] {target} build/flash complete.")


def main():
    parser = argparse.ArgumentParser(description='LI-FI Unified Build/Flash Tool')
    parser.add_argument('--target', choices=TARGETS.keys(), help='Target board to build/flash')
    parser.add_argument('--flash', action='store_true', help='Flash firmware to device')
    parser.add_argument('--list-targets', action='store_true', help='List supported targets')
    args = parser.parse_args()

    if args.list_targets:
        list_targets()
        sys.exit(0)

    if not args.target:
        print("[ERROR] --target is required unless --list-targets is used.")
        sys.exit(1)

    run_flash_helper(args.target, args.flash)

if __name__ == '__main__':
    main() 