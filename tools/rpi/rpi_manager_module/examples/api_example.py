#!/usr/bin/env python3
"""
Example script demonstrating how to use the Raspberry Pi Manager as a Python API.
"""

import sys
import os

# Add the parent directory to the path so we can import the module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from rpi_manager.core import RaspberryPiCore

def main():
    """Main function demonstrating the RPI Manager API"""
    print("Raspberry Pi Manager API Example")
    print("================================")
    
    # Create a core instance
    core = RaspberryPiCore()
    
    # Detect devices
    print("\nDetecting Raspberry Pi devices...")
    devices = core.detect_devices()
    
    if not devices:
        print("No Raspberry Pi devices detected.")
        return
    
    print(f"Found {len(devices)} Raspberry Pi devices:")
    for i, device in enumerate(devices, 1):
        print(f"{i}. {device['type']}: {device['id']} - {device['description']}")
    
    # Ask user if they want to connect to a device
    if any(device['type'] == 'Network' for device in devices):
        network_devices = [device for device in devices if device['type'] == 'Network']
        print("\nNetwork devices available for SSH connection:")
        for i, device in enumerate(network_devices, 1):
            print(f"{i}. {device['id']} - {device['description']}")
        
        try:
            choice = int(input("\nEnter device number to connect to (or 0 to skip): "))
            if choice > 0 and choice <= len(network_devices):
                device = network_devices[choice - 1]
                print(f"Connecting to {device['id']} via SSH...")
                
                # Connect to the device via SSH
                result = core.connect_ssh(
                    device['id'],
                    username=input("Username (default: pi): ") or "pi",
                    password=input("Password (default: raspberry): ") or "raspberry"
                )
                
                if result:
                    print("SSH connection established!")
                else:
                    print("SSH connection failed.")
        except (ValueError, IndexError):
            print("Invalid choice, skipping SSH connection.")
    
    # Ask user if they want to flash an image
    if any(device['type'] in ['USB', 'Serial'] for device in devices):
        flashable_devices = [device for device in devices if device['type'] in ['USB', 'Serial']]
        print("\nDevices available for flashing:")
        for i, device in enumerate(flashable_devices, 1):
            print(f"{i}. {device['id']} - {device['description']}")
        
        try:
            choice = int(input("\nEnter device number to flash (or 0 to skip): "))
            if choice > 0 and choice <= len(flashable_devices):
                device = flashable_devices[choice - 1]
                
                image_path = input("Enter path to image file: ")
                if os.path.exists(image_path):
                    print(f"Flashing {image_path} to {device['id']}...")
                    
                    # Flash the image
                    result = core.flash_image(
                        image_path,
                        device['id'],
                        verify=input("Verify after flashing? (y/n): ").lower() == 'y'
                    )
                    
                    if result:
                        print("Flashing completed successfully!")
                    else:
                        print("Flashing failed.")
                else:
                    print(f"Image file {image_path} does not exist.")
        except (ValueError, IndexError):
            print("Invalid choice, skipping flashing.")
    
    print("\nExample completed.")

if __name__ == "__main__":
    main()