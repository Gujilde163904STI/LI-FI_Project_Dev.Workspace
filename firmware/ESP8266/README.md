# LI-FI Photodiode Sensor - ESP8266

## Overview
The ESP8266 acts as a photodiode sensor for the LI-FI communication system. It reads light signals from photodiodes, processes the data, and transmits information to the main server via WiFi.

## Purpose
- **Sensor Role**: Photodiode light signal detection
- **Data Collection**: Continuous light signal monitoring
- **Network Communication**: WiFi-based data transmission
- **Light Response**: LED-based signal transmission

## Hardware Requirements
- ESP8266 NodeMCU or compatible board
- Photodiode sensor (connected to A0)
- LED for light transmission (GPIO 2)
- Status LED (GPIO 16)
- Button for manual control (GPIO 0)

## Software Dependencies
```bash
# PlatformIO dependencies
platform = espressif8266
framework = arduino
lib_deps = 
    bblanchon/ArduinoJson @ ^6.21.3
    ESP8266WiFi
    ESP8266HTTPClient
    WiFiClient
```

## Installation

### 1. Install PlatformIO
```bash
pip install platformio
```

### 2. Configure Device
Edit `config/device_config.json` to match your network settings:
```json
{
  "wifi": {
    "ssid": "YOUR_WIFI_SSID",
    "password": "YOUR_WIFI_PASSWORD"
  },
  "server": {
    "host": "192.168.1.100",
    "port": 8080
  },
  "hardware": {
    "photodiode_pin": "A0",
    "led_pin": 2
  }
}
```

### 3. Build and Flash
```bash
cd firmware/ESP8266
python flash.py
```

## Usage

### Manual Upload
```bash
# Build firmware
pio run

# Upload to device
pio run --target upload

# Monitor serial output
pio device monitor
```

### Automated Flash
```bash
# Complete flash process
python flash.py --port COM3  # Windows
python flash.py --port /dev/ttyUSB0  # Linux/Mac
```

## Configuration

### WiFi Settings
- **SSID**: LI-FI_Network (default)
- **Password**: lifi_secure_2024 (default)
- **Security**: WPA2

### Server Connection
- **Host**: 192.168.1.100 (RPI3 server)
- **Port**: 8080
- **Reconnect Interval**: 5 seconds

### Sensor Settings
- **Sampling Rate**: 100 Hz
- **Threshold**: 512 (ADC value)
- **Sensitivity**: 1.0
- **Calibration Offset**: 0

### Light Communication
- **Frequency**: 1000 Hz
- **Brightness**: 50%
- **Protocol**: Binary
- **Bit Rate**: 1000 bps

## Features

### Light Signal Detection
- Continuous photodiode monitoring
- Automatic threshold detection
- Real-time signal processing

### Data Transmission
- WiFi-based data transmission
- JSON-formatted messages
- Automatic reconnection

### Light Response
- LED-based signal transmission
- Binary data encoding
- Configurable patterns

### Status Monitoring
- System health reporting
- Memory usage monitoring
- WiFi signal strength

## Hardware Setup

### Pin Connections
```
ESP8266 Pin    Component
A0             Photodiode (with voltage divider)
GPIO 2         LED for light transmission
GPIO 16        Status LED
GPIO 0         Button (with pull-up)
```

### Photodiode Circuit
```
VCC (3.3V) ----[10kΩ]----+
                         |
                    [Photodiode]
                         |
GND ----------------------+
                         |
                    [To A0]
```

### LED Circuit
```
GPIO 2 ----[220Ω]----[LED]----GND
```

## Monitoring

### Serial Output
```bash
# Monitor serial output
pio device monitor

# Expected output:
# LI-FI ESP8266 Photodiode Sensor Starting...
# Loading configuration...
# Configuration loaded
# Connecting to WiFi: LI-FI_Network
# WiFi connected! IP: 192.168.1.101
# Connecting to server: 192.168.1.100:8080
# Connected to server!
# Device info sent to server
# Setup complete!
```

### Status Indicators
- **Status LED**: Blinks every second when connected
- **Serial Output**: Real-time status messages
- **Network**: Automatic reconnection on failure

## Troubleshooting

### Common Issues

1. **Upload Failed**
   ```bash
   # Check port
   pio device list
   
   # Try different upload speed
   # Edit platformio.ini: upload_speed = 115200
   ```

2. **WiFi Connection Failed**
   - Check SSID and password
   - Verify WiFi signal strength
   - Check network security settings

3. **Server Connection Failed**
   - Verify server IP address
   - Check network connectivity
   - Ensure server is running

4. **Photodiode Not Working**
   - Check wiring connections
   - Verify voltage divider circuit
   - Test with multimeter

### Debug Mode
```bash
# Enable debug output
# Edit platformio.ini: build_flags = -D DEBUG_ESP_PORT=Serial
```

## Development

### Adding New Features
1. Modify `src/main.ino`
2. Update configuration in `config/device_config.json`
3. Test with serial monitor
4. Flash with `python flash.py`

### Testing
```bash
# Run unit tests
pio test

# Test light communication
python tests/test_light_communication.py

# Test network communication
python tests/test_network_communication.py
```

## Data Format

### Light Signal Data
```json
{
  "device_id": "ESP8266_PHOTODIODE_SENSOR",
  "type": "light_signal",
  "value": 1023,
  "timestamp": 1234567890
}
```

### Status Update
```json
{
  "device_id": "ESP8266_PHOTODIODE_SENSOR",
  "type": "status_update",
  "uptime": 1234567890,
  "free_heap": 12345,
  "wifi_rssi": -45,
  "photodiode_value": 512
}
```

## Performance Optimization

### Memory Management
- Efficient JSON serialization
- Minimal string operations
- Optimized data structures

### Power Management
- WiFi power saving mode
- Efficient sleep cycles
- Optimized sensor reading

### Network Efficiency
- Connection pooling
- Automatic reconnection
- Efficient data transmission

## Security Considerations

1. **Network Security**
   - Use WPA2/WPA3 WiFi
   - Change default passwords
   - Secure server communication

2. **Data Protection**
   - Encrypt sensitive data
   - Implement access controls
   - Regular security updates

3. **Physical Security**
   - Secure device location
   - Protect against tampering
   - Backup configurations

## Integration

### With RPI3 Server
- Automatic device registration
- Continuous data transmission
- Status reporting

### With RPI4 Client
- Light signal coordination
- Data relay and forwarding
- Network communication

## Support

For issues and questions:
- Check serial output for error messages
- Review configuration in `config/device_config.json`
- Test hardware connections
- Verify network connectivity
- Check server availability

## License
This firmware is part of the LI-FI Project and is licensed under the MIT License. 