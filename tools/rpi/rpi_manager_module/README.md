# Raspberry Pi Manager

A comprehensive Python module for managing Raspberry Pi devices, including detection, flashing, SSH/VNC connectivity, and custom OS building.

## Features

- **Device Detection**: Automatically detect Raspberry Pi devices connected via:
  - USB
  - Serial ports
  - Network (SSH)

- **OS Flashing**: Flash Raspberry Pi OS images to SD cards
  - Support for various image formats (.img, .iso, .zip)
  - Progress tracking
  - Verification option

- **SSH/VNC Connectivity**: Connect to Raspberry Pi devices via:
  - SSH (using platform-specific SSH clients)
  - VNC (using platform-specific VNC viewers)
  - Connection testing

- **Custom OS Building**: Build custom Raspberry Pi OS images
  - Based on official Raspberry Pi OS
  - Customize hostname, username, password
  - Configure WiFi settings
  - Enable/disable SSH and VNC
  - Add custom scripts

## Installation

### From PyPI (Recommended)

```bash
pip install rpi-manager
```

### From Source

```bash
git clone https://github.com/lifiproject/rpi-manager.git
cd rpi-manager
pip install -e .
```

## Usage

### As a GUI Application

Simply run the installed application:

```bash
rpi-manager-gui
```

### As a Command-Line Tool

```bash
rpi-manager detect  # Detect Raspberry Pi devices
rpi-manager flash <image> <device>  # Flash an image to a device
rpi-manager ssh <host> [--username=pi] [--password=raspberry]  # Connect to a device via SSH
```

### As a Python Module

```python
from rpi_manager import RaspberryPiManager

# Detect devices
manager = RaspberryPiManager()
devices = manager.detect_devices()

# Flash an image
manager.flash_image("raspbian.img", "/dev/sdb")

# Connect to a device
manager.connect_ssh("192.168.1.100", username="pi", password="raspberry")
```

## Requirements

- Python 3.6 or higher
- Required Python packages (automatically installed):
  - tkinter (usually included with Python)
  - pyserial (for serial port detection)
  - paramiko (for SSH connectivity)

## License

MIT License