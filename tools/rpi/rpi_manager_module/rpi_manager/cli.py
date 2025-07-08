#!/usr/bin/env python3
"""
Raspberry Pi Manager CLI

Command-line interface for:
1. Detecting Raspberry Pi devices
2. Flashing Raspberry Pi OS images
3. SSH/VNC connection to Raspberry Pi
4. Custom OS building
"""

import os
import sys
import argparse
import platform
import subprocess
from . import __version__
from .core import RaspberryPiCore

def detect_command(args):
    """Handle the detect command"""
    core = RaspberryPiCore()
    devices = core.detect_devices(usb=args.usb, serial=args.serial, network=args.network)
    
    # Print detected devices
    print(f"Found {len(devices)} Raspberry Pi devices:")
    for i, device in enumerate(devices, 1):
        print(f"{i}. {device['type']}: {device['id']} - {device['description']}")
    
    return 0

def flash_command(args):
    """Handle the flash command"""
    if not os.path.exists(args.image):
        print(f"Error: Image file '{args.image}' does not exist")
        return 1
    
    print(f"Flashing {args.image} to {args.device}...")
    
    core = RaspberryPiCore()
    result = core.flash_image(args.image, args.device, verify=args.verify)
    
    if result:
        print("Flashing completed successfully!")
        return 0
    else:
        print("Flashing failed!")
        return 1

def ssh_command(args):
    """Handle the ssh command"""
    print(f"Connecting to {args.host} via SSH...")
    
    core = RaspberryPiCore()
    result = core.connect_ssh(args.host, username=args.username, password=args.password, port=args.port)
    
    if result:
        print("SSH connection established")
        return 0
    else:
        print("SSH connection failed")
        return 1

def vnc_command(args):
    """Handle the vnc command"""
    print(f"Connecting to {args.host} via VNC...")
    
    core = RaspberryPiCore()
    result = core.connect_vnc(args.host, port=args.port)
    
    if result:
        print("VNC connection established")
        return 0
    else:
        print("VNC connection failed")
        return 1

def build_command(args):
    """Handle the build command"""
    print(f"Building custom OS with base {args.base_os}...")
    
    core = RaspberryPiCore()
    result = core.build_custom_os(
        base_os=args.base_os,
        hostname=args.hostname,
        username=args.username,
        password=args.password,
        wifi_ssid=args.wifi_ssid,
        wifi_password=args.wifi_password,
        enable_ssh=args.enable_ssh,
        enable_vnc=args.enable_vnc,
        output_dir=args.output_dir
    )
    
    if result:
        print("Custom OS build completed successfully!")
        return 0
    else:
        print("Custom OS build failed!")
        return 1

def gui_command(args):
    """Launch the GUI"""
    from .gui import main as gui_main
    return gui_main()

def main():
    """Main entry point for the CLI"""
    parser = argparse.ArgumentParser(description="Raspberry Pi Manager CLI")
    parser.add_argument('--version', action='version', version=f'%(prog)s {__version__}')
    
    subparsers = parser.add_subparsers(dest='command', help='Command to run')
    
    # Detect command
    detect_parser = subparsers.add_parser('detect', help='Detect Raspberry Pi devices')
    detect_parser.add_argument('--usb', action='store_true', help='Detect USB devices')
    detect_parser.add_argument('--serial', action='store_true', help='Detect serial devices')
    detect_parser.add_argument('--network', action='store_true', help='Detect network devices')
    detect_parser.set_defaults(func=detect_command)
    
    # Flash command
    flash_parser = subparsers.add_parser('flash', help='Flash Raspberry Pi OS image')
    flash_parser.add_argument('image', help='Path to image file')
    flash_parser.add_argument('device', help='Target device')
    flash_parser.add_argument('--verify', action='store_true', help='Verify after flashing')
    flash_parser.set_defaults(func=flash_command)
    
    # SSH command
    ssh_parser = subparsers.add_parser('ssh', help='Connect to Raspberry Pi via SSH')
    ssh_parser.add_argument('host', help='Hostname or IP address')
    ssh_parser.add_argument('--username', default='pi', help='SSH username')
    ssh_parser.add_argument('--password', default='raspberry', help='SSH password')
    ssh_parser.add_argument('--port', type=int, default=22, help='SSH port')
    ssh_parser.set_defaults(func=ssh_command)
    
    # VNC command
    vnc_parser = subparsers.add_parser('vnc', help='Connect to Raspberry Pi via VNC')
    vnc_parser.add_argument('host', help='Hostname or IP address')
    vnc_parser.add_argument('--port', type=int, default=5900, help='VNC port')
    vnc_parser.set_defaults(func=vnc_command)
    
    # Build command
    build_parser = subparsers.add_parser('build', help='Build custom Raspberry Pi OS')
    build_parser.add_argument('--base-os', default='Raspberry Pi OS Lite (32-bit)', help='Base OS')
    build_parser.add_argument('--hostname', default='raspberrypi', help='Hostname')
    build_parser.add_argument('--username', default='pi', help='Username')
    build_parser.add_argument('--password', default='raspberry', help='Password')
    build_parser.add_argument('--wifi-ssid', help='WiFi SSID')
    build_parser.add_argument('--wifi-password', help='WiFi password')
    build_parser.add_argument('--enable-ssh', action='store_true', help='Enable SSH')
    build_parser.add_argument('--enable-vnc', action='store_true', help='Enable VNC')
    build_parser.add_argument('--output-dir', default=os.path.join(os.path.expanduser('~'), 'custom_rpi_os'), help='Output directory')
    build_parser.set_defaults(func=build_command)
    
    # GUI command
    gui_parser = subparsers.add_parser('gui', help='Launch the GUI')
    gui_parser.set_defaults(func=gui_command)
    
    args = parser.parse_args()
    
    # If no command is specified, show help
    if not hasattr(args, 'func'):
        parser.print_help()
        return 1
    
    # Execute the command
    return args.func(args)

if __name__ == '__main__':
    sys.exit(main())