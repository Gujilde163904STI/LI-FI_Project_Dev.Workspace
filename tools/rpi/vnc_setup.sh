#!/bin/bash

# VNC Configuration Setup for Raspberry Pi Remote GUI Access
# Based on official Raspberry Pi documentation: docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/vnc.adoc

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
PI_DEVICE="${1:-rpi4-lifi}"
VNC_PORT="5900"
VNC_DISPLAY=":0"

# Function to check if device is accessible
check_device_access() {
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$PI_DEVICE" "echo 'Connection test'" 2>/dev/null; then
        print_error "Cannot connect to $PI_DEVICE"
        print_warning "Ensure SSH is enabled and device is online"
        exit 1
    fi
    print_success "Device $PI_DEVICE is accessible"
}

# Function to install VNC server on Raspberry Pi
install_vnc_server() {
    print_status "Installing VNC server on $PI_DEVICE..."
    
    ssh "$PI_DEVICE" << 'EOF'
# Update package list
sudo apt update

# Install RealVNC server (recommended by Raspberry Pi Foundation)
sudo apt install -y realvnc-vnc-server

# Enable VNC server
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-x11-serviced.service

# Install TigerVNC as alternative
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Create VNC startup script
cat > ~/.vnc/xstartup << 'VNCSTARTUP'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
VNCSTARTUP

chmod +x ~/.vnc/xstartup

# Create VNC directory
mkdir -p ~/.vnc

echo "VNC server installation completed"
EOF

    print_success "VNC server installed and configured"
}

# Function to configure VNC settings
configure_vnc_settings() {
    print_status "Configuring VNC settings on $PI_DEVICE..."
    
    ssh "$PI_DEVICE" << 'EOF'
# Configure RealVNC settings
sudo raspi-config nonint do_vnc 0

# Set VNC resolution
sudo raspi-config nonint do_resolution 2 1920 1080

# Enable VNC on boot
sudo systemctl enable vncserver-x11-serviced.service

# Configure VNC password
vncpasswd

echo "VNC configuration completed"
EOF

    print_success "VNC settings configured"
}

# Function to create VNC connection script for Windows
create_vnc_client_script() {
    cat > "tools/rpi/connect_vnc.ps1" << 'EOF'
# VNC Connection Script for Windows
# Based on official Raspberry Pi VNC documentation

param(
    [Parameter(Mandatory=$false)]
    [string]$Device = "rpi4-lifi",
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 5900
)

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Red
}

# Device configurations
$Devices = @{
    "rpi3" = "192.168.1.100"
    "rpi4" = "192.168.1.101"
    "rpi3-lifi" = "192.168.1.110"
    "rpi4-lifi" = "192.168.1.111"
}

# Validate device
if (-not $Devices.ContainsKey($Device)) {
    Write-Error "Invalid device: $Device"
    Write-Host "Available devices: $($Devices.Keys -join ', ')"
    exit 1
}

$IP = $Devices[$Device]

Write-Status "Connecting to $Device ($IP) via VNC..."

# Check if VNC viewer is available
$VNCViewer = Get-Command "vncviewer" -ErrorAction SilentlyContinue
if (-not $VNCViewer) {
    Write-Warning "VNC viewer not found. Installing RealVNC Viewer..."
    
    # Download RealVNC Viewer
    $VNCUrl = "https://www.realvnc.com/en/connect/download/viewer/windows/"
    Write-Status "Please download RealVNC Viewer from: $VNCUrl"
    Write-Status "Or install via Chocolatey: choco install realvnc-viewer"
    
    # Try to open download page
    Start-Process $VNCUrl
} else {
    Write-Success "VNC viewer found"
}

# Test SSH connection first
Write-Status "Testing SSH connection..."
try {
    ssh -o ConnectTimeout=5 -o BatchMode=yes $Device "echo 'SSH connection successful'" 2>$null
    Write-Success "SSH connection established"
} catch {
    Write-Error "SSH connection failed"
    Write-Warning "Ensure SSH is enabled and device is online"
    exit 1
}

# Start VNC connection
Write-Status "Starting VNC connection to $IP:$Port..."
Write-Host "VNC Connection Details:" -ForegroundColor $Green
Write-Host "  Device: $Device" -ForegroundColor $Green
Write-Host "  IP: $IP" -ForegroundColor $Green
Write-Host "  Port: $Port" -ForegroundColor $Green
Write-Host "  Display: :0" -ForegroundColor $Green

# Launch VNC viewer
if ($VNCViewer) {
    & vncviewer "$IP`:$Port"
} else {
    Write-Warning "Please manually connect to $IP`:$Port using your VNC viewer"
}

Write-Success "VNC connection script completed"
EOF

    print_success "VNC client script created for Windows"
}

# Function to create VNC service configuration
create_vnc_service_config() {
    cat > "tools/rpi/vncserver.service" << 'EOF'
[Unit]
Description=TigerVNC Server
After=network.target

[Service]
Type=forking
User=pi
Group=pi
WorkingDirectory=/home/pi
PIDFile=/home/pi/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1080 :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF

    print_success "VNC service configuration created"
}

# Function to create VNC startup script for Raspberry Pi
create_vnc_startup_script() {
    cat > "tools/rpi/setup_vnc_on_pi.sh" << 'EOF'
#!/bin/bash

# VNC Setup Script for Raspberry Pi
# Based on official Raspberry Pi VNC documentation

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "Setting up VNC on Raspberry Pi..."
echo "================================="

# Update system
sudo apt update

# Install VNC server
sudo apt install -y realvnc-vnc-server realvnc-vnc-viewer

# Enable VNC
sudo raspi-config nonint do_vnc 0

# Set resolution
sudo raspi-config nonint do_resolution 2 1920 1080

# Enable VNC on boot
sudo systemctl enable vncserver-x11-serviced.service

# Start VNC service
sudo systemctl start vncserver-x11-serviced.service

# Set VNC password
echo "Setting VNC password..."
vncpasswd

# Create VNC startup directory
mkdir -p ~/.vnc

# Create VNC startup script
cat > ~/.vnc/xstartup << 'VNCSTARTUP'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
VNCSTARTUP

chmod +x ~/.vnc/xstartup

print_success "VNC setup completed on Raspberry Pi"
echo ""
echo "VNC is now enabled and will start on boot"
echo "Connect using VNC viewer to this device's IP address"
echo "Default port: 5900"
EOF

    chmod +x "tools/rpi/setup_vnc_on_pi.sh"
    print_success "VNC setup script created for Raspberry Pi"
}

# Function to create VNC connection test
create_vnc_test() {
    cat > "tools/rpi/test_vnc.sh" << 'EOF'
#!/bin/bash

# Test VNC connections to Raspberry Pi devices
# Based on official Raspberry Pi VNC documentation

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Test devices
declare -A TEST_DEVICES=(
    ["rpi3"]="192.168.1.100"
    ["rpi4"]="192.168.1.101"
    ["rpi3-lifi"]="192.168.1.110"
    ["rpi4-lifi"]="192.168.1.111"
)

echo "Testing VNC connections to Raspberry Pi devices..."
echo "================================================"

for device in "${!TEST_DEVICES[@]}"; do
    ip="${TEST_DEVICES[$device]}"
    echo -n "Testing VNC on $device ($ip): "
    
    # Test VNC port
    if nc -z -w5 "$ip" 5900 2>/dev/null; then
        print_success "VNC port 5900 is open on $device"
    else
        print_error "VNC port 5900 is not accessible on $device"
        print_warning "Check if VNC server is running and firewall allows connections"
    fi
done

echo ""
echo "VNC connection test complete!"
echo ""
echo "To connect via VNC:"
echo "  Windows: Use RealVNC Viewer or TigerVNC Viewer"
echo "  Linux:   vncviewer 192.168.1.101:5900"
echo "  macOS:   open vnc://192.168.1.101:5900"
EOF

    chmod +x "tools/rpi/test_vnc.sh"
    print_success "VNC connection test script created"
}

# Main execution
main() {
    echo "Raspberry Pi VNC Configuration Setup"
    echo "===================================="
    echo "Based on official Raspberry Pi documentation"
    echo ""

    # Check if device parameter is provided
    if [ -z "$1" ]; then
        print_warning "No device specified, using default: $PI_DEVICE"
        print_status "Usage: $0 [rpi3|rpi4|rpi3-lifi|rpi4-lifi]"
    fi

    # Check device access
    check_device_access

    # Execute VNC setup
    install_vnc_server
    configure_vnc_settings
    create_vnc_client_script
    create_vnc_service_config
    create_vnc_startup_script
    create_vnc_test

    echo ""
    print_success "VNC configuration setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. Run VNC setup on Raspberry Pi:"
    echo "   scp tools/rpi/setup_vnc_on_pi.sh $PI_DEVICE:~/"
    echo "   ssh $PI_DEVICE 'chmod +x ~/setup_vnc_on_pi.sh && ~/setup_vnc_on_pi.sh'"
    echo ""
    echo "2. Test VNC connections:"
    echo "   ./tools/rpi/test_vnc.sh"
    echo ""
    echo "3. Connect via VNC (Windows):"
    echo "   ./tools/rpi/connect_vnc.ps1 $PI_DEVICE"
    echo ""
    echo "4. Manual connection:"
    echo "   Use VNC viewer to connect to $PI_DEVICE:5900"
    echo ""
    echo "Documentation reference:"
    echo "  docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/vnc.adoc"
}

# Run main function
main "$@" 