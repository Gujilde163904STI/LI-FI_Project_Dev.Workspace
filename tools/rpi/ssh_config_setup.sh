#!/bin/bash

# SSH Configuration Setup for Raspberry Pi Remote Development
# Based on official Raspberry Pi documentation: docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/ssh.adoc

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
SSH_CONFIG_DIR="$HOME/.ssh"
SSH_CONFIG_FILE="$SSH_CONFIG_DIR/config"
BACKUP_FILE="$SSH_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# Raspberry Pi device configurations
declare -A PI_DEVICES=(
    ["rpi3"]="192.168.1.100"
    ["rpi4"]="192.168.1.101"
    ["rpi3-lifi"]="192.168.1.110"
    ["rpi4-lifi"]="192.168.1.111"
)

# Default SSH settings based on official documentation
SSH_SETTINGS=(
    "Host *"
    "    ServerAliveInterval 60"
    "    ServerAliveCountMax 3"
    "    TCPKeepAlive yes"
    "    Compression yes"
    "    ControlMaster auto"
    "    ControlPath ~/.ssh/control-%r@%h:%p"
    "    ControlPersist 10m"
)

# Function to backup existing SSH config
backup_ssh_config() {
    if [ -f "$SSH_CONFIG_FILE" ]; then
        print_status "Backing up existing SSH config to $BACKUP_FILE"
        cp "$SSH_CONFIG_FILE" "$BACKUP_FILE"
        print_success "Backup created successfully"
    fi
}

# Function to create SSH config directory
create_ssh_dir() {
    if [ ! -d "$SSH_CONFIG_DIR" ]; then
        print_status "Creating SSH config directory"
        mkdir -p "$SSH_CONFIG_DIR"
        chmod 700 "$SSH_CONFIG_DIR"
        print_success "SSH directory created"
    fi
}

# Function to generate SSH config for Raspberry Pi devices
generate_ssh_config() {
    print_status "Generating SSH configuration for Raspberry Pi devices"
    
    # Create new config file
    cat > "$SSH_CONFIG_FILE" << 'EOF'
# SSH Configuration for Raspberry Pi Remote Development
# Generated from official Raspberry Pi documentation
# Based on: docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/ssh.adoc

# Global settings for all hosts
EOF

    # Add global SSH settings
    for setting in "${SSH_SETTINGS[@]}"; do
        echo "$setting" >> "$SSH_CONFIG_FILE"
    done

    echo "" >> "$SSH_CONFIG_FILE"
    echo "# Raspberry Pi Device Configurations" >> "$SSH_CONFIG_FILE"
    echo "" >> "$SSH_CONFIG_FILE"

    # Generate configurations for each Pi device
    for device in "${!PI_DEVICES[@]}"; do
        ip="${PI_DEVICES[$device]}"
        echo "Host $device" >> "$SSH_CONFIG_FILE"
        echo "    HostName $ip" >> "$SSH_CONFIG_FILE"
        echo "    User pi" >> "$SSH_CONFIG_FILE"
        echo "    Port 22" >> "$SSH_CONFIG_FILE"
        echo "    IdentityFile ~/.ssh/id_rsa" >> "$SSH_CONFIG_FILE"
        echo "    StrictHostKeyChecking no" >> "$SSH_CONFIG_FILE"
        echo "    UserKnownHostsFile /dev/null" >> "$SSH_CONFIG_FILE"
        echo "    # Enable X11 forwarding for GUI applications" >> "$SSH_CONFIG_FILE"
        echo "    ForwardX11 yes" >> "$SSH_CONFIG_FILE"
        echo "    ForwardX11Trusted yes" >> "$SSH_CONFIG_FILE"
        echo "    # Enable agent forwarding for key-based authentication" >> "$SSH_CONFIG_FILE"
        echo "    ForwardAgent yes" >> "$SSH_CONFIG_FILE"
        echo "    # Performance optimizations" >> "$SSH_CONFIG_FILE"
        echo "    IPQoS 0x00" >> "$SSH_CONFIG_FILE"
        echo "    # Connection multiplexing" >> "$SSH_CONFIG_FILE"
        echo "    ControlMaster auto" >> "$SSH_CONFIG_FILE"
        echo "    ControlPath ~/.ssh/control-%r@%h:%p" >> "$SSH_CONFIG_FILE"
        echo "    ControlPersist 10m" >> "$SSH_CONFIG_FILE"
        echo "" >> "$SSH_CONFIG_FILE"
    done

    # Add VSCode Remote Development settings
    cat >> "$SSH_CONFIG_FILE" << 'EOF'

# VSCode Remote Development Settings
# Enable seamless remote development with Cursor/VSCode

Host rpi3 rpi4 rpi3-lifi rpi4-lifi
    # Enable remote port forwarding for development
    RemoteForward 52698 127.0.0.1:52698
    # Enable SFTP for file synchronization
    Subsystem sftp internal-sftp
    # Optimize for remote development
    SendEnv LANG LC_*
    AcceptEnv LANG LC_*
EOF

    print_success "SSH configuration generated successfully"
}

# Function to generate SSH key if not exists
generate_ssh_key() {
    if [ ! -f "$SSH_CONFIG_DIR/id_rsa" ]; then
        print_status "Generating SSH key pair for Raspberry Pi access"
        ssh-keygen -t rsa -b 4096 -f "$SSH_CONFIG_DIR/id_rsa" -N "" -C "raspberry-pi-development"
        print_success "SSH key pair generated"
    else
        print_status "SSH key pair already exists"
    fi
}

# Function to create connection test script
create_connection_test() {
    cat > "tools/rpi/test_connections.sh" << 'EOF'
#!/bin/bash

# Test SSH connections to Raspberry Pi devices
# Based on official Raspberry Pi documentation

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

echo "Testing SSH connections to Raspberry Pi devices..."
echo "================================================"

for device in "${!TEST_DEVICES[@]}"; do
    ip="${TEST_DEVICES[$device]}"
    echo -n "Testing $device ($ip): "
    
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "$device" "echo 'Connection successful'" 2>/dev/null; then
        print_success "Connected to $device"
    else
        print_error "Failed to connect to $device"
        print_warning "Check if device is online and SSH is enabled"
    fi
done

echo ""
echo "Connection test complete!"
echo ""
echo "To connect to a device:"
echo "  ssh rpi3      # Connect to Raspberry Pi 3"
echo "  ssh rpi4      # Connect to Raspberry Pi 4"
echo "  ssh rpi3-lifi # Connect to LI-FI Raspberry Pi 3"
echo "  ssh rpi4-lifi # Connect to LI-FI Raspberry Pi 4"
EOF

    chmod +x "tools/rpi/test_connections.sh"
    print_success "Connection test script created"
}

# Function to create deployment script template
create_deployment_script() {
    cat > "tools/rpi/deploy_to_pi.sh" << 'EOF'
#!/bin/bash

# Deploy LI-FI firmware to Raspberry Pi devices
# Based on official Raspberry Pi rsync documentation

set -e

# Configuration
PI_DEVICE="${1:-rpi4-lifi}"
DEPLOY_SOURCE="./build/"
DEPLOY_DEST="/home/pi/lifi-firmware/"

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

# Validate device
if [[ ! "$PI_DEVICE" =~ ^(rpi3|rpi4|rpi3-lifi|rpi4-lifi)$ ]]; then
    print_error "Invalid device: $PI_DEVICE"
    echo "Usage: $0 [rpi3|rpi4|rpi3-lifi|rpi4-lifi]"
    exit 1
fi

print_status "Deploying LI-FI firmware to $PI_DEVICE..."

# Test connection first
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$PI_DEVICE" "echo 'Connection test'" 2>/dev/null; then
    print_error "Cannot connect to $PI_DEVICE"
    exit 1
fi

# Create remote directory
ssh "$PI_DEVICE" "mkdir -p $DEPLOY_DEST"

# Deploy using rsync (based on official documentation)
rsync -avz --progress \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.git' \
    --exclude='node_modules' \
    "$DEPLOY_SOURCE" "$PI_DEVICE:$DEPLOY_DEST"

print_success "Deployment completed successfully"

# Restart services if needed
read -p "Restart LI-FI services on $PI_DEVICE? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ssh "$PI_DEVICE" "sudo systemctl restart lifi-server"
    print_success "Services restarted"
fi
EOF

    chmod +x "tools/rpi/deploy_to_pi.sh"
    print_success "Deployment script created"
}

# Main execution
main() {
    echo "Raspberry Pi SSH Configuration Setup"
    echo "===================================="
    echo "Based on official Raspberry Pi documentation"
    echo ""

    # Check if running on Windows (WSL)
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        print_warning "Detected Windows environment"
        print_status "This script is optimized for Windows development with Raspberry Pi targets"
    fi

    # Execute setup steps
    backup_ssh_config
    create_ssh_dir
    generate_ssh_key
    generate_ssh_config
    create_connection_test
    create_deployment_script

    echo ""
    print_success "SSH configuration setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. Copy your SSH public key to Raspberry Pi devices:"
    echo "   ssh-copy-id -i ~/.ssh/id_rsa.pub pi@<PI_IP_ADDRESS>"
    echo ""
    echo "2. Test connections:"
    echo "   ./tools/rpi/test_connections.sh"
    echo ""
    echo "3. Deploy firmware:"
    echo "   ./tools/rpi/deploy_to_pi.sh rpi4-lifi"
    echo ""
    echo "4. Connect with VSCode/Cursor:"
    echo "   - Install 'Remote - SSH' extension"
    echo "   - Use 'rpi3', 'rpi4', 'rpi3-lifi', or 'rpi4-lifi' as hostnames"
    echo ""
    echo "Documentation reference:"
    echo "  docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/ssh.adoc"
}

# Run main function
main "$@" 