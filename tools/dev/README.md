# Development Tools

This directory contains development environment management tools for the LI-FI project.

## Coder Integration

Coder is a development environment manager that provides web-based IDE access and remote development capabilities. It serves as an alternative to VSCode Remote-SSH and VNC for lightweight development access.

### Features

- **Web-based IDE** accessible from any browser
- **Remote development** on Raspberry Pi and IoT devices
- **SSH port forwarding** and secure tunneling
- **Container-based development** environments
- **Systemd service** for automatic startup
- **CLI wrapper** for easy management

### Quick Start

#### 1. Installation

```bash
# Install Coder
./tools/dev/coder_install.sh
```

#### 2. Start Development Server

```bash
# Local development
./tools/dev/coder_wrapper.sh local

# Remote development
./tools/dev/coder_wrapper.sh remote
```

#### 3. Access Web Interface

- **Local**: http://localhost:8080
- **Remote**: http://raspberrypi.local:8080

#### 4. Setup Systemd Service (Linux)

```bash
# Setup automatic startup
sudo ./tools/dev/setup_coder_service.sh
```

### Scripts

#### `coder_install.sh`

Comprehensive installation script that:

- Detects operating system (Linux, macOS, Windows)
- Installs dependencies
- Downloads and installs Coder
- Creates configuration files
- Sets up startup scripts
- Creates systemd service (Linux)

#### `coder_wrapper.sh`

CLI wrapper providing easy access to:

- Server management (start/stop/restart)
- Workspace management (create/list/delete)
- Configuration management (show/edit/backup)
- Service management (enable/disable/status)
- Log viewing and monitoring

#### `setup_coder_service.sh`

Systemd service setup that:

- Creates secure systemd service file
- Configures resource limits and security settings
- Sets up firewall rules
- Creates management and monitoring scripts
- Generates comprehensive documentation

### Configuration

#### Local Development

```yaml
# ~/.config/coder/config.yaml
address: "localhost:8080"
access_url: "http://localhost:8080"
devurl_host: "localhost"
devurl_port: "8080"
tls_enable: false
log_level: "info"
```

#### Remote Development

```yaml
# ~/.config/coder/config.yaml
address: "0.0.0.0:8080"
access_url: "http://raspberrypi.local:8080"
devurl_host: "raspberrypi.local"
devurl_port: "8080"
tls_enable: false
log_level: "info"
```

### Integration with LI-FI Project

#### Raspberry Pi Development

1. **Install on Raspberry Pi**

   ```bash
   curl -L https://coder.com/install.sh | sh
   ```

2. **Configure for remote access**

   ```bash
   mkdir -p ~/.config/coder
   cat > ~/.config/coder/config.yaml << EOF
   address: "0.0.0.0:8080"
   access_url: "http://raspberrypi.local:8080"
   tls_enable: false
   log_level: "info"
   EOF
   ```

3. **Start server**

   ```bash
   coder server --config ~/.config/coder/config.yaml
   ```

4. **Access from development machine**

   ```bash
   # SSH tunnel for secure access
   ssh -L 8080:localhost:8080 pi@raspberrypi.local

   # Open browser to http://localhost:8080
   ```

#### ESP8266 Development

1. **Create Arduino workspace template**

   ```bash
   coder template create arduino-workspace
   ```

2. **Configure Arduino CLI**

   ```bash
   # Install Arduino CLI in workspace
   arduino-cli core install esp8266:esp8266
   ```

3. **Access serial monitor**
   ```bash
   # Forward serial port
   ssh -L 115200:localhost:115200 pi@raspberrypi.local
   ```

### Security Considerations

#### TLS/SSL Setup

```bash
# Generate certificates
./tools/security/generate_tls.sh

# Configure with TLS
cat > ~/.config/coder/config.yaml << EOF
address: "0.0.0.0:8080"
access_url: "https://raspberrypi.local:8080"
tls_enable: true
tls_cert_file: "/path/to/cert.pem"
tls_key_file: "/path/to/key.pem"
EOF
```

#### Firewall Configuration

```bash
# Allow Coder port
sudo ufw allow 8080/tcp

# Allow SSH
sudo ufw allow ssh

# Enable firewall
sudo ufw enable
```

#### Authentication

```bash
# Create admin user
coder user create admin

# Configure OAuth (if available)
# Set up LDAP integration
# Configure SSO with organization
```

### Management Commands

#### Service Management

```bash
# Start/stop service
sudo systemctl start coder.service
sudo systemctl stop coder.service

# Check status
sudo systemctl status coder.service

# View logs
sudo journalctl -u coder.service -f
```

#### Workspace Management

```bash
# List workspaces
coder workspace list

# Create workspace
coder workspace create

# Start/stop workspace
coder workspace start <workspace>
coder workspace stop <workspace>
```

#### Configuration Management

```bash
# Show configuration
./tools/dev/coder_wrapper.sh config show

# Edit configuration
./tools/dev/coder_wrapper.sh config edit

# Backup configuration
./tools/dev/coder_wrapper.sh config backup
```

### Troubleshooting

#### Common Issues

**Server Not Starting**

```bash
# Check if port is in use
sudo netstat -tlnp | grep :8080

# Kill conflicting process
sudo kill -9 <PID>

# Check configuration
coder server --config ~/.config/coder/config.yaml --dry-run
```

**Connection Issues**

```bash
# Check firewall
sudo ufw status

# Test connectivity
curl -I http://localhost:8080

# Check SSH tunnel
ssh -v -L 8080:localhost:8080 pi@raspberrypi.local
```

**Performance Issues**

```bash
# Monitor resource usage
htop

# Check disk space
df -h

# Monitor network
iftop
```

#### Log Analysis

```bash
# View Coder logs
journalctl -u coder.service -f

# Check system logs
dmesg | tail

# Monitor access logs
tail -f /var/log/nginx/access.log
```

### Documentation

- **Integration Guide**: `docs/raspberrypi-documentation/integrations/coder.md`
- **Systemd Service**: `~/.config/coder/SYSTEMD_SERVICE.md`
- **Configuration**: `~/.config/coder/README.md`

### Best Practices

#### Security

- Use HTTPS in production environments
- Enable authentication for remote access
- Configure firewall rules appropriately
- Monitor access logs regularly
- Use SSH tunneling for secure access

#### Performance

- Monitor resource usage regularly
- Use appropriate workspace sizes
- Clean up unused workspaces periodically
- Optimize disk usage with regular cleanup

#### Development

- Use templates for consistent environments
- Version control workspace configurations
- Document workspace setup procedures
- Test deployments in staging environments

#### Monitoring

- Set up alerts for service failures
- Monitor resource usage trends
- Track user activity and workspace usage
- Regular backup of configurations and data

### Integration with Existing Workflows

Coder complements the existing LI-FI project development tools:

- **Alternative to VSCode Remote-SSH**: Web-based access without VSCode installation
- **Complement to VNC**: Lightweight web IDE for development
- **Enhancement to SSH**: Integrated terminal and file management
- **Integration with WayVNC**: Use Coder for development, WayVNC for GUI debugging

This integration provides additional flexibility for development and deployment scenarios, particularly useful for:

- Remote development on Raspberry Pi devices
- ESP8266 development with web-based Arduino IDE
- Collaborative development through web interfaces
- Automated deployment and CI/CD integration

# VSIX Extension Installer

## Usage

Run the script to auto-install all `.vsix` extensions found in the following directories:

- `.vsix/`
- `extensions/`
- `tools/dev/vsix/`

```
bash tools/dev/install_vsix.sh
```

The script will:

- Detect and use the first available CLI: `code`, `cursor`, or `codium`
- Batch install all `.vsix` files found in the above directories
- Log each step and any errors
- Exit with a message if no supported CLI is found

## Troubleshooting

- Ensure at least one of `code`, `cursor`, or `codium` is installed and in your PATH
- Place your `.vsix` files in one of the supported directories
- Run with sufficient permissions if needed

# Skaffold Development Tools

## Skaffold Log Viewer

View Skaffold logs with filtering options:

```bash
# Basic usage
bash tools/dev/view_skaffold_logs.sh

# Show only errors
bash tools/dev/view_skaffold_logs.sh --errors

# Follow logs in real-time
bash tools/dev/view_skaffold_logs.sh --follow

# Show build logs only
bash tools/dev/view_skaffold_logs.sh --build

# Custom time range and lines
bash tools/dev/view_skaffold_logs.sh --time 1h --lines 100
```

## Network Readiness Checker

Check network connectivity before deployment:

```bash
# Check all targets (ESP8266, RPi3, RPi4)
bash tools/dev/check_network_ready.sh
```

The script checks:

- Network interfaces (wlan0, eth0, usb0)
- Internet connectivity
- Target device reachability (ping + port tests)

## Development Reset

Reset the entire development environment:

```bash
# Full reset (services + containers + logs)
bash tools/dev/dev_reset.sh

# Reset only services
bash tools/dev/dev_reset.sh --services

# Reset only containers
bash tools/dev/dev_reset.sh --containers

# Clear logs only
bash tools/dev/dev_reset.sh --logs

# Force reset without prompts
bash tools/dev/dev_reset.sh --force
```

## Skaffold Profiles

### Local Development

```bash
skaffold dev --profile=local-dev
```

- Uses Docker Desktop/Podman
- No remote caching
- Fast local builds

### GKE Cloud Build

```bash
skaffold dev --profile=gke-cloudbuild
```

- Uses Google Cloud Build
- Remote caching enabled
- GCR artifacts: `gcr.io/galahadd-lifi-dev/lifi/*`

### Helm Deploy

```bash
skaffold deploy --profile=helm-deploy
```

- Uses Helm charts from `helm/` directory
- Production-ready deployments

## Debug Tips

### Skaffold Issues

1. Check if Skaffold is installed: `command -v skaffold`
2. Verify service is running: `systemctl --user status skaffold.service`
3. Check GCloud auth: `gcloud auth list`
4. View logs: `bash tools/dev/view_skaffold_logs.sh --errors`

### Network Issues

1. Run network check: `bash tools/dev/check_network_ready.sh`
2. Verify target IPs in the script match your network
3. Check firewall settings for target ports

### Reset Environment

1. Full reset: `bash tools/dev/dev_reset.sh`
2. Clear logs: `bash tools/dev/dev_reset.sh --logs`
3. Restart services: `bash tools/dev/dev_reset.sh --services`

## Health Checks

### Skaffold Ready Check

```bash
bash tools/dev/check_skaffold_ready.sh
```

- Verifies Skaffold installation
- Checks service status
- Validates GCloud configuration
- Auto-prompts to fix issues

### Service Status

```bash
# Check all services
systemctl --user status coder.service wayvnc.service skaffold.service

# View service logs
bash tools/systemd/view_service_logs.sh
```

## Integration with Dev UI

All tools are available as buttons in `.cursor.mdc`:

- `show_skaffold_logs` - View Skaffold logs
- `check_network_ready` - Network readiness check
- `dev_reset` - Reset development environment
- `check_skaffold_ready` - Skaffold health check
- `restart_skaffold_loop` - Restart Skaffold with watch mode
