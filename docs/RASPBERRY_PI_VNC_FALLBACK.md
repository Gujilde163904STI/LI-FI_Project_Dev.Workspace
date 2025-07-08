# Raspberry Pi VNC Fallback Documentation

## Overview

This document describes the fallback VNC solutions when WayVNC is not available or suitable for your Raspberry Pi setup. The primary VNC solution is WayVNC, but RealVNC Server is provided as a reliable fallback for X11 environments.

## VNC Solutions Comparison

| Feature                | WayVNC                            | RealVNC Server              |
| ---------------------- | --------------------------------- | --------------------------- |
| **Protocol**           | VNC over Wayland                  | VNC over X11                |
| **Compositor**         | Wayland (Weston, Sway, etc.)      | X11 (Raspberry Pi Desktop)  |
| **Performance**        | Excellent (hardware acceleration) | Good (software rendering)   |
| **Security**           | TLS/RSA-AES encryption            | VNC authentication          |
| **Setup Complexity**   | Medium (requires Wayland)         | Low (works with default OS) |
| **Resource Usage**     | Low                               | Medium                      |
| **Remote Development** | Excellent                         | Good                        |

## When to Use Each Solution

### WayVNC (Recommended)

- **Use when**: Running Wayland compositor (Weston, Sway, wlroots-based)
- **Best for**: Headless development, remote GUI debugging
- **Advantages**: Hardware acceleration, modern security, low latency
- **Requirements**: Wayland compositor, compatible graphics drivers

### RealVNC Server (Fallback)

- **Use when**: Running X11 desktop (Raspberry Pi Desktop)
- **Best for**: Traditional desktop access, legacy applications
- **Advantages**: Works with default OS, easy setup, stable
- **Requirements**: X11 desktop environment

## Installation and Setup

### WayVNC Setup

1. **Install WayVNC**:

   ```bash
   ./tools/rpi/wayvnc_setup.sh
   ```

2. **Enable Service**:

   ```bash
   sudo ./tools/rpi/enable_wayvnc.sh
   ```

3. **Generate Security Certificates** (Optional):
   ```bash
   ./tools/security/generate_tls.sh
   ./tools/security/generate_rsa.sh
   ```

### RealVNC Fallback Setup

1. **Install RealVNC Server**:

   ```bash
   sudo ./tools/rpi/realvnc_setup.sh
   ```

2. **Enable Service**:
   ```bash
   sudo systemctl enable vncserver-x11-serviced
   sudo systemctl start vncserver-x11-serviced
   ```

## Connection Methods

### SSH Tunnel (Recommended)

Both solutions support SSH tunneling for secure access:

```bash
# WayVNC tunnel
./tools/remote/wayvnc_tunnel.sh raspberrypi.local

# RealVNC tunnel
~/.vnc/realvnc_tunnel.sh raspberrypi.local
```

### Direct Connection

```bash
# WayVNC direct
vnc://raspberrypi.local:5900

# RealVNC direct
vnc://raspberrypi.local:5900
```

## Security Considerations

### WayVNC Security

- **TLS Encryption**: X509 certificates for transport security
- **RSA-AES**: Additional encryption layer for sensitive data
- **SSH Tunnel**: Encrypted tunnel for remote access
- **Authentication**: Username/password with optional certificate-based

### RealVNC Security

- **VNC Authentication**: Standard VNC password protection
- **SSH Tunnel**: Recommended for remote access
- **Firewall**: Port 5900 should be restricted
- **Password**: Strong password required

## Troubleshooting

### WayVNC Issues

#### Service Not Starting

```bash
# Check service status
sudo systemctl status wayvnc.service

# View logs
sudo journalctl -u wayvnc.service -f

# Check Wayland display
echo $WAYLAND_DISPLAY
```

#### Wayland Compositor Issues

```bash
# Install Weston (lightweight)
sudo apt install weston
weston --backend=drm-backend.so

# Install Sway (tiling)
sudo apt install sway
sway
```

#### Build Issues

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

### RealVNC Issues

#### Service Not Starting

```bash
# Check service status
sudo systemctl status vncserver-x11-serviced

# View logs
sudo journalctl -u vncserver-x11-serviced -f

# Reinstall RealVNC
sudo apt remove realvnc-vnc-server
sudo apt install realvnc-vnc-server
```

#### Authentication Issues

```bash
# Reset VNC password
vncpasswd

# Check password file
ls -la ~/.vnc/passwd
```

#### Port Conflicts

```bash
# Check what's using port 5900
sudo netstat -tlnp | grep :5900
sudo lsof -i :5900

# Kill conflicting process
sudo kill -9 <PID>
```

## Performance Optimization

### WayVNC Optimization

```bash
# Edit configuration
nano ~/.config/wayvnc/config

# Performance settings
max_fps=30
quality=80
compression_level=6
```

### RealVNC Optimization

```bash
# Edit configuration
nano ~/.vnc/config

# Performance settings
FrameRate=30
CompressionLevel=6
ColorDepth=24
```

## Integration with Development Workflow

### Cursor/VSCode Remote Development

1. **SSH Connection**:

   ```bash
   ssh pi@raspberrypi.local
   ```

2. **VNC for GUI Debugging**:

   ```bash
   # Start tunnel
   ./tools/remote/wayvnc_tunnel.sh

   # Launch VNC client
   ./tools/rpi/launch_vnc.sh
   ```

3. **File Synchronization**:
   ```bash
   # Sync project files
   rsync -avz ./ pi@raspberrypi.local:~/lifi-project/
   ```

### Automated Deployment

```bash
# Deploy to Raspberry Pi
./tools/rpi/deploy_to_pi.sh

# Update firmware
./tools/rpi/update_firmware.sh

# Monitor system
./tools/rpi/system_monitor.sh
```

## Monitoring and Maintenance

### Service Monitoring

```bash
# Check service status
./tools/rpi/wayvnc_status.sh
~/.vnc/realvnc_status.sh

# Monitor logs
sudo journalctl -u wayvnc.service -f
sudo journalctl -u vncserver-x11-serviced -f
```

### Security Updates

```bash
# Update WayVNC
cd /home/pi/wayvnc
git pull origin main
cd build && ninja

# Update RealVNC
sudo apt update
sudo apt upgrade realvnc-vnc-server
```

### Backup and Recovery

```bash
# Backup WayVNC config
cp -r ~/.config/wayvnc ~/backup/wayvnc_$(date +%Y%m%d)

# Backup RealVNC config
cp -r ~/.vnc ~/backup/realvnc_$(date +%Y%m%d)
```

## Advanced Configuration

### WayVNC Advanced Settings

```ini
# ~/.config/wayvnc/config
address=0.0.0.0
port=5900
enable_auth=true
username=pi
password_file=/home/pi/.config/wayvnc/password

# Security
enable_tls=true
tls_cert_file=/home/pi/.config/wayvnc/tls_cert.pem
tls_key_file=/home/pi/.config/wayvnc/tls_key.pem

# Performance
max_fps=30
quality=80
compression_level=6

# Display
output_name=wayland-0
enable_cursor=true
enable_clipboard=true

# Advanced
max_connections=5
idle_timeout=300
```

### RealVNC Advanced Settings

```ini
# ~/.vnc/config
DesktopSize=1920x1080
ColorDepth=24
SecurityTypes=VncAuth
Authentication=VncAuth
FrameRate=30
CompressionLevel=6
AllowLoopback=true
LoopbackOnly=false
Log=*:stderr:100
```

## Migration Guide

### From RealVNC to WayVNC

1. Install WayVNC: `./tools/rpi/wayvnc_setup.sh`
2. Stop RealVNC: `sudo systemctl stop vncserver-x11-serviced`
3. Start WayVNC: `sudo systemctl start wayvnc.service`
4. Test connection: `./tools/remote/wayvnc_tunnel.sh`

### From WayVNC to RealVNC

1. Install RealVNC: `sudo ./tools/rpi/realvnc_setup.sh`
2. Stop WayVNC: `sudo systemctl stop wayvnc.service`
3. Start RealVNC: `sudo systemctl start vncserver-x11-serviced`
4. Test connection: `~/.vnc/realvnc_tunnel.sh`

## Support and Resources

### Documentation

- [WayVNC Documentation](https://github.com/any1/wayvnc)
- [RealVNC Documentation](https://www.realvnc.com/en/connect/docs/)
- [Raspberry Pi VNC Guide](https://www.raspberrypi.org/documentation/remote-access/vnc/)

### Troubleshooting Resources

- [WayVNC Issues](https://github.com/any1/wayvnc/issues)
- [RealVNC Support](https://www.realvnc.com/en/support/)
- [Raspberry Pi Forums](https://www.raspberrypi.org/forums/)

### Community Support

- LI-FI Project Discord: [Link to Discord]
- Raspberry Pi Community: [Link to Community]
- VNC Development: [Link to Development]

## Conclusion

The VNC fallback system provides robust remote access capabilities for Raspberry Pi development. WayVNC offers modern, secure access for Wayland environments, while RealVNC Server provides reliable fallback for traditional X11 setups. Both solutions integrate seamlessly with the LI-FI project development workflow, enabling efficient remote development and debugging.

For optimal performance and security, use SSH tunnels for remote access and keep both solutions updated with the latest security patches.
