# WayVNC Integration Guide for LI-FI Project

## Overview

This guide provides comprehensive instructions for integrating WayVNC into the LI-FI project development workflow. WayVNC is a modern VNC server for Wayland compositors that provides secure, high-performance remote access to Raspberry Pi devices.

## Architecture

```
┌─────────────────┐    SSH Tunnel    ┌─────────────────┐
│   Development   │ ────────────────► │   Raspberry Pi  │
│   Machine       │                  │   (Headless)     │
│                 │                  │                 │
│ • Cursor/VSCode │                  │ • WayVNC Server │
│ • VNC Client    │                  │ • Wayland       │
│ • SSH Client    │                  │ • LI-FI Code    │
└─────────────────┘                  └─────────────────┘
```

## Prerequisites

### Development Machine (Windows/macOS)

- SSH client
- VNC client (RealVNC Viewer, Vinagre, Remmina)
- Cursor or VSCode for remote development

### Raspberry Pi (Target Device)

- Raspberry Pi 3 Model B or 4 Model B
- Raspberry Pi OS Lite (Debian-based)
- Wayland compositor (Weston, Sway, or wlroots-based)
- Network connectivity

## Installation and Setup

### 1. WayVNC Installation

```bash
# On Raspberry Pi
./tools/rpi/wayvnc_setup.sh
```

This script will:

- Install build dependencies
- Clone WayVNC repository
- Build WayVNC from source
- Configure basic settings

### 2. Service Configuration

```bash
# Enable WayVNC service
sudo ./tools/rpi/enable_wayvnc.sh
```

This script will:

- Create systemd service
- Configure authentication
- Set up firewall rules
- Create connection scripts

### 3. Security Setup (Optional)

```bash
# Generate TLS certificates
./tools/security/generate_tls.sh

# Generate RSA-AES keys
./tools/security/generate_rsa.sh
```

## Connection Methods

### Method 1: SSH Tunnel (Recommended)

```bash
# From development machine
./tools/remote/wayvnc_tunnel.sh raspberrypi.local
```

This creates a secure SSH tunnel and forwards VNC traffic.

### Method 2: Direct Connection

```bash
# Connect directly (less secure)
vnc://raspberrypi.local:5900
```

### Method 3: VNC Client Script

```bash
# Use provided connection script
./tools/rpi/connect_vnc.sh raspberrypi.local
```

## Development Workflow

### 1. Remote Development Setup

```bash
# SSH into Raspberry Pi
ssh pi@raspberrypi.local

# Start development session
cd ~/lifi-project
```

### 2. GUI Debugging

```bash
# Start VNC tunnel
./tools/remote/wayvnc_tunnel.sh

# Launch VNC client
# Connect to localhost:5900
```

### 3. File Synchronization

```bash
# Sync project files
rsync -avz ./ pi@raspberrypi.local:~/lifi-project/

# Or use automated deployment
./tools/rpi/deploy_to_pi.sh
```

## Configuration Files

### WayVNC Configuration (`~/.config/wayvnc/config`)

```ini
# Network settings
address=0.0.0.0
port=5900

# Authentication
enable_auth=true
username=pi
password_file=/home/pi/.config/wayvnc/password

# Performance settings
max_fps=30
quality=80
compression_level=6

# Security settings
enable_tls=false
enable_rsa_encryption=false

# Logging
log_level=info
log_file=/home/pi/.config/wayvnc/wayvnc.log

# Display settings
output_name=wayland-0
enable_cursor=true
enable_clipboard=true

# Advanced settings
max_connections=5
idle_timeout=300
```

### Systemd Service (`/etc/systemd/system/wayvnc.service`)

```ini
[Unit]
Description=WayVNC Server
After=multi-user.target
Wants=network-online.target
After=network-online.target
Requires=graphical-session.target

[Service]
Type=simple
User=pi
Group=pi
WorkingDirectory=/home/pi/wayvnc
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=WAYLAND_DISPLAY=wayland-0
Environment=DISPLAY=:0
ExecStart=/home/pi/wayvnc/build/wayvnc --config=/home/pi/.config/wayvnc/config
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=wayvnc

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/home/pi/.config/wayvnc /home/pi/wayvnc
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictRealtime=true
RestrictSUIDSGID=true
LockPersonality=true
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
```

## Security Features

### TLS Encryption

```bash
# Generate TLS certificates
./tools/security/generate_tls.sh

# Update configuration
echo "enable_tls=true" >> ~/.config/wayvnc/config
echo "tls_cert_file=/home/pi/.config/wayvnc/tls_cert.pem" >> ~/.config/wayvnc/config
echo "tls_key_file=/home/pi/.config/wayvnc/tls_key.pem" >> ~/.config/wayvnc/config
```

### RSA-AES Encryption

```bash
# Generate RSA keys
./tools/security/generate_rsa.sh

# Update configuration
echo "enable_rsa_encryption=true" >> ~/.config/wayvnc/config
echo "rsa_key_file=/home/pi/.config/wayvnc/rsa_key.pem" >> ~/.config/wayvnc/config
```

### SSH Tunnel Security

```bash
# Create secure tunnel with key authentication
ssh -L 5900:localhost:5900 -i ~/.ssh/id_rsa_pi pi@raspberrypi.local
```

## Troubleshooting

### Common Issues

#### 1. WayVNC Service Not Starting

```bash
# Check service status
sudo systemctl status wayvnc.service

# View logs
sudo journalctl -u wayvnc.service -f

# Check Wayland display
echo $WAYLAND_DISPLAY
```

#### 2. Wayland Compositor Issues

```bash
# Install Weston
sudo apt install weston
weston --backend=drm-backend.so

# Or install Sway
sudo apt install sway
sway
```

#### 3. Build Issues

```bash
# Reinstall dependencies
sudo apt install build-essential cmake ninja-build pkg-config
sudo apt install libwayland-dev libxkbcommon-dev

# Rebuild WayVNC
cd /home/pi/wayvnc
rm -rf build
mkdir build && cd build
meson setup --buildtype=release ..
ninja
```

#### 4. Connection Issues

```bash
# Check if port is listening
netstat -tlnp | grep :5900

# Check firewall
sudo ufw status

# Test SSH connection
ssh pi@raspberrypi.local
```

### Debugging Commands

```bash
# Check WayVNC binary
ls -la /home/pi/wayvnc/build/wayvnc

# Test WayVNC manually
/home/pi/wayvnc/build/wayvnc --help

# Check configuration
cat ~/.config/wayvnc/config

# Monitor system resources
htop
```

## Performance Optimization

### WayVNC Performance Settings

```ini
# Optimize for development
max_fps=30
quality=80
compression_level=6

# For better performance
max_fps=60
quality=90
compression_level=4
```

### Network Optimization

```bash
# Optimize SSH tunnel
ssh -L 5900:localhost:5900 -C -o CompressionLevel=9 pi@raspberrypi.local

# Use faster cipher
ssh -L 5900:localhost:5900 -c aes128-gcm@openssh.com pi@raspberrypi.local
```

## Integration with LI-FI Project

### Automated Deployment

```bash
# Deploy LI-FI code to Raspberry Pi
./tools/rpi/deploy_to_pi.sh

# Update firmware
./tools/rpi/update_firmware.sh

# Monitor system
./tools/rpi/system_monitor.sh
```

### Development Scripts

```bash
# Start development environment
./tools/rpi/start_dev_env.sh

# Run tests
./tools/rpi/run_tests.sh

# Build project
./tools/rpi/build_project.sh
```

### Monitoring and Logging

```bash
# Monitor WayVNC logs
sudo journalctl -u wayvnc.service -f

# Check system status
./tools/rpi/wayvnc_status.sh

# Monitor network
./tools/rpi/network_monitor.sh
```

## Fallback Options

### RealVNC Server

If WayVNC is not suitable:

```bash
# Install RealVNC fallback
sudo ./tools/rpi/realvnc_setup.sh

# Enable service
sudo systemctl enable vncserver-x11-serviced
sudo systemctl start vncserver-x11-serviced
```

### Documentation

See `docs/RASPBERRY_PI_VNC_FALLBACK.md` for detailed fallback information.

## Best Practices

### Security

1. Always use SSH tunnels for remote access
2. Generate and use TLS certificates
3. Implement RSA-AES encryption for sensitive data
4. Regularly update passwords and keys
5. Monitor access logs

### Performance

1. Use appropriate compression settings
2. Optimize network bandwidth
3. Monitor system resources
4. Use hardware acceleration when available

### Development

1. Use version control for configurations
2. Document custom settings
3. Test connections regularly
4. Keep backup configurations

## Support and Resources

### Documentation

- [WayVNC GitHub](https://github.com/any1/wayvnc)
- [Wayland Documentation](https://wayland.freedesktop.org/)
- [Raspberry Pi VNC Guide](https://www.raspberrypi.org/documentation/remote-access/vnc/)

### Troubleshooting

- [WayVNC Issues](https://github.com/any1/wayvnc/issues)
- [Raspberry Pi Forums](https://www.raspberrypi.org/forums/)
- [Wayland Community](https://wayland.freedesktop.org/community/)

### Project Integration

- LI-FI Project Documentation: `docs/`
- Raspberry Pi Documentation: `docs/raspberrypi-documentation/`
- VNC Fallback Guide: `docs/RASPBERRY_PI_VNC_FALLBACK.md`

## Conclusion

WayVNC provides a modern, secure, and high-performance remote access solution for LI-FI project development. When properly configured with SSH tunneling and security certificates, it enables efficient remote development and debugging on Raspberry Pi devices.

The integration scripts and documentation provided in this workspace ensure a smooth setup process and reliable operation for headless Raspberry Pi development workflows.
