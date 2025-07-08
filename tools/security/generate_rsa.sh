#!/bin/bash

# Generate RSA-AES Keys for WayVNC
# Creates RSA keys for additional encryption layer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
KEY_DIR="${HOME}/.config/wayvnc"
RSA_KEY_FILE="$KEY_DIR/rsa_key.pem"
RSA_PUBLIC_FILE="$KEY_DIR/rsa_public.pem"
CONFIG_FILE="$KEY_DIR/config"

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

# Create key directory
create_key_dir() {
    log "Creating key directory..."
    mkdir -p "$KEY_DIR"
    chmod 700 "$KEY_DIR"
    log "Key directory created: $KEY_DIR"
}

# Generate RSA private key
generate_rsa_key() {
    log "Generating RSA private key..."
    
    if [ -f "$RSA_KEY_FILE" ]; then
        warning "RSA key already exists: $RSA_KEY_FILE"
        read -p "Overwrite existing key? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing RSA key"
            return 0
        fi
    fi
    
    # Generate RSA private key (4096 bits for better security)
    openssl genrsa -out "$RSA_KEY_FILE" 4096
    
    # Set proper permissions
    chmod 600 "$RSA_KEY_FILE"
    
    log "RSA private key generated: $RSA_KEY_FILE"
}

# Extract public key
extract_public_key() {
    log "Extracting public key..."
    
    if [ -f "$RSA_PUBLIC_FILE" ]; then
        warning "Public key already exists: $RSA_PUBLIC_FILE"
        read -p "Overwrite existing public key? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing public key"
            return 0
        fi
    fi
    
    # Extract public key from private key
    openssl rsa -in "$RSA_KEY_FILE" -pubout -out "$RSA_PUBLIC_FILE"
    
    # Set proper permissions
    chmod 644 "$RSA_PUBLIC_FILE"
    
    log "RSA public key extracted: $RSA_PUBLIC_FILE"
}

# Generate AES key for session encryption
generate_aes_key() {
    log "Generating AES session key..."
    
    AES_KEY_FILE="$KEY_DIR/aes_key.bin"
    
    if [ -f "$AES_KEY_FILE" ]; then
        warning "AES key already exists: $AES_KEY_FILE"
        read -p "Overwrite existing AES key? (y/N): " response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "Keeping existing AES key"
            return 0
        fi
    fi
    
    # Generate random AES key (256 bits)
    openssl rand -out "$AES_KEY_FILE" 32
    
    # Set proper permissions
    chmod 600 "$AES_KEY_FILE"
    
    log "AES session key generated: $AES_KEY_FILE"
}

# Update WayVNC configuration
update_config() {
    log "Updating WayVNC configuration..."
    
    if [ -f "$CONFIG_FILE" ]; then
        # Backup existing config
        cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Add RSA configuration
        cat >> "$CONFIG_FILE" << EOF

# RSA-AES Configuration
rsa_key_file=$RSA_KEY_FILE
rsa_public_file=$RSA_PUBLIC_FILE
enable_rsa_encryption=true
aes_key_file=$KEY_DIR/aes_key.bin
EOF
        
        log "Configuration updated with RSA-AES settings"
    else
        warning "WayVNC config file not found: $CONFIG_FILE"
        warning "Please run wayvnc_setup.sh first"
    fi
}

# Verify keys
verify_keys() {
    log "Verifying RSA keys..."
    
    if [ ! -f "$RSA_KEY_FILE" ] || [ ! -f "$RSA_PUBLIC_FILE" ]; then
        error "RSA key files not found"
        return 1
    fi
    
    # Check private key
    if openssl rsa -in "$RSA_KEY_FILE" -check -noout; then
        log "RSA private key is valid"
    else
        error "RSA private key is invalid"
        return 1
    fi
    
    # Check public key
    if openssl rsa -pubin -in "$RSA_PUBLIC_FILE" -text -noout &> /dev/null; then
        log "RSA public key is valid"
    else
        error "RSA public key is invalid"
        return 1
    fi
    
    # Display key information
    echo ""
    echo "RSA Key Information:"
    echo "===================="
    echo "Key size: $(openssl rsa -in "$RSA_KEY_FILE" -text -noout | grep 'Private-Key' | awk '{print $2}') bits"
    echo "Public key fingerprint: $(openssl rsa -pubin -in "$RSA_PUBLIC_FILE" -outform DER 2>/dev/null | openssl dgst -sha256 | awk '{print $2}')"
    echo ""
}

# Create encryption test script
create_test_script() {
    log "Creating encryption test script..."
    
    cat > "$KEY_DIR/test_encryption.sh" << 'EOF'
#!/bin/bash
# Test RSA-AES encryption

KEY_DIR="$HOME/.config/wayvnc"
RSA_KEY="$KEY_DIR/rsa_key.pem"
RSA_PUBLIC="$KEY_DIR/rsa_public.pem"
AES_KEY="$KEY_DIR/aes_key.bin"

TEST_FILE="$KEY_DIR/test_message.txt"
ENCRYPTED_FILE="$KEY_DIR/test_encrypted.bin"
DECRYPTED_FILE="$KEY_DIR/test_decrypted.txt"

echo "Testing RSA-AES encryption..."

# Create test message
echo "This is a test message for RSA-AES encryption." > "$TEST_FILE"

# Encrypt with AES
openssl enc -aes-256-cbc -salt -in "$TEST_FILE" -out "$ENCRYPTED_FILE" -kfile "$AES_KEY"

# Encrypt AES key with RSA
openssl rsautl -encrypt -inkey "$RSA_PUBLIC" -pubin -in "$AES_KEY" -out "$KEY_DIR/encrypted_aes_key.bin"

echo "Encryption test completed"
echo "Files created:"
echo "- Test message: $TEST_FILE"
echo "- Encrypted message: $ENCRYPTED_FILE"
echo "- Encrypted AES key: $KEY_DIR/encrypted_aes_key.bin"

# Clean up test files
rm -f "$TEST_FILE" "$ENCRYPTED_FILE" "$KEY_DIR/encrypted_aes_key.bin"
EOF
    
    chmod +x "$KEY_DIR/test_encryption.sh"
    log "Encryption test script created: $KEY_DIR/test_encryption.sh"
}

# Create key management script
create_key_management() {
    log "Creating key management script..."
    
    cat > "$KEY_DIR/manage_keys.sh" << 'EOF'
#!/bin/bash
# Key management for WayVNC

KEY_DIR="$HOME/.config/wayvnc"

case "$1" in
    "backup")
        echo "Creating backup of keys..."
        BACKUP_DIR="$KEY_DIR/backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        cp "$KEY_DIR"/*.pem "$KEY_DIR"/*.bin "$BACKUP_DIR/" 2>/dev/null || true
        echo "Backup created: $BACKUP_DIR"
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <backup_directory>"
            exit 1
        fi
        echo "Restoring keys from $2..."
        cp "$2"/*.pem "$2"/*.bin "$KEY_DIR/" 2>/dev/null || true
        chmod 600 "$KEY_DIR"/*.pem "$KEY_DIR"/*.bin 2>/dev/null || true
        echo "Keys restored"
        ;;
    "rotate")
        echo "Rotating keys..."
        mv "$KEY_DIR/rsa_key.pem" "$KEY_DIR/rsa_key.pem.old"
        mv "$KEY_DIR/rsa_public.pem" "$KEY_DIR/rsa_public.pem.old"
        mv "$KEY_DIR/aes_key.bin" "$KEY_DIR/aes_key.bin.old"
        echo "Old keys backed up with .old extension"
        echo "Run generate_rsa.sh to create new keys"
        ;;
    "list")
        echo "Available keys:"
        ls -la "$KEY_DIR"/*.pem "$KEY_DIR"/*.bin 2>/dev/null || echo "No keys found"
        ;;
    *)
        echo "Usage: $0 {backup|restore <dir>|rotate|list}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$KEY_DIR/manage_keys.sh"
    log "Key management script created: $KEY_DIR/manage_keys.sh"
}

# Create secure connection script
create_secure_connection() {
    log "Creating secure connection script..."
    
    cat > "$KEY_DIR/rsa_secure_connect.sh" << 'EOF'
#!/bin/bash
# RSA-AES secure VNC connection

PI_HOST="${1:-raspberrypi.local}"
PI_USER="${2:-pi}"
LOCAL_PORT="${3:-5900}"
REMOTE_PORT="${4:-5900}"

KEY_DIR="$HOME/.config/wayvnc"
RSA_KEY="$KEY_DIR/rsa_key.pem"

echo "Creating RSA-AES secure SSH tunnel to $PI_HOST..."
echo "Local port: $LOCAL_PORT"
echo "Remote port: $REMOTE_PORT"
echo ""

if [ -f "$RSA_KEY" ]; then
    echo "Using RSA key for authentication"
    ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" \
        -i "$RSA_KEY" \
        "$PI_USER@$PI_HOST"
else
    echo "RSA key not found, using password authentication"
    ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" \
        "$PI_USER@$PI_HOST"
fi

echo ""
echo "Connect your VNC client to: localhost:$LOCAL_PORT"
echo "Press Ctrl+C to stop tunnel"
EOF
    
    chmod +x "$KEY_DIR/rsa_secure_connect.sh"
    log "RSA secure connection script created: $KEY_DIR/rsa_secure_connect.sh"
}

# Main function
main() {
    log "Starting RSA-AES key generation for WayVNC..."
    
    check_openssl
    create_key_dir
    generate_rsa_key
    extract_public_key
    generate_aes_key
    update_config
    verify_keys
    create_test_script
    create_key_management
    create_secure_connection
    
    log "RSA-AES key generation completed successfully!"
    echo ""
    echo "Files created:"
    echo "- RSA private key: $RSA_KEY_FILE"
    echo "- RSA public key: $RSA_PUBLIC_FILE"
    echo "- AES session key: $KEY_DIR/aes_key.bin"
    echo "- Test script: $KEY_DIR/test_encryption.sh"
    echo "- Key management: $KEY_DIR/manage_keys.sh"
    echo "- Secure connection: $KEY_DIR/rsa_secure_connect.sh"
    echo ""
    echo "Next steps:"
    echo "1. Restart WayVNC service: sudo systemctl restart wayvnc.service"
    echo "2. Test encryption: $KEY_DIR/test_encryption.sh"
    echo "3. Use secure connection: $KEY_DIR/rsa_secure_connect.sh"
    echo "4. Manage keys: $KEY_DIR/manage_keys.sh"
    echo ""
    echo "Security features enabled:"
    echo "- RSA-4096 key for authentication"
    echo "- AES-256 for session encryption"
    echo "- Key rotation support"
    echo "- Backup and restore functionality"
}

# Run main function
main "$@" 