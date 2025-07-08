#!/usr/bin/env python3
"""
LI-FI Main Server Controller - Raspberry Pi 3
Acts as the primary server/controller for the LI-FI communication system.
"""

import json
import logging
import time
import threading
from pathlib import Path
from typing import Dict, Any, Optional
import socket
import struct

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class LIFIController:
    """Main LI-FI controller for Raspberry Pi 3"""

    def __init__(self, config_path: str = "config/device_config.json"):
        self.config_path = Path(config_path)
        self.config = self.load_config()
        self.running = False
        self.connected_devices = {}
        self.light_transmitter = None
        self.data_receiver = None

    def load_config(self) -> Dict[str, Any]:
        """Load device configuration"""
        try:
            with open(self.config_path, "r") as f:
                config = json.load(f)
            logger.info(f"Loaded configuration from {self.config_path}")
            return config
        except FileNotFoundError:
            logger.warning(f"Config file not found: {self.config_path}")
            return self.get_default_config()
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON in config: {e}")
            return self.get_default_config()

    def get_default_config(self) -> Dict[str, Any]:
        """Return default configuration"""
        return {
            "device_id": "RPI3_MAIN_CONTROLLER",
            "role": "server",
            "wifi": {"ssid": "LI-FI_Network", "password": "lifi_secure_2024"},
            "light_communication": {
                "frequency": 1000,  # Hz
                "brightness": 50,  # Percentage
                "protocol": "binary",
            },
            "network": {"port": 8080, "max_connections": 10},
            "logging": {"level": "INFO", "file": "logs/lifi_controller.log"},
        }

    def initialize_hardware(self):
        """Initialize GPIO and hardware components"""
        try:
            import RPi.GPIO as GPIO

            GPIO.setmode(GPIO.BCM)

            # Configure LED for light transmission
            self.led_pin = self.config.get("led_pin", 18)
            GPIO.setup(self.led_pin, GPIO.OUT)
            self.led_pwm = GPIO.PWM(
                self.led_pin, self.config["light_communication"]["frequency"]
            )
            self.led_pwm.start(0)

            # Configure photodiode for light reception
            self.photodiode_pin = self.config.get("photodiode_pin", 17)
            GPIO.setup(self.photodiode_pin, GPIO.IN)

            logger.info("Hardware initialized successfully")

        except ImportError:
            logger.warning("RPi.GPIO not available - running in simulation mode")
            self.simulation_mode = True
        except Exception as e:
            logger.error(f"Hardware initialization failed: {e}")
            self.simulation_mode = True

    def start_light_transmission(self, data: bytes):
        """Transmit data via light signals"""
        try:
            if hasattr(self, "simulation_mode") and self.simulation_mode:
                logger.info(f"SIMULATION: Transmitting data via light: {data.hex()}")
                return

            # Convert data to binary and transmit via LED
            for byte in data:
                for bit in range(8):
                    bit_value = (byte >> (7 - bit)) & 1
                    if bit_value:
                        self.led_pwm.ChangeDutyCycle(
                            self.config["light_communication"]["brightness"]
                        )
                    else:
                        self.led_pwm.ChangeDutyCycle(0)
                    time.sleep(0.001)  # 1ms per bit

            logger.info(f"Transmitted {len(data)} bytes via light")

        except Exception as e:
            logger.error(f"Light transmission failed: {e}")

    def receive_light_data(self) -> Optional[bytes]:
        """Receive data from light signals"""
        try:
            if hasattr(self, "simulation_mode") and self.simulation_mode:
                logger.info("SIMULATION: Receiving light data")
                return b"simulated_data"

            # Read photodiode and decode binary data
            received_data = bytearray()
            # Implementation would read GPIO and decode binary
            # For now, return simulated data
            return b"received_data"

        except Exception as e:
            logger.error(f"Light reception failed: {e}")
            return None

    def start_network_server(self):
        """Start network server for device communication"""
        try:
            self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server_socket.bind(("0.0.0.0", self.config["network"]["port"]))
            self.server_socket.listen(self.config["network"]["max_connections"])

            logger.info(
                f"Network server started on port {self.config['network']['port']}"
            )

            # Start server in separate thread
            server_thread = threading.Thread(target=self._run_server, daemon=True)
            server_thread.start()

        except Exception as e:
            logger.error(f"Network server failed to start: {e}")

    def _run_server(self):
        """Run the network server loop"""
        while self.running:
            try:
                client_socket, address = self.server_socket.accept()
                logger.info(f"New connection from {address}")

                # Handle client in separate thread
                client_thread = threading.Thread(
                    target=self._handle_client,
                    args=(client_socket, address),
                    daemon=True,
                )
                client_thread.start()

            except Exception as e:
                logger.error(f"Server error: {e}")

    def _handle_client(self, client_socket, address):
        """Handle individual client connections"""
        try:
            while self.running:
                data = client_socket.recv(1024)
                if not data:
                    break

                # Process received data
                self.process_incoming_data(data, address)

        except Exception as e:
            logger.error(f"Client handling error: {e}")
        finally:
            client_socket.close()
            logger.info(f"Connection closed: {address}")

    def process_incoming_data(self, data: bytes, source: tuple):
        """Process incoming data from network clients"""
        try:
            # Parse and process the data
            message = data.decode("utf-8")
            logger.info(f"Received from {source}: {message}")

            # Example: forward data via light transmission
            self.start_light_transmission(data)

        except Exception as e:
            logger.error(f"Data processing error: {e}")

    def start(self):
        """Start the LI-FI controller"""
        logger.info("Starting LI-FI Controller (RPI3)")

        self.running = True

        # Initialize hardware
        self.initialize_hardware()

        # Start network server
        self.start_network_server()

        # Main control loop
        try:
            while self.running:
                # Check for light signals
                light_data = self.receive_light_data()
                if light_data:
                    self.process_light_data(light_data)

                time.sleep(0.1)  # 100ms loop

        except KeyboardInterrupt:
            logger.info("Shutdown requested")
        except Exception as e:
            logger.error(f"Main loop error: {e}")
        finally:
            self.stop()

    def process_light_data(self, data: bytes):
        """Process data received via light signals"""
        try:
            logger.info(f"Processing light data: {data.hex()}")
            # Implement light data processing logic
            # This could involve decoding, routing, or responding

        except Exception as e:
            logger.error(f"Light data processing error: {e}")

    def stop(self):
        """Stop the controller and cleanup"""
        logger.info("Stopping LI-FI Controller")
        self.running = False

        # Cleanup hardware
        if hasattr(self, "led_pwm"):
            self.led_pwm.stop()

        if hasattr(self, "server_socket"):
            self.server_socket.close()

        logger.info("Controller stopped")


def main():
    """Main entry point"""
    controller = LIFIController()
    controller.start()


if __name__ == "__main__":
    main()
