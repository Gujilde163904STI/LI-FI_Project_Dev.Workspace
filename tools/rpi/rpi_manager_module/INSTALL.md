# Installing Raspberry Pi Manager

Raspberry Pi Manager is a versatile tool designed for managing Raspberry Pi devices. It includes a GUI interface for ease of use and a CLI interface for advanced users. This module supports device detection, flashing images, and SSH connectivity to Raspberry Pi devices.

This document provides detailed instructions for installing and using the Raspberry Pi Manager module.

## Installation Methods

### From PyPI (Recommended)

The easiest way to install Raspberry Pi Manager is from PyPI:

```bash
pip install rpi-manager
```

This will install the module and all its dependencies, and create executable scripts for both the GUI and CLI interfaces.

### From Source

To install from source:

1. Clone the repository or download the source code:
   ```bash
   git clone https://github.com/lifiproject/rpi-manager.git
   cd rpi-manager
   ```

2. Install the package in development mode:
   ```bash
   pip install -e .
   ```

3. Or build and install the package:
   ```bash
   pip install build
   python -m build
   pip install dist/rpi_manager-*.whl
   ```

## Dependencies

The following dependencies will be automatically installed:

- pyserial: For serial port detection
- paramiko: For SSH connectivity

Tkinter is required for the GUI interface but is usually included with Python. If it's not installed, you'll need to install it separately:

- On Debian/Ubuntu: `sudo apt-get install python3-tk`
- On Fedora: `sudo dnf install python3-tkinter`
- On macOS: Tkinter is included with the Python installer from python.org
- On Windows: Tkinter is included with the Python installer from python.org

## Usage

### GUI Interface

After installation, you can launch the GUI interface with:

```bash
rpi-manager-gui
```

Or from Python:

```python
from rpi_manager.gui import main
main()
```

### CLI Interface

The CLI interface provides commands for detecting devices, flashing images, and connecting to devices:

```bash
# Show help
rpi-manager --help

# Detect devices
rpi-manager detect

# Flash an image
rpi-manager flash path/to/image.img /dev/sdX

# Connect to a device via SSH
rpi-manager ssh 192.168.1.100 --username=pi --password=raspberry

# Launch the GUI
rpi-manager gui
```

### Python API

You can also use the module as a Python API:

```python
from rpi_manager.core import RaspberryPiCore

# Create a core instance
core = RaspberryPiCore()

# Detect devices
devices = core.detect_devices()

# Flash an image
core.flash_image("path/to/image.img", "/dev/sdX")

# Connect to a device via SSH
core.connect_ssh("192.168.1.100", username="pi", password="raspberry")
```

## Troubleshooting

### Missing Dependencies

If you encounter errors about missing dependencies, try installing them manually:

```bash
pip install pyserial paramiko
```

### Permission Issues

On Linux, you may need root permissions to access devices:

```bash
sudo rpi-manager flash path/to/image.img /dev/sdX
```

### GUI Issues

If the GUI doesn't start, ensure that tkinter is installed:

```bash
python -c "import tkinter; tkinter._test()"
```

If this fails, install tkinter using your system's package manager.