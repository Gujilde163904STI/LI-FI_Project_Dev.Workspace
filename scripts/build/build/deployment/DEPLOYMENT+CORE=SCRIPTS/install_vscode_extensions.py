#!/usr/bin/env python3
"""
VS Code Extension Auto-Installer for LI-FI Project
- Detects Windows/macOS
- Installs all recommended extensions for this workspace (PlatformIO, Arduino, Python, Pylance, C++, serial/USB tools, device recognition, etc.)
- Can be run manually or on workspace open (add to onboarding docs)
"""
import os
import platform
import subprocess
import sys

# List of essential VS Code extensions for this project
EXTENSIONS = [
    "platformio.platformio-ide",         # PlatformIO (embedded/ESP8266)
    "ms-python.python",                 # Python
    "ms-python.vscode-pylance",         # Pylance (Python IntelliSense)
    "ms-vscode.cpptools",               # C/C++
    "ms-vscode.cmake-tools",            # CMake (for Pico/RPi C++)
    "ms-vscode.arduino",                # Arduino
    "kash4kev.vscode-esp8266fs",        # ESP8266/ESP32 File System
    "hancel.serialport-helper",         # Serial Port Helper
    "invisibleman1002.serialdevices",   # Serial Devices (COM/USB)
    "mcu-debug.memory-view",            # Embedded Memory View
    "mcu-debug.rtos-views",             # RTOS Views
    "paulober.pico-w-go",               # Raspberry Pi Pico MicroPython
    "kingwampy.raspberrypi-sync",       # Raspberry Pi Sync
    "cschlosser.doxdocgen",             # Doxygen (C/C++/Arduino docs)
    "quicktype.quicktype",              # Paste JSON as Code (C++/Python)
    "dankeboy36.vscode-arduino-api",    # Arduino API
    "innuendopi.vscode-espfs"           # ESP8266/ESP32 File System (alt)
]

# Windows-specific extensions for device/USB recognition
WINDOWS_ONLY = [
    "arm.device-manager",               # ARM Device Manager (USB/serial)
    "thecreativedodo.usbip-connect",    # USBIP Connect (WSL/USB)
    "eclipse-cdt.serial-monitor"        # Serial Monitor
]


def install_extension(ext_id):
    try:
        subprocess.run(["code", "--install-extension", ext_id], check=True)
        print(f"Installed: {ext_id}")
    except subprocess.CalledProcessError:
        print(f"Failed or already installed: {ext_id}")


def main():
    system = platform.system().lower()
    all_exts = EXTENSIONS.copy()
    if system == "windows":
        all_exts += WINDOWS_ONLY
    print("Installing VS Code extensions for LI-FI Project...")
    for ext in all_exts:
        install_extension(ext)
    print("\nAll recommended extensions processed.")
    print("If you see errors, ensure 'code' (VS Code CLI) is in your PATH.")

if __name__ == "__main__":
    main()
