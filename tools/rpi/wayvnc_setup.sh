#!/bin/bash

# WayVNC Setup Script for Raspberry Pi
# Installs dependencies, builds wayvnc, and configures for headless operation
# Supports both RPi3B and RPi4B with Wayland compositor

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
WAYVNC_DIR="/home/pi/wayvnc"
BUILD_DIR="$WAYVNC_DIR/build"
CONFIG_DIR="/home/pi/.config/wayvnc"
SERVICE_DIR="/etc/systemd/system"

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
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root"
        exit 1
    fi
}

# Check system requirements
check_system() {
    log "Checking system requirements..."
    
    # Check if running on Raspberry Pi
    if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
        warning "This script is designed for Raspberry Pi. Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check available memory
    local mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local mem_mb=$((mem_kb / 1024))
    
    if [ $mem_mb -lt 512 ]; then
        error "Insufficient memory: ${mem_mb}MB (minimum 512MB required)"
        exit 1
    fi
    
    # Check available disk space
    local disk_space=$(df /home | tail -1 | awk '{print $4}')
    local disk_mb=$((disk_space / 1024))
    
    if [ $disk_mb -lt 1024 ]; then
        error "Insufficient disk space: ${disk_mb}MB (minimum 1GB required)"
        exit 1
    fi
    
    log "System requirements check passed"
}

# Update system packages
update_system() {
    log "Updating system packages..."
    sudo apt update
    sudo apt upgrade -y
    log "System packages updated"
}

# Install build dependencies
install_dependencies() {
    log "Installing build dependencies..."
    
    # Essential build tools
    sudo apt install -y \
        build-essential \
        cmake \
        ninja-build \
        pkg-config \
        git \
        wget \
        curl
    
    # Wayland and graphics dependencies
    sudo apt install -y \
        libwayland-dev \
        libwayland-egl1-mesa-dev \
        libxkbcommon-dev \
        libdrm-dev \
        libgbm-dev \
        libpixman-1-dev \
        libcairo2-dev \
        libpango1.0-dev \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        libgnutls28-dev
    
    # Additional dependencies for wayvnc
    sudo apt install -y \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libavutil-dev \
        libx11-dev \
        libxrandr-dev \
        libxfixes-dev \
        libxdamage-dev \
        libxcomposite-dev \
        libxinerama-dev
    
    log "Build dependencies installed"
}

# Check Wayland compositor
check_wayland() {
    log "Checking Wayland compositor..."
    
    if [ -z "$WAYLAND_DISPLAY" ]; then
        warning "Wayland display not detected"
        warning "WayVNC requires a Wayland compositor (like Weston, Sway, or wlroots-based)"
        warning "Consider using RealVNC as fallback for X11 environments"
        
        echo "Available compositors:"
        echo "1. Weston (lightweight)"
        echo "2. Sway (tiling window manager)"
        echo "3. wlroots-based compositor"
        echo "4. Use RealVNC fallback"
        
        read -p "Choose option (1-4): " choice
        case $choice in
            1) install_weston ;;
            2) install_sway ;;
            3) install_wlroots ;;
            4) setup_realvnc_fallback ;;
            *) error "Invalid choice"; exit 1 ;;
        esac
    else
        log "Wayland compositor detected: $WAYLAND_DISPLAY"
    fi
}

# Install Weston compositor
install_weston() {
    log "Installing Weston compositor..."
    sudo apt install -y weston
    log "Weston installed. Start with: weston --backend=drm-backend.so"
}

# Install Sway
install_sway() {
    log "Installing Sway window manager..."
    sudo apt install -y sway
    log "Sway installed. Start with: sway"
}

# Install wlroots
install_wlroots() {
    log "Installing wlroots..."
    sudo apt install -y libwlroots-dev
    log "wlroots installed"
}

# Setup RealVNC fallback
setup_realvnc_fallback() {
    log "Setting up RealVNC fallback..."
    sudo apt install -y realvnc-vnc-server
    sudo systemctl enable vncserver-x11-serviced
    sudo systemctl start vncserver-x11-serviced
    log "RealVNC server installed and enabled"
}

# Clone wayvnc repository
clone_wayvnc() {
    log "Cloning wayvnc repository..."
    
    if [ -d "$WAYVNC_DIR" ]; then
        warning "wayvnc directory already exists. Updating..."
        cd "$WAYVNC_DIR"
        git pull origin main
    else
        git clone https://github.com/any1/wayvnc.git "$WAYVNC_DIR"
        cd "$WAYVNC_DIR"
    fi
    
    # Initialize and update submodules
    git submodule update --init --recursive
    
    log "wayvnc repository ready"
}

# Build wayvnc
build_wayvnc() {
    log "Building wayvnc..."
    
    cd "$WAYVNC_DIR"
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Configure with meson
    meson setup --buildtype=release ..
    
    # Build with ninja
    ninja
    
    log "wayvnc built successfully"
}

# Create configuration directory
setup_config() {
    log "Setting up configuration..."
    
    mkdir -p "$CONFIG_DIR"
    
    # Create basic config file
    cat > "$CONFIG_DIR/config" << EOF
# WayVNC Configuration
# Generated by wayvnc_setup.sh

# Network settings
address=0.0.0.0
port=5900

# Security settings
enable_auth=true
username=pi
password_file=$CONFIG_DIR/password

# Performance settings
max_fps=30
quality=80

# Logging
log_level=info
log_file=$CONFIG_DIR/wayvnc.log
EOF
    
    # Set permissions
    chmod 600 "$CONFIG_DIR/config"
    chmod 700 "$CONFIG_DIR"
    
    log "Configuration created at $CONFIG_DIR/config"
}

# Generate systemd service
create_systemd_service() {
    log "Creating systemd service..."
    
    sudo tee "$SERVICE_DIR/wayvnc.service" > /dev/null << EOF
[Unit]
Description=WayVNC Server
After=multi-user.target
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=pi
Group=pi
WorkingDirectory=$WAYVNC_DIR
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=WAYLAND_DISPLAY=wayland-0
ExecStart=$BUILD_DIR/wayvnc --config=$CONFIG_DIR/config
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd
    sudo systemctl daemon-reload
    
    log "Systemd service created"
}

# Setup firewall rules
setup_firewall() {
    log "Setting up firewall rules..."
    
    # Allow VNC port
    sudo ufw allow 5900/tcp comment "WayVNC"
    
    # Allow SSH (if not already allowed)
    sudo ufw allow ssh
    
    log "Firewall rules configured"
}

# Create security scripts
create_security_scripts() {
    log "Creating security scripts..."
    
    # Generate TLS certificate script
    cat > "$CONFIG_DIR/generate_tls.sh" << 'EOF'
#!/bin/bash
# Generate TLS certificates for WayVNC

CERT_DIR="$HOME/.config/wayvnc"
mkdir -p "$CERT_DIR"

# Generate private key
openssl genrsa -out "$CERT_DIR/tls_key.pem" 2048

# Generate certificate
openssl req -new -x509 -key "$CERT_DIR/tls_key.pem" \
    -out "$CERT_DIR/tls_cert.pem" \
    -days 365 \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=raspberrypi.local"

chmod 600 "$CERT_DIR/tls_key.pem"
chmod 644 "$CERT_DIR/tls_cert.pem"

echo "TLS certificates generated in $CERT_DIR"
EOF
    
    # Generate RSA key script
    cat > "$CONFIG_DIR/generate_rsa.sh" << 'EOF'
#!/bin/bash
# Generate RSA key for WayVNC

KEY_DIR="$HOME/.config/wayvnc"
mkdir -p "$KEY_DIR"

# Generate RSA key
openssl genrsa -out "$KEY_DIR/rsa_key.pem" 2048

chmod 600 "$KEY_DIR/rsa_key.pem"

echo "RSA key generated in $KEY_DIR"
EOF
    
    chmod +x "$CONFIG_DIR/generate_tls.sh"
    chmod +x "$CONFIG_DIR/generate_rsa.sh"
    
    log "Security scripts created"
}

# Create connection helper scripts
create_connection_scripts() {
    log "Creating connection helper scripts..."
    
    # SSH tunnel script
    cat > "$CONFIG_DIR/ssh_tunnel.sh" << 'EOF'
#!/bin/bash
# SSH tunnel for WayVNC access

PI_HOST="${1:-raspberrypi.local}"
PI_USER="${2:-pi}"
LOCAL_PORT="${3:-5900}"
REMOTE_PORT="${4:-5900}"

echo "Creating SSH tunnel to $PI_HOST..."
echo "Local port: $LOCAL_PORT"
echo "Remote port: $REMOTE_PORT"
echo ""
echo "Connect your VNC client to: localhost:$LOCAL_PORT"
echo "Press Ctrl+C to stop tunnel"

ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" "$PI_USER@$PI_HOST"
EOF
    
    # VNC client connection script
    cat > "$CONFIG_DIR/connect_vnc.sh" << 'EOF'
#!/bin/bash
# Connect to WayVNC server

PI_HOST="${1:-raspberrypi.local}"
PI_USER="${2:-pi}"
PORT="${3:-5900}"

echo "Connecting to WayVNC server..."
echo "Host: $PI_HOST"
echo "Port: $PORT"
echo ""

# Try different VNC clients
if command -v vinagre &> /dev/null; then
    echo "Using Vinagre VNC client..."
    vinagre "$PI_HOST:$PORT"
elif command -v vncviewer &> /dev/null; then
    echo "Using VNC Viewer..."
    vncviewer "$PI_HOST:$PORT"
elif command -v remmina &> /dev/null; then
    echo "Using Remmina..."
    remmina -c "vnc://$PI_HOST:$PORT"
else
    echo "No VNC client found. Install one of:"
    echo "- vinagre (GNOME)"
    echo "- tigervnc-viewer"
    echo "- remmina"
fi
EOF
    
    chmod +x "$CONFIG_DIR/ssh_tunnel.sh"
    chmod +x "$CONFIG_DIR/connect_vnc.sh"
    
    log "Connection scripts created"
}

# Test wayvnc
test_wayvnc() {
    log "Testing wayvnc installation..."
    
    if [ -f "$BUILD_DIR/wayvnc" ]; then
        log "WayVNC binary found"
        
        # Test basic functionality
        if "$BUILD_DIR/wayvnc" --help &> /dev/null; then
            log "WayVNC test successful"
        else
            error "WayVNC test failed"
            return 1
        fi
    else
        error "WayVNC binary not found"
        return 1
    fi
}

# Main installation function
main() {
    log "Starting WayVNC setup for Raspberry Pi..."
    
    check_root
    check_system
    update_system
    install_dependencies
    check_wayland
    clone_wayvnc
    build_wayvnc
    setup_config
    create_systemd_service
    setup_firewall
    create_security_scripts
    create_connection_scripts
    test_wayvnc
    
    log "WayVNC setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Enable the service: sudo systemctl enable wayvnc.service"
    echo "2. Start the service: sudo systemctl start wayvnc.service"
    echo "3. Check status: sudo systemctl status wayvnc.service"
    echo "4. Generate certificates: $CONFIG_DIR/generate_tls.sh"
    echo "5. Connect via SSH tunnel: $CONFIG_DIR/ssh_tunnel.sh"
    echo ""
    echo "For fallback to RealVNC, run: tools/rpi/realvnc_setup.sh"
}

# Run main function
main "$@" 