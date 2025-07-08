#!/bin/bash

# Network Boot Configuration for Raspberry Pi
# Based on official Raspberry Pi documentation: docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/network-boot-raspberry-pi.adoc

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
TFTP_DIR="/srv/tftp"
DHCP_CONFIG="/etc/dhcp/dhcpd.conf"
DHCP_LEASE="/var/lib/dhcp/dhcpd.leases"

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to install required packages
install_packages() {
    print_status "Installing network boot packages..."
    
    apt update
    apt install -y \
        dnsmasq \
        tftpd-hpa \
        nfs-kernel-server \
        rpi-eeprom \
        rpi-eeprom-images
    
    print_success "Network boot packages installed"
}

# Function to configure TFTP server
configure_tftp() {
    print_status "Configuring TFTP server..."
    
    # Create TFTP directory structure
    mkdir -p "$TFTP_DIR"
    mkdir -p "$TFTP_DIR/boot"
    mkdir -p "$TFTP_DIR/overlays"
    
    # Configure TFTP server
    cat > /etc/default/tftpd-hpa << EOF
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="$TFTP_DIR"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure"
EOF
    
    # Start and enable TFTP service
    systemctl enable tftpd-hpa
    systemctl start tftpd-hpa
    
    print_success "TFTP server configured"
}

# Function to configure DHCP server
configure_dhcp() {
    print_status "Configuring DHCP server for network boot..."
    
    # Backup existing DHCP config
    if [ -f "$DHCP_CONFIG" ]; then
        cp "$DHCP_CONFIG" "${DHCP_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create DHCP configuration
    cat > "$DHCP_CONFIG" << EOF
# DHCP Configuration for Raspberry Pi Network Boot
# Based on official Raspberry Pi documentation

default-lease-time 600;
max-lease-time 7200;

# Network configuration
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option broadcast-address 192.168.1.255;
    option routers 192.168.1.1;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    
    # Network boot configuration
    option tftp-server-name "192.168.1.1";
    option bootfile-name "bootcode.bin";
    
    # Raspberry Pi specific options
    option vendor-encapsulated-options 2B;
    option vendor-class-identifier "PXEClient";
    
    # Static IP assignments for LI-FI devices
    host rpi3-lifi {
        hardware ethernet b8:27:eb:00:00:01;
        fixed-address 192.168.1.110;
        option bootfile-name "bootcode.bin";
    }
    
    host rpi4-lifi {
        hardware ethernet dc:a6:32:00:00:01;
        fixed-address 192.168.1.111;
        option bootfile-name "bootcode.bin";
    }
}
EOF
    
    # Create lease file if it doesn't exist
    touch "$DHCP_LEASE"
    chown dhcpd:dhcpd "$DHCP_LEASE"
    
    # Start and enable DHCP service
    systemctl enable isc-dhcp-server
    systemctl start isc-dhcp-server
    
    print_success "DHCP server configured"
}

# Function to download Raspberry Pi boot files
download_boot_files() {
    print_status "Downloading Raspberry Pi boot files..."
    
    cd "$TFTP_DIR"
    
    # Download latest boot files
    wget -O bootcode.bin https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin
    wget -O start4.elf https://github.com/raspberrypi/firmware/raw/master/boot/start4.elf
    wget -O fixup4.dat https://github.com/raspberrypi/firmware/raw/master/boot/fixup4.dat
    wget -O bcm2711-rpi-4-b.dtb https://github.com/raspberrypi/firmware/raw/master/boot/bcm2711-rpi-4-b.dtb
    
    # Download overlays
    wget -O overlays/vc4-kms-v3d.dtbo https://github.com/raspberrypi/firmware/raw/master/boot/overlays/vc4-kms-v3d.dtbo
    wget -O overlays/disable-bt.dtbo https://github.com/raspberrypi/firmware/raw/master/boot/overlays/disable-bt.dtbo
    
    # Set permissions
    chmod 644 bootcode.bin start4.elf fixup4.dat bcm2711-rpi-4-b.dtb
    chmod 644 overlays/*
    
    print_success "Boot files downloaded"
}

# Function to create network boot configuration
create_network_boot_config() {
    print_status "Creating network boot configuration..."
    
    cat > "$TFTP_DIR/config.txt" << EOF
# Network Boot Configuration for Raspberry Pi
# Based on official Raspberry Pi documentation

# Enable network boot
program_usb_boot_mode=1
program_usb_boot_timeout=1

# Boot configuration
boot_delay=1
boot_delay_ms=2000

# Device tree configuration
dtoverlay=disable-bt
dtoverlay=vc4-kms-v3d

# Memory configuration
gpu_mem=128

# Network configuration
dtparam=eth0=on
dtparam=eth1=on

# LI-FI specific configuration
dtparam=i2c_arm=on
dtparam=spi=on
dtparam=uart0=on
EOF
    
    print_success "Network boot configuration created"
}

# Function to create network boot script
create_network_boot_script() {
    cat > "tools/rpi/setup_network_boot.sh" << 'EOF'
#!/bin/bash

# Network Boot Setup Script for Raspberry Pi
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

echo "Setting up Network Boot on Raspberry Pi..."
echo "========================================="

# Check if this is a Raspberry Pi 4
if ! grep -q "Raspberry Pi 4" /proc/cpuinfo; then
    print_error "Network boot is only supported on Raspberry Pi 4"
    exit 1
fi

# Update system
sudo apt update

# Install required packages
sudo apt install -y rpi-eeprom rpi-eeprom-images

# Enable network boot
echo "Enabling network boot..."
sudo rpi-eeprom-config --edit

# Set boot order to network first
sudo rpi-eeprom-config --apply boot.conf

print_success "Network boot enabled on Raspberry Pi"
echo ""
echo "Network boot is now enabled"
echo "The device will attempt to boot from network first"
echo "Make sure your network boot server is configured"
EOF

    chmod +x "tools/rpi/setup_network_boot.sh"
    print_success "Network boot setup script created"
}

# Function to create network boot test
create_network_boot_test() {
    cat > "tools/rpi/test_network_boot.sh" << 'EOF'
#!/bin/bash

# Test Network Boot Configuration
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

echo "Testing Network Boot Configuration..."
echo "==================================="

# Test TFTP server
echo -n "Testing TFTP server: "
if systemctl is-active --quiet tftpd-hpa; then
    print_success "TFTP server is running"
else
    print_error "TFTP server is not running"
fi

# Test DHCP server
echo -n "Testing DHCP server: "
if systemctl is-active --quiet isc-dhcp-server; then
    print_success "DHCP server is running"
else
    print_error "DHCP server is not running"
fi

# Test TFTP files
TFTP_DIR="/srv/tftp"
echo -n "Testing TFTP files: "
if [ -f "$TFTP_DIR/bootcode.bin" ] && [ -f "$TFTP_DIR/start4.elf" ]; then
    print_success "Boot files are present"
else
    print_error "Boot files are missing"
fi

# Test network connectivity
echo -n "Testing network connectivity: "
if ping -c 1 192.168.1.1 > /dev/null 2>&1; then
    print_success "Network is accessible"
else
    print_error "Network is not accessible"
fi

echo ""
echo "Network boot test complete!"
echo ""
echo "To test network boot:"
echo "1. Power on Raspberry Pi 4"
echo "2. Watch for network boot activity"
echo "3. Check DHCP leases: cat /var/lib/dhcp/dhcpd.leases"
EOF

    chmod +x "tools/rpi/test_network_boot.sh"
    print_success "Network boot test script created"
}

# Function to create network boot monitoring
create_network_boot_monitor() {
    cat > "tools/rpi/monitor_network_boot.sh" << 'EOF'
#!/bin/bash

# Monitor Network Boot Activity
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

echo "Monitoring Network Boot Activity..."
echo "=================================="

# Monitor DHCP leases
echo "Recent DHCP leases:"
tail -f /var/lib/dhcp/dhcpd.leases | grep -E "(rpi|raspberry)" &

# Monitor TFTP requests
echo "TFTP requests:"
tcpdump -i any port 69 -l &

# Monitor network traffic
echo "Network boot traffic:"
tcpdump -i any port 67 or port 68 or port 69 -l &

print_success "Network boot monitoring started"
echo "Press Ctrl+C to stop monitoring"
EOF

    chmod +x "tools/rpi/monitor_network_boot.sh"
    print_success "Network boot monitoring script created"
}

# Main execution
main() {
    echo "Raspberry Pi Network Boot Configuration"
    echo "======================================"
    echo "Based on official Raspberry Pi documentation"
    echo ""

    # Check if running as root
    check_root

    # Execute network boot setup
    install_packages
    configure_tftp
    configure_dhcp
    download_boot_files
    create_network_boot_config
    create_network_boot_script
    create_network_boot_test
    create_network_boot_monitor

    echo ""
    print_success "Network boot configuration completed!"
    echo ""
    echo "Next steps:"
    echo "1. Configure Raspberry Pi 4 for network boot:"
    echo "   scp tools/rpi/setup_network_boot.sh $PI_DEVICE:~/"
    echo "   ssh $PI_DEVICE 'chmod +x ~/setup_network_boot.sh && ~/setup_network_boot.sh'"
    echo ""
    echo "2. Test network boot configuration:"
    echo "   ./tools/rpi/test_network_boot.sh"
    echo ""
    echo "3. Monitor network boot activity:"
    echo "   ./tools/rpi/monitor_network_boot.sh"
    echo ""
    echo "4. Power cycle Raspberry Pi 4 to test network boot"
    echo ""
    echo "Documentation reference:"
    echo "  docs/raspberrypi-documentation/documentation/asciidoc/computers/remote-access/network-boot-raspberry-pi.adoc"
}

# Run main function
main "$@" 