# LI-FI Main Server Controller - Raspberry Pi 3

## Overview
The RPI3 acts as the primary server/controller for the LI-FI communication system. It manages network connections, coordinates light-based communication, and serves as the central hub for all LI-FI devices.

## Purpose
- **Primary Role**: Main server and controller
- **Network Management**: Handles client connections and data routing
- **Light Communication**: Coordinates light signal transmission and reception
- **System Coordination**: Manages the overall LI-FI network

## Hardware Requirements
- Raspberry Pi 3 Model B/B+
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
cd firmware/RPI3
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
cd firmware/RPI3/src
python3 main.py
```

### System Service
```bash
# Install as systemd service
sudo cp lifi-controller.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable lifi-controller.service
sudo systemctl start lifi-controller.service
```

### Check Status
```bash
sudo systemctl status lifi-controller.service
```

## Configuration

### Network Settings
- **Port**: 8080 (default)
- **Max Connections**: 10
- **Timeout**: 30 seconds

### Light Communication
- **Frequency**: 1000 Hz
- **Brightness**: 50%
- **Protocol**: Binary
- **Bit Rate**: 1000 bps

### Security
- **Encryption**: AES-256
- **Key Rotation**: 1 hour
- **Max Failed Attempts**: 3

## Monitoring

### Logs
```bash
# View logs
tail -f logs/lifi_controller.log

# Check system status
python3 -c "from main import LIFIController; c = LIFIController(); print(c.get_device_status())"
```

### Performance Metrics
- CPU usage threshold: 80%
- Memory usage threshold: 85%
- Temperature threshold: 70°C

## Troubleshooting

### Common Issues

1. **GPIO Access Denied**
   ```bash
   sudo usermod -a -G gpio $USER
   # Reboot required
   ```

2. **Network Connection Failed**
   - Check WiFi credentials in config
   - Verify network connectivity
   - Check firewall settings

3. **Light Communication Issues**
   - Verify LED and photodiode connections
   - Check GPIO pin assignments
   - Test with simulation mode

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
```

## API Endpoints

The RPI3 server exposes these endpoints:

- `POST /device/register` - Device registration
- `POST /data` - Data transmission
- `GET /status` - System status
- `POST /light/transmit` - Light signal transmission

## Integration

### Client Devices
- RPI4: Secondary client controller
- ESP8266: Photodiode sensor
- Other IoT devices: Via network API

### External Systems
- Database logging
- Cloud monitoring
- Web dashboard

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

## Support

For issues and questions:
- Check logs in `logs/lifi_controller.log`
- Review configuration in `config/device_config.json`
- Test hardware connections
- Verify network connectivity

## License
This firmware is part of the LI-FI Project and is licensed under the MIT License. 