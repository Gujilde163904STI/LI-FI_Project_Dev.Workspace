#!/bin/bash

# Generate TLS Certificates for WayVNC
# Creates X509 certificates for secure VNC connections

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CERT_DIR="${HOME}/.config/wayvnc"
KEY_FILE="$CERT_DIR/tls_key.pem"
CERT_FILE="$CERT_DIR/tls_cert.pem"
CONFIG_FILE="$CERT_DIR/config"

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

# Check if OpenSSL is available
check_openssl() {
    if ! command -v openssl &> /dev/null; then
        error "OpenSSL is not installed. Installing..."
        sudo apt update
        sudo apt install -y openssl
    fi
}

# Create certificate directory
create_cert_dir() {
    log "Creating certificate directory..."
    mkdir -p "$CERT_DIR"
    chmod 700 "$CERT_DIR"
    log "Certificate directory created: $CERT_DIR"
}

# Generate private key
generate_private_key() {
    log "Generating private key..."
    
    if [ -f "$KEY_FILE" ]; then
        warning "Private key already exists: $KEY_FILE"
        read -p "Overwrite existing key? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing private key"
            return 0
        fi
    fi
    
    # Generate RSA private key (2048 bits)
    openssl genrsa -out "$KEY_FILE" 2048
    
    # Set proper permissions
    chmod 600 "$KEY_FILE"
    
    log "Private key generated: $KEY_FILE"
}

# Generate certificate
generate_certificate() {
    log "Generating certificate..."
    
    if [ -f "$CERT_FILE" ]; then
        warning "Certificate already exists: $CERT_FILE"
        read -p "Overwrite existing certificate? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing certificate"
            return 0
        fi
    fi
    
    # Get system information for certificate
    HOSTNAME=$(hostname)
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    
    # Generate certificate signing request
    openssl req -new -key "$KEY_FILE" \
        -out "$CERT_DIR/cert.csr" \
        -subj "/C=US/ST=State/L=City/O=RaspberryPi/CN=$HOSTNAME"
    
    # Generate self-signed certificate
    openssl x509 -req -in "$CERT_DIR/cert.csr" \
        -signkey "$KEY_FILE" \
        -out "$CERT_FILE" \
        -days 365 \
        -extensions v3_req \
        -extfile <(cat << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = US
ST = State
L = City
O = RaspberryPi
CN = $HOSTNAME

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $HOSTNAME
DNS.2 = localhost
DNS.3 = raspberrypi.local
IP.1 = $IP_ADDRESS
IP.2 = 127.0.0.1
EOF
)
    
    # Set proper permissions
    chmod 644 "$CERT_FILE"
    
    # Clean up CSR file
    rm -f "$CERT_DIR/cert.csr"
    
    log "Certificate generated: $CERT_FILE"
}

# Update WayVNC configuration
update_config() {
    log "Updating WayVNC configuration..."
    
    if [ -f "$CONFIG_FILE" ]; then
        # Backup existing config
        cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Add TLS configuration
        cat >> "$CONFIG_FILE" << EOF

# TLS Configuration
tls_cert_file=$CERT_FILE
tls_key_file=$KEY_FILE
enable_tls=true
EOF
        
        log "Configuration updated with TLS settings"
    else
        warning "WayVNC config file not found: $CONFIG_FILE"
        warning "Please run wayvnc_setup.sh first"
    fi
}

# Verify certificates
verify_certificates() {
    log "Verifying certificates..."
    
    if [ ! -f "$KEY_FILE" ] || [ ! -f "$CERT_FILE" ]; then
        error "Certificate files not found"
        return 1
    fi
    
    # Check private key
    if openssl rsa -in "$KEY_FILE" -check -noout; then
        log "Private key is valid"
    else
        error "Private key is invalid"
        return 1
    fi
    
    # Check certificate
    if openssl x509 -in "$CERT_FILE" -text -noout &> /dev/null; then
        log "Certificate is valid"
        
        # Display certificate info
        echo ""
        echo "Certificate Information:"
        echo "========================"
        openssl x509 -in "$CERT_FILE" -text -noout | grep -E "(Subject:|Issuer:|Not Before|Not After|DNS:|IP Address:)"
        echo ""
    else
        error "Certificate is invalid"
        return 1
    fi
    
    # Check certificate expiration
    local expiry_date=$(openssl x509 -in "$CERT_FILE" -noout -enddate | cut -d= -f2)
    local expiry_epoch=$(date -d "$expiry_date" +%s)
    local current_epoch=$(date +%s)
    local days_left=$(( (expiry_epoch - current_epoch) / 86400 ))
    
    if [ $days_left -gt 0 ]; then
        log "Certificate expires in $days_left days"
    else
        warning "Certificate has expired or will expire soon"
    fi
}

# Create client certificate (optional)
create_client_cert() {
    log "Creating client certificate..."
    
    CLIENT_KEY="$CERT_DIR/client_key.pem"
    CLIENT_CERT="$CERT_DIR/client_cert.pem"
    
    # Generate client private key
    openssl genrsa -out "$CLIENT_KEY" 2048
    chmod 600 "$CLIENT_KEY"
    
    # Generate client certificate
    openssl req -new -key "$CLIENT_KEY" \
        -out "$CERT_DIR/client.csr" \
        -subj "/C=US/ST=State/L=City/O=Client/CN=VNC-Client"
    
    openssl x509 -req -in "$CERT_DIR/client.csr" \
        -CA "$CERT_FILE" \
        -CAkey "$KEY_FILE" \
        -out "$CLIENT_CERT" \
        -days 365 \
        -CAcreateserial
    
    chmod 644 "$CLIENT_CERT"
    
    # Clean up
    rm -f "$CERT_DIR/client.csr"
    
    log "Client certificate created: $CLIENT_CERT"
}

# Generate connection script
create_connection_script() {
    log "Creating secure connection script..."
    
    cat > "$CERT_DIR/secure_connect.sh" << 'EOF'
#!/bin/bash
# Secure VNC connection script

PI_HOST="${1:-raspberrypi.local}"
PI_USER="${2:-pi}"
LOCAL_PORT="${3:-5900}"
REMOTE_PORT="${4:-5900}"

CERT_DIR="$HOME/.config/wayvnc"
CLIENT_CERT="$CERT_DIR/client_cert.pem"
CLIENT_KEY="$CERT_DIR/client_key.pem"

echo "Creating secure SSH tunnel to $PI_HOST..."
echo "Local port: $LOCAL_PORT"
echo "Remote port: $REMOTE_PORT"
echo ""

if [ -f "$CLIENT_CERT" ] && [ -f "$CLIENT_KEY" ]; then
    echo "Using client certificates for authentication"
    ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" \
        -i "$CLIENT_KEY" \
        "$PI_USER@$PI_HOST"
else
    echo "Using password authentication"
    ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" \
        "$PI_USER@$PI_HOST"
fi

echo ""
echo "Connect your VNC client to: localhost:$LOCAL_PORT"
echo "Press Ctrl+C to stop tunnel"
EOF
    
    chmod +x "$CERT_DIR/secure_connect.sh"
    log "Secure connection script created: $CERT_DIR/secure_connect.sh"
}

# Main function
main() {
    log "Starting TLS certificate generation for WayVNC..."
    
    check_openssl
    create_cert_dir
    generate_private_key
    generate_certificate
    update_config
    verify_certificates
    
    # Ask if user wants client certificate
    read -p "Create client certificate for mutual authentication? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        create_client_cert
    fi
    
    create_connection_script
    
    log "TLS certificate generation completed successfully!"
    echo ""
    echo "Files created:"
    echo "- Private key: $KEY_FILE"
    echo "- Certificate: $CERT_FILE"
    echo "- Secure connection script: $CERT_DIR/secure_connect.sh"
    echo ""
    echo "Next steps:"
    echo "1. Restart WayVNC service: sudo systemctl restart wayvnc.service"
    echo "2. Use secure connection: $CERT_DIR/secure_connect.sh"
    echo "3. Configure VNC client to use TLS"
    echo ""
    echo "Certificate will expire in 365 days"
}

# Run main function
main "$@" 