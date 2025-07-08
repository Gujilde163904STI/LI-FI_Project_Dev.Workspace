#!/usr/bin/env python3
"""
ESP8266 Flash Script for LI-FI Photodiode Sensor
Handles firmware upload and device configuration
"""

import os
import sys
import subprocess
import json
import time
from pathlib import Path
from typing import Optional, List


class ESP8266Flasher:
    """ESP8266 firmware flashing utility"""

    def __init__(self):
        self.project_root = Path(__file__).parent
        self.src_dir = self.project_root / "src"
        self.config_dir = self.project_root / "config"
        self.build_dir = self.project_root / ".pio" / "build" / "esp8266"

        # PlatformIO paths
        self.pio_home = Path.home() / ".platformio"
        self.esptool_path = self.pio_home / "packages" / "tool-esptool" / "esptool.py"

    def check_dependencies(self) -> bool:
        """Check if required tools are installed"""
        print("Checking dependencies...")

        # Check PlatformIO
        try:
            result = subprocess.run(
                ["pio", "--version"], capture_output=True, text=True, check=True
            )
            print(f"✓ PlatformIO: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("✗ PlatformIO not found. Install with: pip install platformio")
            return False

        # Check esptool
        if not self.esptool_path.exists():
            print("✗ esptool not found. Installing...")
            try:
                subprocess.run(
                    ["pio", "platform", "install", "espressif8266"], check=True
                )
                print("✓ esptool installed")
            except subprocess.CalledProcessError:
                print("✗ Failed to install esptool")
                return False

        return True

    def build_firmware(self) -> bool:
        """Build the firmware using PlatformIO"""
        print("Building firmware...")

        try:
            # Change to project directory
            os.chdir(self.project_root)

            # Clean previous builds
            subprocess.run(["pio", "run", "--target", "clean"], check=True)

            # Build firmware
            result = subprocess.run(
                ["pio", "run"], check=True, capture_output=True, text=True
            )

            print("✓ Firmware built successfully")
            return True

        except subprocess.CalledProcessError as e:
            print(f"✗ Build failed: {e}")
            print(f"Build output: {e.stdout}")
            print(f"Build errors: {e.stderr}")
            return False

    def find_serial_port(self) -> Optional[str]:
        """Find available serial ports"""
        import serial.tools.list_ports

        ports = serial.tools.list_ports.comports()
        available_ports = []

        for port in ports:
            if "USB" in port.description or "Serial" in port.description:
                available_ports.append(port.device)

        if not available_ports:
            print("✗ No suitable serial ports found")
            return None

        if len(available_ports) == 1:
            return available_ports[0]

        # Multiple ports found, let user choose
        print("Available serial ports:")
        for i, port in enumerate(available_ports):
            print(f"  {i+1}. {port}")

        try:
            choice = int(input("Select port (1-{}): ".format(len(available_ports))))
            if 1 <= choice <= len(available_ports):
                return available_ports[choice - 1]
        except (ValueError, KeyboardInterrupt):
            pass

        return None

    def upload_firmware(self, port: str) -> bool:
        """Upload firmware to ESP8266"""
        print(f"Uploading firmware to {port}...")

        try:
            # Change to project directory
            os.chdir(self.project_root)

            # Upload using PlatformIO
            result = subprocess.run(
                ["pio", "run", "--target", "upload", "--upload-port", port],
                check=True,
                capture_output=True,
                text=True,
            )

            print("✓ Firmware uploaded successfully")
            return True

        except subprocess.CalledProcessError as e:
            print(f"✗ Upload failed: {e}")
            print(f"Upload output: {e.stdout}")
            print(f"Upload errors: {e.stderr}")
            return False

    def monitor_serial(self, port: str, duration: int = 30) -> bool:
        """Monitor serial output from ESP8266"""
        print(f"Monitoring serial output from {port} for {duration} seconds...")

        try:
            # Change to project directory
            os.chdir(self.project_root)

            # Start serial monitor
            process = subprocess.Popen(["pio", "device", "monitor", "--port", port])

            # Monitor for specified duration
            time.sleep(duration)

            # Stop monitoring
            process.terminate()
            process.wait()

            print("✓ Serial monitoring completed")
            return True

        except subprocess.CalledProcessError as e:
            print(f"✗ Serial monitoring failed: {e}")
            return False

    def configure_device(self, port: str) -> bool:
        """Configure device settings"""
        print("Configuring device...")

        try:
            # Load configuration
            config_file = self.config_dir / "device_config.json"
            with open(config_file, "r") as f:
                config = json.load(f)

            # Send configuration via serial
            import serial

            with serial.Serial(port, 115200, timeout=5) as ser:
                # Wait for device to be ready
                time.sleep(2)

                # Send configuration command
                config_cmd = f"CONFIG:{json.dumps(config)}\n"
                ser.write(config_cmd.encode())

                # Wait for response
                response = ser.readline().decode().strip()
                if "OK" in response:
                    print("✓ Device configured successfully")
                    return True
                else:
                    print(f"✗ Device configuration failed: {response}")
                    return False

        except Exception as e:
            print(f"✗ Configuration failed: {e}")
            return False

    def flash(self, port: Optional[str] = None, monitor: bool = True) -> bool:
        """Complete flash process"""
        print("Starting ESP8266 flash process...")

        # Check dependencies
        if not self.check_dependencies():
            return False

        # Build firmware
        if not self.build_firmware():
            return False

        # Find serial port
        if not port:
            port = self.find_serial_port()
            if not port:
                return False

        # Upload firmware
        if not self.upload_firmware(port):
            return False

        # Configure device
        if not self.configure_device(port):
            print("⚠ Device configuration failed, but firmware uploaded")

        # Monitor serial output
        if monitor:
            if not self.monitor_serial(port):
                print("⚠ Serial monitoring failed")

        print("\n🎉 ESP8266 flash completed successfully!")
        return True


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(description="Flash ESP8266 LI-FI firmware")
    parser.add_argument("--port", help="Serial port (auto-detect if not specified)")
    parser.add_argument(
        "--no-monitor", action="store_true", help="Skip serial monitoring"
    )
    parser.add_argument(
        "--monitor-duration",
        type=int,
        default=30,
        help="Serial monitor duration (seconds)",
    )

    args = parser.parse_args()

    flasher = ESP8266Flasher()
    success = flasher.flash(port=args.port, monitor=not args.no_monitor)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
