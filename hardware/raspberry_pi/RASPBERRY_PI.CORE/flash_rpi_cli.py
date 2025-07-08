#!/usr/bin/env python3
"""
CLI tool to flash Raspberry Pi images to SD cards using dd or rpi-imager.
- Lists available removable devices
- Prompts user for device and image selection
- Flashes image with progress
"""
import os
import sys
import subprocess
import glob
import platform

def list_removable_devices():
    # macOS: /dev/disk* (external, removable)
    if platform.system() == 'Darwin':
        disks = subprocess.check_output(['diskutil', 'list', '-plist']).decode()
        # For simplicity, fallback to /dev/disk* for now
        devices = glob.glob('/dev/disk*')
        return [d for d in devices if 'disk' in d and not d.endswith('s1')]
    elif platform.system() == 'Linux':
        devices = glob.glob('/dev/sd*')
        return [d for d in devices if d[-1].isdigit() is False]
    else:
        print('Unsupported OS')
        sys.exit(1)

def select_device(devices):
    print('Available devices:')
    for idx, dev in enumerate(devices):
        print(f'{idx+1}: {dev}')
    choice = int(input('Select device number to flash: '))
    return devices[choice-1]

def select_image():
    img = input('Enter path to Raspberry Pi image (.img, .iso, .zip): ')
    if not os.path.exists(img):
        print('Image file does not exist.')
        sys.exit(1)
    return img

def flash_with_dd(image, device):
    print(f'Flashing {image} to {device} using dd...')
    # Unmount device first (macOS)
    if platform.system() == 'Darwin':
        subprocess.run(['diskutil', 'unmountDisk', device], check=True)
    cmd = ['sudo', 'dd', f'if={image}', f'of={device}', 'bs=4m', 'status=progress']
    subprocess.run(cmd, check=True)
    print('Flashing complete!')

def flash_with_rpi_imager(image, device):
    print('Attempting to use rpi-imager...')
    cmd = ['rpi-imager', '--cli', '--image', image, '--target', device]
    subprocess.run(cmd, check=True)
    print('Flashing complete!')

def main():
    devices = list_removable_devices()
    if not devices:
        print('No removable devices found.')
        sys.exit(1)
    device = select_device(devices)
    image = select_image()
    # Try rpi-imager first
    if shutil.which('rpi-imager'):
        flash_with_rpi_imager(image, device)
    else:
        flash_with_dd(image, device)

if __name__ == '__main__':
    import shutil
    main()

