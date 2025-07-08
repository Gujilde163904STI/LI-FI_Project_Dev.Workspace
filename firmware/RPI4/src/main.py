#!/usr/bin/env python3
"""
LI-FI Secondary Client Controller - Raspberry Pi 4
Acts as a secondary client/controller for the LI-FI communication system.
"""

import json
import logging
import time
import threading
import socket
import struct
from pathlib import Path
from typing import Dict, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class LIFIClient:
    """Secondary LI-FI client for Raspberry Pi 4"""

    def __init__(self, config_path: str = "config/device_config.json"):
        self.config_path = Path(config_path)
        self.config = self.load_config()
        self.running = False
        self.server_connection = None
        self.light_receiver = None
        self.light_transmitter = None

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
            "device_id": "RPI4_SECONDARY_CLIENT",
            "role": "client",
            "wifi": {"ssid": "LI-FI_Network", "password": "lifi_secure_2024"},
            "server": {"host": "192.168.1.100", "port": 8080, "reconnect_interval": 5},
            "light_communication": {
                "frequency": 1000,
                "brightness": 40,
                "protocol": "binary",
            },
            "hardware": {"led_pin": 18, "photodiode_pin": 17, "status_led_pin": 23},
            "logging": {"level": "INFO", "file": "logs/lifi_client.log"},
        }

    def initialize_hardware(self):
        """Initialize GPIO and hardware components"""
        try:
            import RPi.GPIO as GPIO

            GPIO.setmode(GPIO.BCM)

            # Configure LED for light transmission
            self.led_pin = self.config["hardware"]["led_pin"]
            GPIO.setup(self.led_pin, GPIO.OUT)
            self.led_pwm = GPIO.PWM(
                self.led_pin, self.config["light_communication"]["frequency"]
            )
            self.led_pwm.start(0)

            # Configure photodiode for light reception
            self.photodiode_pin = self.config["hardware"]["photodiode_pin"]
            GPIO.setup(self.photodiode_pin, GPIO.IN)

            # Configure status LED
            self.status_led_pin = self.config["hardware"]["status_led_pin"]
            GPIO.setup(self.status_led_pin, GPIO.OUT)

            logger.info("Hardware initialized successfully")

        except ImportError:
            logger.warning("RPi.GPIO not available - running in simulation mode")
            self.simulation_mode = True
        except Exception as e:
            logger.error(f"Hardware initialization failed: {e}")
            self.simulation_mode = True

    def connect_to_server(self) -> bool:
        """Connect to the main LI-FI server"""
        try:
            server_config = self.config["server"]

            self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_socket.settimeout(10)

            self.server_socket.connect((server_config["host"], server_config["port"]))

            # Send client identification
            client_info = {
                "device_id": self.config["device_id"],
                "role": self.config["role"],
                "capabilities": ["light_transmission", "light_reception"],
            }

            self.server_socket.send(json.dumps(client_info).encode())

            logger.info(
                f"Connected to server: {server_config['host']}:{server_config['port']}"
            )
            return True

        except Exception as e:
            logger.error(f"Failed to connect to server: {e}")
            return False

    def transmit_light_signal(self, data: bytes):
        """Transmit data via light signals"""
        try:
            if hasattr(self, "simulation_mode") and self.simulation_mode:
                logger.info(f"SIMULATION: Transmitting light signal: {data.hex()}")
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

    def receive_light_signal(self) -> Optional[bytes]:
        """Receive data from light signals"""
        try:
            if hasattr(self, "simulation_mode") and self.simulation_mode:
                logger.info("SIMULATION: Receiving light signal")
                return b"simulated_light_data"

            # Read photodiode and decode binary data
            received_data = bytearray()
            # Implementation would read GPIO and decode binary
            # For now, return simulated data
            return b"received_light_data"

        except Exception as e:
            logger.error(f"Light reception failed: {e}")
            return None

    def process_server_message(self, message: str):
        """Process messages from the server"""
        try:
            data = json.loads(message)
            logger.info(f"Received server message: {data}")

            # Handle different message types
            if data.get("type") == "light_transmit":
                payload = data.get("payload", "")
                self.transmit_light_signal(payload.encode())

            elif data.get("type") == "status_request":
                status = self.get_device_status()
                self.send_to_server({"type": "status_response", "payload": status})

        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON from server: {e}")
        except Exception as e:
            logger.error(f"Message processing error: {e}")

    def get_device_status(self) -> Dict[str, Any]:
        """Get current device status"""
        return {
            "device_id": self.config["device_id"],
            "status": "online",
            "uptime": time.time(),
            "light_transmission_active": hasattr(self, "led_pwm"),
            "light_reception_active": hasattr(self, "photodiode_pin"),
            "server_connected": self.server_socket is not None,
        }

    def send_to_server(self, data: Dict[str, Any]):
        """Send data to the server"""
        try:
            if self.server_socket:
                message = json.dumps(data)
                self.server_socket.send(message.encode())
                logger.debug(f"Sent to server: {data}")
        except Exception as e:
            logger.error(f"Failed to send to server: {e}")
            self.reconnect_to_server()

    def reconnect_to_server(self):
        """Reconnect to the server"""
        logger.info("Attempting to reconnect to server...")

        if self.server_socket:
            try:
                self.server_socket.close()
            except:
                pass

        reconnect_interval = self.config["server"]["reconnect_interval"]

        while self.running:
            if self.connect_to_server():
                break
            logger.info(
                f"Reconnection failed, retrying in {reconnect_interval} seconds..."
            )
            time.sleep(reconnect_interval)

    def start_light_monitoring(self):
        """Start monitoring for light signals"""

        def light_monitor():
            while self.running:
                light_data = self.receive_light_signal()
                if light_data:
                    # Process received light data
                    self.process_light_data(light_data)
                time.sleep(0.1)  # 100ms monitoring interval

        light_thread = threading.Thread(target=light_monitor, daemon=True)
        light_thread.start()
        logger.info("Light monitoring started")

    def process_light_data(self, data: bytes):
        """Process data received via light signals"""
        try:
            logger.info(f"Processing light data: {data.hex()}")

            # Forward to server
            self.send_to_server({"type": "light_data_received", "payload": data.hex()})

        except Exception as e:
            logger.error(f"Light data processing error: {e}")

    def start_server_communication(self):
        """Start communication with the server"""

        def server_communicator():
            while self.running:
                try:
                    if not self.server_socket:
                        self.reconnect_to_server()
                        continue

                    # Receive data from server
                    data = self.server_socket.recv(1024)
                    if not data:
                        logger.warning("Server connection lost")
                        self.reconnect_to_server()
                        continue

                    # Process server message
                    message = data.decode("utf-8")
                    self.process_server_message(message)

                except Exception as e:
                    logger.error(f"Server communication error: {e}")
                    self.reconnect_to_server()

        server_thread = threading.Thread(target=server_communicator, daemon=True)
        server_thread.start()
        logger.info("Server communication started")

    def start(self):
        """Start the LI-FI client"""
        logger.info("Starting LI-FI Client (RPI4)")

        self.running = True

        # Initialize hardware
        self.initialize_hardware()

        # Connect to server
        if not self.connect_to_server():
            logger.error("Failed to connect to server")
            return

        # Start light monitoring
        self.start_light_monitoring()

        # Start server communication
        self.start_server_communication()

        # Main control loop
        try:
            while self.running:
                # Update status LED
                if hasattr(self, "status_led_pin") and not hasattr(
                    self, "simulation_mode"
                ):
                    import RPi.GPIO as GPIO

                    GPIO.output(self.status_led_pin, GPIO.HIGH)

                time.sleep(1)  # 1 second loop

        except KeyboardInterrupt:
            logger.info("Shutdown requested")
        except Exception as e:
            logger.error(f"Main loop error: {e}")
        finally:
            self.stop()

    def stop(self):
        """Stop the client and cleanup"""
        logger.info("Stopping LI-FI Client")
        self.running = False

        # Cleanup hardware
        if hasattr(self, "led_pwm"):
            self.led_pwm.stop()

        if hasattr(self, "server_socket"):
            self.server_socket.close()

        logger.info("Client stopped")


def main():
    """Main entry point"""
    client = LIFIClient()
    client.start()


if __name__ == "__main__":
    main()
