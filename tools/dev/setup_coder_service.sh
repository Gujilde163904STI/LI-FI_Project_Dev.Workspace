#!/bin/bash

# Coder Systemd Service Setup for LI-FI Project
# Creates and configures systemd service for automatic Coder startup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVICE_NAME="coder.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
CODER_CONFIG_DIR="$HOME/.config/coder"
CODER_DATA_DIR="$HOME/.local/share/coder"
CODER_BIN_DIR="$HOME/.local/bin"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check if Coder is installed
check_coder_installation() {
    log "Checking Coder installation..."
    
    if ! command -v coder &> /dev/null; then
        error "Coder is not installed. Please run: ./tools/dev/coder_install.sh"
        exit 1
    fi
    
    local version=$(coder version 2>/dev/null | head -1 || echo "unknown")
    log "Coder version: $version"
}

# Check if systemd is available
check_systemd() {
    log "Checking systemd availability..."
    
    if ! command -v systemctl &> /dev/null; then
        error "Systemd is not available on this system"
        exit 1
    fi
    
    if ! systemctl --version &> /dev/null; then
        error "Systemd is not running"
        exit 1
    fi
    
    log "Systemd is available"
}

# Create systemd service file
create_service_file() {
    log "Creating systemd service file..."
    
    # Get user and group
    local user="$SUDO_USER"
    if [ -z "$user" ]; then
        user="$USER"
    fi
    
    local group="$user"
    
    # Create service file
    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Coder Development Server
Documentation=https://coder.com/docs
After=network.target
Wants=network-online.target
After=network-online.target
Requires=network-online.target

[Service]
Type=simple
User=$user
Group=$group
WorkingDirectory=/home/$user
Environment=PATH=/home/$user/.local/bin:/usr/local/bin:/usr/bin:/bin
Environment=CODER_CONFIG_DIR=/home/$user/.config/coder
Environment=CODER_DATA_DIR=/home/$user/.local/share/coder
ExecStart=/home/$user/.local/bin/coder server --config /home/$user/.config/coder/config.yaml
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=coder

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/home/$user/.config/coder /home/$user/.local/share/coder
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictRealtime=true
RestrictSUIDSGID=true
LockPersonality=true
MemoryDenyWriteExecute=true

# Resource limits
LimitNOFILE=65536
LimitNPROC=4096

# Process management
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF
    
    log "Service file created: $SERVICE_FILE"
}

# Set proper permissions
set_permissions() {
    log "Setting service file permissions..."
    
    chmod 644 "$SERVICE_FILE"
    chown root:root "$SERVICE_FILE"
    
    log "Permissions set"
}

# Reload systemd
reload_systemd() {
    log "Reloading systemd daemon..."
    
    systemctl daemon-reload
    
    log "Systemd daemon reloaded"
}

# Enable service
enable_service() {
    log "Enabling Coder service..."
    
    systemctl enable "$SERVICE_NAME"
    
    if systemctl is-enabled --quiet "$SERVICE_NAME"; then
        log "Service enabled successfully"
    else
        error "Failed to enable service"
        return 1
    fi
}

# Start service
start_service() {
    log "Starting Coder service..."
    
    systemctl start "$SERVICE_NAME"
    
    # Wait a moment for service to start
    sleep 3
    
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        log "Service started successfully"
    else
        error "Failed to start service"
        systemctl status "$SERVICE_NAME"
        return 1
    fi
}

# Test service
test_service() {
    log "Testing Coder service..."
    
    # Check service status
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        log "✓ Service is running"
    else
        error "✗ Service is not running"
        return 1
    fi
    
    # Check if port is listening
    if netstat -tln 2>/dev/null | grep -q ":8080 "; then
        log "✓ Port 8080 is listening"
    else
        warning "✗ Port 8080 is not listening"
    fi
    
    # Show service status
    echo ""
    echo "Service Status:"
    echo "==============="
    systemctl status "$SERVICE_NAME" --no-pager -l
    echo ""
}

# Create management script
create_management_script() {
    log "Creating service management script..."
    
    cat > "$CODER_BIN_DIR/manage_coder_service.sh" << 'EOF'
#!/bin/bash
# Coder Service Management Script

SERVICE_NAME="coder.service"

case "$1" in
    "start")
        echo "Starting Coder service..."
        sudo systemctl start "$SERVICE_NAME"
        ;;
    "stop")
        echo "Stopping Coder service..."
        sudo systemctl stop "$SERVICE_NAME"
        ;;
    "restart")
        echo "Restarting Coder service..."
        sudo systemctl restart "$SERVICE_NAME"
        ;;
    "status")
        echo "Coder service status:"
        sudo systemctl status "$SERVICE_NAME"
        ;;
    "logs")
        echo "Coder service logs:"
        sudo journalctl -u "$SERVICE_NAME" -f
        ;;
    "enable")
        echo "Enabling Coder service..."
        sudo systemctl enable "$SERVICE_NAME"
        ;;
    "disable")
        echo "Disabling Coder service..."
        sudo systemctl disable "$SERVICE_NAME"
        ;;
    "reload")
        echo "Reloading Coder service..."
        sudo systemctl daemon-reload
        sudo systemctl restart "$SERVICE_NAME"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|enable|disable|reload}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$CODER_BIN_DIR/manage_coder_service.sh"
    
    log "Management script created: $CODER_BIN_DIR/manage_coder_service.sh"
}

# Create monitoring script
create_monitoring_script() {
    log "Creating monitoring script..."
    
    cat > "$CODER_BIN_DIR/monitor_coder.sh" << 'EOF'
#!/bin/bash
# Coder Service Monitoring Script

SERVICE_NAME="coder.service"

echo "Coder Service Monitor"
echo "===================="
echo ""

# Service status
echo "Service Status:"
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "✓ Coder service is running"
else
    echo "✗ Coder service is not running"
fi

# Port status
echo ""
echo "Port Status:"
if netstat -tln 2>/dev/null | grep -q ":8080 "; then
    echo "✓ Port 8080 is listening"
else
    echo "✗ Port 8080 is not listening"
fi

# Configuration
echo ""
echo "Configuration:"
CONFIG_FILE="$HOME/.config/coder/config.yaml"
if [ -f "$CONFIG_FILE" ]; then
    echo "✓ Configuration file exists"
    echo "  Location: $CONFIG_FILE"
else
    echo "✗ Configuration file not found"
fi

# Logs
echo ""
echo "Recent Logs:"
journalctl -u "$SERVICE_NAME" --no-pager -n 10

# Resource usage
echo ""
echo "Resource Usage:"
ps aux | grep coder | grep -v grep || echo "No coder processes found"

# Network connections
echo ""
echo "Network Connections:"
netstat -tlnp 2>/dev/null | grep :8080 || echo "No connections on port 8080"
EOF
    
    chmod +x "$CODER_BIN_DIR/monitor_coder.sh"
    
    log "Monitoring script created: $CODER_BIN_DIR/monitor_coder.sh"
}

# Create firewall rules
setup_firewall() {
    log "Setting up firewall rules..."
    
    # Allow Coder port
    ufw allow 8080/tcp comment "Coder Development Server"
    
    # Allow SSH (if not already allowed)
    ufw allow ssh
    
    # Enable firewall if not enabled
    if ! ufw status | grep -q "Status: active"; then
        log "Enabling firewall..."
        ufw --force enable
    fi
    
    log "Firewall rules configured"
}

# Create documentation
create_documentation() {
    log "Creating documentation..."
    
    cat > "$CODER_CONFIG_DIR/SYSTEMD_SERVICE.md" << 'EOF'
# Coder Systemd Service Configuration

## Overview

This document describes the systemd service configuration for Coder development server.

## Service Information

- **Service Name**: coder.service
- **User**: Current user
- **Port**: 8080
- **Configuration**: ~/.config/coder/config.yaml
- **Logs**: journalctl -u coder.service

## Management Commands

### Start/Stop Service
```bash
# Start service
sudo systemctl start coder.service

# Stop service
sudo systemctl stop coder.service

# Restart service
sudo systemctl restart coder.service
```

### Enable/Disable Service
```bash
# Enable service (start at boot)
sudo systemctl enable coder.service

# Disable service
sudo systemctl disable coder.service
```

### Check Status
```bash
# Check service status
sudo systemctl status coder.service

# View logs
sudo journalctl -u coder.service -f
```

### Using Management Scripts
```bash
# Use management script
manage_coder_service.sh start
manage_coder_service.sh stop
manage_coder_service.sh status
manage_coder_service.sh logs

# Use monitoring script
monitor_coder.sh
```

## Configuration

### Service File Location
- `/etc/systemd/system/coder.service`

### Configuration File
- `~/.config/coder/config.yaml`

### Data Directory
- `~/.local/share/coder/`

## Security Features

- **Sandboxing**: Service runs with restricted permissions
- **Resource Limits**: File descriptor and process limits
- **Network Isolation**: Protected network access
- **Memory Protection**: Write-execute memory protection

## Troubleshooting

### Service Not Starting
```bash
# Check service status
sudo systemctl status coder.service

# View detailed logs
sudo journalctl -u coder.service -n 50

# Check configuration
cat ~/.config/coder/config.yaml
```

### Port Already in Use
```bash
# Check what's using port 8080
sudo netstat -tlnp | grep :8080
sudo lsof -i :8080

# Kill conflicting process
sudo kill -9 <PID>
```

### Permission Issues
```bash
# Check service file permissions
ls -la /etc/systemd/system/coder.service

# Fix permissions if needed
sudo chmod 644 /etc/systemd/system/coder.service
sudo chown root:root /etc/systemd/system/coder.service
```

### Configuration Issues
```bash
# Test configuration
coder server --config ~/.config/coder/config.yaml --dry-run

# Backup and restore configuration
cp ~/.config/coder/config.yaml ~/.config/coder/config.yaml.backup
```

## Integration with LI-FI Project

### Development Workflow
1. Service starts automatically at boot
2. Access web interface at http://localhost:8080
3. Use for remote development on Raspberry Pi
4. Monitor with management scripts

### Remote Access
- Configure firewall for remote access
- Use SSH tunnel for secure access
- Monitor access logs regularly

### Performance Monitoring
- Use monitoring script for health checks
- Monitor resource usage
- Check service logs for issues
EOF
    
    log "Documentation created: $CODER_CONFIG_DIR/SYSTEMD_SERVICE.md"
}

# Main function
main() {
    log "Setting up Coder systemd service..."
    
    check_root
    check_coder_installation
    check_systemd
    create_service_file
    set_permissions
    reload_systemd
    enable_service
    start_service
    test_service
    create_management_script
    create_monitoring_script
    setup_firewall
    create_documentation
    
    log "Coder systemd service setup completed successfully!"
    echo ""
    echo "Service Information:"
    echo "==================="
    echo "Service: $SERVICE_NAME"
    echo "Status: $(systemctl is-active $SERVICE_NAME)"
    echo "Enabled: $(systemctl is-enabled $SERVICE_NAME)"
    echo "Port: 8080"
    echo "Config: $CODER_CONFIG_DIR/config.yaml"
    echo ""
    echo "Management Commands:"
    echo "==================="
    echo "Start: sudo systemctl start $SERVICE_NAME"
    echo "Stop: sudo systemctl stop $SERVICE_NAME"
    echo "Status: sudo systemctl status $SERVICE_NAME"
    echo "Logs: sudo journalctl -u $SERVICE_NAME -f"
    echo ""
    echo "Scripts:"
    echo "========"
    echo "Management: $CODER_BIN_DIR/manage_coder_service.sh"
    echo "Monitoring: $CODER_BIN_DIR/monitor_coder.sh"
    echo ""
    echo "Documentation: $CODER_CONFIG_DIR/SYSTEMD_SERVICE.md"
    echo ""
    echo "Access URL: http://localhost:8080"
}

# Run main function
main "$@" 