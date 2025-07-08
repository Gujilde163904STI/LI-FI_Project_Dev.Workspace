# 🚀 LI-FI Firmware Deployment Guide

## 📋 Overview

This guide covers the complete deployment of the LI-FI (Light Fidelity) communication system firmware for Raspberry Pi 3, Raspberry Pi 4, and ESP8266 NodeMCU devices.

## 🏗️ Build Structure

```
LIFI_FIRMWARE_BUILD/
├── RPI3/                  # Raspberry Pi 3 firmware (Python)
│   ├── lifi_rpi3_main.py  # Main RPI3 firmware
│   └── README.md          # RPI3 deployment guide
├── RPI4/                  # Raspberry Pi 4 firmware (Python)
│   ├── lifi_rpi4_main.py  # Main RPI4 firmware
│   └── README.md          # RPI4 deployment guide
├── ESP8266/               # ESP8266 NodeMCU firmware (Arduino/PlatformIO)
│   ├── src/main.cpp       # Main ESP8266 firmware
│   ├── platformio.ini     # PlatformIO configuration
│   └── README.md          # ESP8266 deployment guide
├── BUILD-REFERENCE/       # Hardware schematics and wiring diagrams
├── SCRIPTS/               # Deployment and flash scripts
│   ├── flash_rpi3.sh      # RPI3 flash script
│   ├── flash_rpi4.sh      # RPI4 flash script
│   ├── flash_esp.sh       # ESP8266 flash script
│   └── validate.sh        # Build validation script
├── DOCS/                  # Documentation and guides
├── OTHER/                 # Additional tools and resources
└── Makefile               # Central build orchestrator
```

## 🔧 Prerequisites

### System Requirements
- **Development Machine**: macOS, Linux, or Windows
- **Python**: 3.7+ (for RPI3/RPI4 firmware)
- **PlatformIO**: Latest version (for ESP8266 firmware)
- **Arduino CLI**: Optional (alternative ESP8266 flashing)

### Hardware Requirements
- **Raspberry Pi 3 Model B/B+**: For RPI3 firmware
- **Raspberry Pi 4 Model B**: For RPI4 firmware
- **ESP8266 NodeMCU**: For ESP8266 firmware
- **Photodiodes**: SFH203 or equivalent for light detection
- **LEDs**: High-brightness LEDs for light transmission
- **Breadboard & Jumper Wires**: For prototyping

## 🚀 Quick Start

### 1. Validate Build
```bash
cd LIFI_FIRMWARE_BUILD/
bash SCRIPTS/validate.sh
```

### 2. Flash RPI3 Firmware
```bash
# Copy firmware to RPI3
scp -r RPI3/ pi@192.168.1.100:/home/pi/lifi_firmware/

# SSH into RPI3 and run
ssh pi@192.168.1.100
cd lifi_firmware/
python3 lifi_rpi3_main.py
```

### 3. Flash RPI4 Firmware
```bash
# Copy firmware to RPI4
scp -r RPI4/ pi@192.168.1.101:/home/pi/lifi_firmware/

# SSH into RPI4 and run
ssh pi@192.168.1.101
cd lifi_firmware/
python3 lifi_rpi4_main.py
```

### 4. Flash ESP8266 Firmware
```bash
# Connect ESP8266 via USB
cd ESP8266/
pio run --target upload

# Monitor serial output
pio device monitor
```

## 🔌 Hardware Wiring

### RPI3/RPI4 Photodiode Wiring
```
Photodiode OUT → GPIO17 (Physical Pin 11)
GND            → GND
VCC            → 3.3V
```

### RPI4 Additional TX Pin
```
LED TX         → GPIO18 (Physical Pin 12)
GND            → GND
VCC            → 3.3V via current-limiting resistor
```

### ESP8266 NodeMCU Wiring
```
TX Photodiode → D1 (GPIO5)
RX Photodiode → D2 (GPIO4)
GND           → GND
VCC           → 3.3V
```

## 📡 Network Configuration

### RPI3 Network Settings
- **Port**: 8080
- **Protocol**: TCP/IP
- **Max Connections**: 5
- **Sample Rate**: 1000 Hz

### RPI4 Network Settings
- **Port**: 8081
- **Protocol**: TCP/IP with multithreading
- **Max Connections**: 10
- **Sample Rate**: 2000 Hz

### ESP8266 Network Settings
- **WiFi SSID**: LI-FI_Network
- **WiFi Password**: lifi123456
- **Web Server**: Port 80
- **WebSocket**: Port 81

## 🧪 Testing & Validation

### RPI3 Testing
```bash
# Test photodiode response
python3 -c "
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.IN)
print('Photodiode state:', GPIO.input(17))
"

# Test network connectivity
netstat -tlnp | grep 8080
```

### RPI4 Testing
```bash
# Test multithreaded performance
python3 -c "
import threading
import time
def test_thread():
    time.sleep(1)
    print('Thread working')
threading.Thread(target=test_thread).start()
"

# Monitor system logs
tail -f /var/log/lifi_rpi4.log
```

### ESP8266 Testing
```bash
# Check WiFi connection
pio device monitor
# Look for: "WiFi connected! IP: 192.168.x.x"

# Test web interface
# Open browser to: http://192.168.x.x
```

## 🔧 Troubleshooting

### Common Issues

#### RPI3/RPI4 Issues
- **Permission Denied**: Run with `sudo python3`
- **GPIO Error**: Ensure RPi.GPIO is installed
- **Network Error**: Check firewall settings

#### ESP8266 Issues
- **Upload Failed**: Check USB connection and drivers
- **WiFi Connection Failed**: Verify SSID/password
- **Compilation Error**: Update PlatformIO

### Debug Commands
```bash
# Check system status
systemctl status lifi_rpi3
systemctl status lifi_rpi4

# Monitor logs
tail -f /var/log/lifi_*.log

# Check network
netstat -tlnp | grep 808

# Test GPIO
gpio readall
```

## 📊 Performance Metrics

### Expected Performance
- **RPI3**: 1 Mbps data rate, 5 concurrent connections
- **RPI4**: 2 Mbps data rate, 10 concurrent connections
- **ESP8266**: 500 Kbps data rate, web interface

### Optimization Tips
- Use shielded photodiode housing
- Minimize ambient light interference
- Optimize LED brightness and focus
- Use high-quality power supplies

## 🔒 Security Considerations

### Network Security
- Change default WiFi passwords
- Use WPA2/WPA3 encryption
- Implement firewall rules
- Regular security updates

### Physical Security
- Secure device mounting
- Protect against environmental damage
- Implement access controls
- Regular maintenance schedules

## 📈 Scaling & Deployment

### Production Deployment
1. **Hardware Preparation**: Mount devices securely
2. **Network Setup**: Configure static IPs
3. **Service Installation**: Install systemd services
4. **Monitoring Setup**: Configure log rotation
5. **Backup Strategy**: Implement firmware backups

### Multi-Device Networks
- Configure device discovery
- Implement load balancing
- Set up failover mechanisms
- Monitor network health

## 📞 Support & Maintenance

### Regular Maintenance
- **Weekly**: Check system logs
- **Monthly**: Update firmware
- **Quarterly**: Hardware inspection
- **Annually**: Full system audit

### Emergency Procedures
1. **System Failure**: Restart services
2. **Hardware Failure**: Replace components
3. **Network Issues**: Check connectivity
4. **Data Loss**: Restore from backups

## 📚 Additional Resources

### Documentation
- `DOCS/` - Complete documentation
- `BUILD-REFERENCE/` - Hardware schematics
- `OTHER/` - Tools and utilities

### Community Support
- GitHub Issues: Report bugs and feature requests
- Documentation Wiki: Extended guides
- Forum: Community discussions

## ⚡ Automated Deployment Scripts

To streamline deployment, use the provided automation scripts in `DEPLOYMENT+CORE=SCRIPTS/`:

### Deploying to Raspberry Pi (RPI3/RPI4)

Use `deploy_pi.sh` to automatically copy firmware and dependencies to your Raspberry Pi. This script supports both RPI3 and RPI4, and can be adapted for different hostnames/IPs.

**Usage:**
```sh
bash DEPLOYMENT+CORE=SCRIPTS/deploy_pi.sh [pi_user] [pi_host] [device_type]
```
- `pi_user`: (optional) Username for SSH (default: `pi`)
- `pi_host`: (optional) Hostname or IP of your Pi (default: `raspberrypi.local`)
- `device_type`: (optional) `RPI3` or `RPI4` (default: `RPI3`)

**Example:**
```sh
bash DEPLOYMENT+CORE=SCRIPTS/deploy_pi.sh pi 192.168.1.42 RPI4
```

This will:
- Create necessary directories on the Pi
- Copy the appropriate firmware and config files
- Install Python requirements

> **Note:** By default, the script copies from `../tx/tx*pi.py` and `../rx/rx*pi.py`. Update the script to use `LIFI*FIRMWARE*BUILD/RPI3/` or `LIFI*FIRMWARE*BUILD/RPI4/` as needed for your project structure.

### Flashing ESP8266 Firmware

Use `pio_flash.sh` to build and upload firmware to the ESP8266 using PlatformIO.

**Usage:**
```sh
bash DEPLOYMENT+CORE=SCRIPTS/pio_flash.sh
```

This will:
- Change to the `ESP8266.CORE/` directory
- Build the firmware with PlatformIO
- Upload it to the connected ESP8266 device

> **Note:** Ensure your ESP8266 is connected and drivers are installed. The script uses `ESP8266.CORE/` as the source; update if your firmware is in a different directory.

## 🛠️ Customizing Scripts for Your Workflow

- You can enhance the scripts to accept parameters for device type, user, and host for more flexible automation.
- Update the source/destination paths in the scripts to match your actual firmware locations (e.g., `LIFI*FIRMWARE*BUILD/RPI3/`, `LIFI*FIRMWARE*BUILD/RPI4/`, `LIFI*FIRMWARE*BUILD/ESP8266/`).

---

**🎉 Congratulations!** Your LI-FI communication system is now ready for deployment.

For additional support, refer to the individual README files in each firmware directory or contact the development team.
