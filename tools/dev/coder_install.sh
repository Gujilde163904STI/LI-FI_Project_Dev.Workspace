#!/bin/bash

# Coder Installation Script for LI-FI Project
# Installs Coder development environment manager for remote development
# Supports Linux, macOS, and Windows environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CODER_VERSION="latest"
CODER_BIN_DIR="$HOME/.local/bin"
CODER_CONFIG_DIR="$HOME/.config/coder"
CODER_DATA_DIR="$HOME/.local/share/coder"

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

# Detect operating system
detect_os() {
    log "Detecting operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if command -v apt-get &> /dev/null; then
            PACKAGE_MANAGER="apt"
        elif command -v yum &> /dev/null; then
            PACKAGE_MANAGER="yum"
        elif command -v dnf &> /dev/null; then
            PACKAGE_MANAGER="dnf"
        elif command -v pacman &> /dev/null; then
            PACKAGE_MANAGER="pacman"
        else
            PACKAGE_MANAGER="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        PACKAGE_MANAGER="chocolatey"
    else
        OS="unknown"
        PACKAGE_MANAGER="unknown"
    fi
    
    log "Detected OS: $OS ($PACKAGE_MANAGER package manager)"
}

# Check if Coder is already installed
check_existing_installation() {
    log "Checking for existing Coder installation..."
    
    if command -v coder &> /dev/null; then
        local version=$(coder version 2>/dev/null | head -1 || echo "unknown")
        warning "Coder is already installed: $version"
        
        read -p "Do you want to reinstall/update Coder? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing Coder installation"
            return 0
        fi
    fi
    
    return 1
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies..."
    
    case $OS in
        "linux")
            case $PACKAGE_MANAGER in
                "apt")
                    sudo apt update
                    sudo apt install -y curl wget git
                    ;;
                "yum"|"dnf")
                    sudo $PACKAGE_MANAGER install -y curl wget git
                    ;;
                "pacman")
                    sudo pacman -S --noconfirm curl wget git
                    ;;
                *)
                    warning "Unknown package manager. Please install curl, wget, and git manually."
                    ;;
            esac
            ;;
        "macos")
            if ! command -v brew &> /dev/null; then
                log "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install curl wget git
            ;;
        "windows")
            if ! command -v choco &> /dev/null; then
                log "Installing Chocolatey..."
                echo "Please install Chocolatey manually: https://chocolatey.org/install"
                log "Then run: choco install curl wget git -y"
            else
                choco install curl wget git -y
            fi
            ;;
    esac
    
    log "Dependencies installed"
}

# Install Coder on Linux
install_coder_linux() {
    log "Installing Coder on Linux..."
    
    # Create directories
    mkdir -p "$CODER_BIN_DIR"
    mkdir -p "$CODER_CONFIG_DIR"
    mkdir -p "$CODER_DATA_DIR"
    
    # Download and install Coder
    curl -L https://coder.com/install.sh | sh
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$CODER_BIN_DIR:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    log "Coder installed on Linux"
}

# Install Coder on macOS
install_coder_macos() {
    log "Installing Coder on macOS..."
    
    # Create directories
    mkdir -p "$CODER_BIN_DIR"
    mkdir -p "$CODER_CONFIG_DIR"
    mkdir -p "$CODER_DATA_DIR"
    
    # Download and install Coder
    curl -L https://coder.com/install.sh | sh
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$CODER_BIN_DIR:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    log "Coder installed on macOS"
}

# Install Coder on Windows
install_coder_windows() {
    log "Installing Coder on Windows..."
    
    # Create directories
    mkdir -p "$HOME/coder"
    mkdir -p "$CODER_CONFIG_DIR"
    mkdir -p "$CODER_DATA_DIR"
    
    # Download latest release
    local download_url=$(curl -s https://api.github.com/repos/coder/coder/releases/latest | grep "browser_download_url.*windows.*amd64" | cut -d '"' -f 4)
    
    if [ -z "$download_url" ]; then
        error "Could not find Windows download URL"
        exit 1
    fi
    
    # Download and extract
    curl -L "$download_url" -o "$HOME/coder/coder.zip"
    cd "$HOME/coder"
    unzip coder.zip
    rm coder.zip
    
    # Add to PATH
    echo "Adding Coder to PATH..."
    setx PATH "%PATH%;%USERPROFILE%\coder"
    
    log "Coder installed on Windows"
    log "Please restart your terminal or run: refreshenv"
}

# Install Coder
install_coder() {
    log "Installing Coder..."
    
    case $OS in
        "linux")
            install_coder_linux
            ;;
        "macos")
            install_coder_macos
            ;;
        "windows")
            install_coder_windows
            ;;
        *)
            error "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Create configuration
create_config() {
    log "Creating Coder configuration..."
    
    # Create basic config
    cat > "$CODER_CONFIG_DIR/config.yaml" << EOF
# Coder Configuration for LI-FI Project
# Generated by coder_install.sh

# Server settings
address: "0.0.0.0:8080"
access_url: "http://localhost:8080"

# Development settings
devurl_host: "localhost"
devurl_port: "8080"

# Security settings
tls_enable: false
tls_cert_file: ""
tls_key_file: ""

# Database settings
postgres_url: ""

# Logging
log_level: "info"
log_format: "json"

# Workspace settings
max_workspace_agents: 10
max_workspace_agents_per_user: 5

# Resource limits
max_workspace_agents_per_user: 5
max_workspace_agents: 10
EOF
    
    log "Configuration created: $CODER_CONFIG_DIR/config.yaml"
}

# Create startup scripts
create_startup_scripts() {
    log "Creating startup scripts..."
    
    # Local development script
    cat > "$CODER_BIN_DIR/start_coder_local.sh" << 'EOF'
#!/bin/bash
# Start Coder server for local development

CODER_CONFIG="$HOME/.config/coder/config.yaml"

echo "Starting Coder server for local development..."
echo "Access URL: http://localhost:8080"
echo "Press Ctrl+C to stop"

if [ -f "$CODER_CONFIG" ]; then
    coder server --config "$CODER_CONFIG"
else
    coder server
fi
EOF
    
    # Remote development script
    cat > "$CODER_BIN_DIR/start_coder_remote.sh" << 'EOF'
#!/bin/bash
# Start Coder server for remote development

CODER_CONFIG="$HOME/.config/coder/config.yaml"

echo "Starting Coder server for remote development..."
echo "Access URL: http://0.0.0.0:8080"
echo "Press Ctrl+C to stop"

if [ -f "$CODER_CONFIG" ]; then
    coder server --config "$CODER_CONFIG" --address "0.0.0.0:8080"
else
    coder server --address "0.0.0.0:8080"
fi
EOF
    
    chmod +x "$CODER_BIN_DIR/start_coder_local.sh"
    chmod +x "$CODER_BIN_DIR/start_coder_remote.sh"
    
    log "Startup scripts created"
}

# Create systemd service (Linux only)
create_systemd_service() {
    if [[ "$OS" != "linux" ]]; then
        return 0
    fi
    
    log "Creating systemd service..."
    
    cat > /tmp/coder.service << EOF
[Unit]
Description=Coder Development Server
After=network.target
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$HOME
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=$HOME/.local/bin/coder server --config $CODER_CONFIG_DIR/config.yaml
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
ReadWritePaths=$CODER_CONFIG_DIR $CODER_DATA_DIR
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictRealtime=true
RestrictSUIDSGID=true
LockPersonality=true
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
EOF
    
    sudo cp /tmp/coder.service /etc/systemd/system/
    sudo systemctl daemon-reload
    
    log "Systemd service created: /etc/systemd/system/coder.service"
    log "To enable: sudo systemctl enable coder.service"
    log "To start: sudo systemctl start coder.service"
}

# Test installation
test_installation() {
    log "Testing Coder installation..."
    
    if command -v coder &> /dev/null; then
        local version=$(coder version 2>/dev/null | head -1 || echo "unknown")
        log "Coder installation successful: $version"
        
        # Test basic functionality
        if coder --help &> /dev/null; then
            log "Coder functionality test passed"
        else
            warning "Coder functionality test failed"
        fi
    else
        error "Coder installation failed"
        return 1
    fi
}

# Create documentation
create_documentation() {
    log "Creating documentation..."
    
    cat > "$CODER_CONFIG_DIR/README.md" << 'EOF'
# Coder Configuration for LI-FI Project

## Overview

Coder is a development environment manager that provides:
- Web-based IDE access
- Remote development workspaces
- SSH port forwarding
- Container-based development environments

## Quick Start

### Start Local Development Server
```bash
start_coder_local.sh
```

### Start Remote Development Server
```bash
start_coder_remote.sh
```

### Access Web Interface
Open your browser to: http://localhost:8080

## Configuration

### Local Development
- Access URL: http://localhost:8080
- Suitable for local development
- No external access

### Remote Development
- Access URL: http://0.0.0.0:8080
- Suitable for remote access
- Configure firewall appropriately

## Integration with LI-FI Project

### Raspberry Pi Development
1. SSH into Raspberry Pi
2. Start Coder server: `start_coder_remote.sh`
3. Access from development machine: http://raspberrypi.local:8080

### ESP8266 Development
1. Use Coder for web-based Arduino IDE
2. Access serial monitor via web interface
3. Deploy firmware through web interface

## Security Considerations

- Use HTTPS in production
- Configure firewall rules
- Use authentication
- Monitor access logs

## Troubleshooting

### Service Not Starting
```bash
sudo systemctl status coder.service
sudo journalctl -u coder.service -f
```

### Port Already in Use
```bash
netstat -tlnp | grep :8080
sudo lsof -i :8080
```

### Configuration Issues
```bash
coder server --help
coder server --config $HOME/.config/coder/config.yaml
```
EOF
    
    log "Documentation created: $CODER_CONFIG_DIR/README.md"
}

# Main function
main() {
    log "Starting Coder installation for LI-FI Project..."
    
    detect_os
    
    if check_existing_installation; then
        log "Using existing Coder installation"
    else
        install_dependencies
        install_coder
    fi
    
    create_config
    create_startup_scripts
    create_systemd_service
    test_installation
    create_documentation
    
    log "Coder installation completed successfully!"
    echo ""
    echo "Installation Summary:"
    echo "===================="
    echo "OS: $OS"
    echo "Coder Binary: $(which coder)"
    echo "Config Directory: $CODER_CONFIG_DIR"
    echo "Data Directory: $CODER_DATA_DIR"
    echo ""
    echo "Next Steps:"
    echo "==========="
    echo "1. Start local server: start_coder_local.sh"
    echo "2. Start remote server: start_coder_remote.sh"
    echo "3. Access web interface: http://localhost:8080"
    echo "4. Enable systemd service: sudo systemctl enable coder.service"
    echo ""
    echo "Documentation: $CODER_CONFIG_DIR/README.md"
}

# Run main function
main "$@" 