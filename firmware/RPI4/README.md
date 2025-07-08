# LI-FI Secondary Client Controller - Raspberry Pi 4

## Overview
The RPI4 acts as a secondary client/controller for the LI-FI communication system. It connects to the main RPI3 server, monitors light signals, and can transmit light-based responses.

## Purpose
- **Secondary Role**: Client controller and backup server
- **Light Monitoring**: Continuously monitors for light signals
- **Server Communication**: Maintains connection with main RPI3 server
- **Data Relay**: Forwards light data to the main server

## Hardware Requirements
- Raspberry Pi 4 Model B
- LED for light transmission (GPIO 18)
- Photodiode for light reception (GPIO 17)
- Status LED (GPIO 23)
- Button for manual control (GPIO 24)

## Software Dependencies
```bash
# Core dependencies
RPi.GPIO>=0.7.0
numpy>=1.21.0
scipy>=1.7.0
cryptography>=3.4.0
psutil>=5.8.0
requests>=2.25.0
websockets>=10.0
```

## Installation

### 1. Install Dependencies
```bash
cd firmware/RPI4
pip install -r requirements.txt
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
    "led_pin": 18,
    "photodiode_pin": 17
  }
}
```

### 3. Build and Deploy
```bash
python build.py --deploy
```

## Usage

### Manual Start
```bash
cd firmware/RPI4/src
python3 main.py
```

### System Service
```bash
# Install as systemd service
sudo cp lifi-client.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable lifi-client.service
sudo systemctl start lifi-client.service
```

### Check Status
```bash
sudo systemctl status lifi-client.service
```

## Configuration

### Server Connection
- **Host**: 192.168.1.100 (RPI3 server)
- **Port**: 8080
- **Reconnect Interval**: 5 seconds
- **Timeout**: 10 seconds

### Light Communication
- **Frequency**: 1000 Hz
- **Brightness**: 40%
- **Protocol**: Binary
- **Bit Rate**: 1000 bps

### Monitoring
- **Status Report Interval**: 30 seconds
- **Health Check Interval**: 60 seconds
- **Data Collection Interval**: 5 seconds

## Features

### Light Signal Monitoring
- Continuous photodiode monitoring
- Automatic signal detection
- Data forwarding to main server

### Server Communication
- Automatic connection to RPI3
- Reconnection on connection loss
- Status reporting and health checks

### Light Transmission
- LED-based light signal transmission
- Binary data encoding
- Configurable brightness and frequency

## Monitoring

### Logs
```bash
# View logs
tail -f logs/lifi_client.log

# Check device status
python3 -c "from main import LIFIClient; c = LIFIClient(); print(c.get_device_status())"
```

### Performance Metrics
- CPU usage threshold: 80%
- Memory usage threshold: 85%
- Temperature threshold: 70°C

## Troubleshooting

### Common Issues

1. **Server Connection Failed**
   ```bash
   # Check server availability
   ping 192.168.1.100
   
   # Test port connectivity
   telnet 192.168.1.100 8080
   ```

2. **Light Signal Issues**
   - Verify photodiode connections
   - Check GPIO pin assignments
   - Test with simulation mode

3. **WiFi Connection Problems**
   - Check WiFi credentials
   - Verify network connectivity
   - Restart network service

### Debug Mode
```bash
# Enable debug logging
sed -i 's/"level": "INFO"/"level": "DEBUG"/' config/device_config.json
```

## Development

### Adding New Features
1. Modify `src/main.py`
2. Update configuration in `config/device_config.json`
3. Test with simulation mode first
4. Deploy with `python build.py --deploy`

### Testing
```bash
# Run unit tests
python3 -m pytest tests/

# Test light communication
python3 tests/test_light_communication.py

# Test server communication
python3 tests/test_server_communication.py
```

## Network Communication

### Message Types
- `light_data_received` - Forwarded light data
- `status_response` - Device status updates
- `button_event` - Manual button presses

### Data Flow
1. Photodiode detects light signal
2. Data processed and formatted
3. Sent to RPI3 server via network
4. Server coordinates with other devices

## Integration

### With RPI3 Server
- Automatic registration on startup
- Continuous status reporting
- Light data forwarding

### With ESP8266 Sensor
- Receives light signals from ESP8266
- Forwards data to main server
- Coordinates light-based communication

## Security Considerations

1. **Network Security**
   - Use WPA2/WPA3 WiFi
   - Change default passwords
   - Enable firewall

2. **Data Protection**
   - Encrypt sensitive data
   - Implement access controls
   - Regular security updates

3. **Physical Security**
   - Secure device location
   - Protect against tampering
   - Backup configurations

## Performance Optimization

### Light Monitoring
- Optimized sampling rate
- Efficient signal processing
- Minimal latency

### Network Communication
- Connection pooling
- Automatic reconnection
- Efficient data serialization

### Resource Management
- Memory-efficient data structures
- CPU usage optimization
- Power management

## Support

For issues and questions:
- Check logs in `logs/lifi_client.log`
- Review configuration in `config/device_config.json`
- Test hardware connections
- Verify network connectivity
- Check server availability

## License
This firmware is part of the LI-FI Project and is licensed under the MIT License. 