#!/bin/bash

# WayVNC SSH Tunnel Script
# Creates secure SSH tunnels for remote VNC access

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
DEFAULT_PI_HOST="raspberrypi.local"
DEFAULT_PI_USER="pi"
DEFAULT_LOCAL_PORT="5900"
DEFAULT_REMOTE_PORT="5900"
DEFAULT_SSH_PORT="22"

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

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [PI_HOST]

Options:
    -h, --host PI_HOST        Raspberry Pi hostname/IP (default: $DEFAULT_PI_HOST)
    -u, --user USER           SSH username (default: $DEFAULT_PI_USER)
    -l, --local-port PORT     Local port for tunnel (default: $DEFAULT_LOCAL_PORT)
    -r, --remote-port PORT    Remote VNC port (default: $DEFAULT_REMOTE_PORT)
    -s, --ssh-port PORT       SSH port (default: $DEFAULT_SSH_PORT)
    -k, --key KEY_FILE        SSH private key file
    -v, --verbose             Verbose output
    -d, --daemon              Run in background
    -c, --check               Check connection without creating tunnel
    --help                    Show this help message

Examples:
    $0                                    # Basic tunnel to default host
    $0 -h 192.168.1.100                  # Tunnel to specific IP
    $0 -l 5901 -r 5900                   # Use different local port
    $0 -k ~/.ssh/id_rsa_pi               # Use specific SSH key
    $0 -d                                 # Run in background
    $0 -c -h raspberrypi.local           # Check connection

Environment Variables:
    WAYVNC_PI_HOST           Default Pi hostname
    WAYVNC_PI_USER           Default Pi username
    WAYVNC_SSH_KEY           Default SSH key file
EOF
}

# Parse command line arguments
parse_args() {
    PI_HOST="$DEFAULT_PI_HOST"
    PI_USER="$DEFAULT_PI_USER"
    LOCAL_PORT="$DEFAULT_LOCAL_PORT"
    REMOTE_PORT="$DEFAULT_REMOTE_PORT"
    SSH_PORT="$DEFAULT_SSH_PORT"
    SSH_KEY=""
    VERBOSE=false
    DAEMON=false
    CHECK_ONLY=false
    
    # Check environment variables
    if [ -n "$WAYVNC_PI_HOST" ]; then
        PI_HOST="$WAYVNC_PI_HOST"
    fi
    if [ -n "$WAYVNC_PI_USER" ]; then
        PI_USER="$WAYVNC_PI_USER"
    fi
    if [ -n "$WAYVNC_SSH_KEY" ]; then
        SSH_KEY="$WAYVNC_SSH_KEY"
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--host)
                PI_HOST="$2"
                shift 2
                ;;
            -u|--user)
                PI_USER="$2"
                shift 2
                ;;
            -l|--local-port)
                LOCAL_PORT="$2"
                shift 2
                ;;
            -r|--remote-port)
                REMOTE_PORT="$2"
                shift 2
                ;;
            -s|--ssh-port)
                SSH_PORT="$2"
                shift 2
                ;;
            -k|--key)
                SSH_KEY="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--daemon)
                DAEMON=true
                shift
                ;;
            -c|--check)
                CHECK_ONLY=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                PI_HOST="$1"
                shift
                ;;
        esac
    done
}

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    if ! command -v ssh &> /dev/null; then
        error "SSH client not found. Please install OpenSSH client."
        exit 1
    fi
    
    if ! command -v netstat &> /dev/null && ! command -v ss &> /dev/null; then
        warning "netstat/ss not found. Port checking will be limited."
    fi
    
    log "Dependencies check passed"
}

# Check if port is available
check_port_availability() {
    local port="$1"
    
    if command -v netstat &> /dev/null; then
        if netstat -tln 2>/dev/null | grep -q ":$port "; then
            return 1
        fi
    elif command -v ss &> /dev/null; then
        if ss -tln 2>/dev/null | grep -q ":$port "; then
            return 1
        fi
    fi
    
    return 0
}

# Test SSH connection
test_ssh_connection() {
    log "Testing SSH connection to $PI_USER@$PI_HOST:$SSH_PORT..."
    
    local ssh_opts="-o ConnectTimeout=10 -o BatchMode=yes"
    
    if [ -n "$SSH_KEY" ]; then
        ssh_opts="$ssh_opts -i $SSH_KEY"
    fi
    
    if ssh $ssh_opts -p "$SSH_PORT" "$PI_USER@$PI_HOST" "echo 'SSH connection successful'" 2>/dev/null; then
        log "SSH connection test successful"
        return 0
    else
        error "SSH connection test failed"
        return 1
    fi
}

# Check VNC service on remote host
check_vnc_service() {
    log "Checking VNC service on remote host..."
    
    local ssh_opts="-o ConnectTimeout=10"
    
    if [ -n "$SSH_KEY" ]; then
        ssh_opts="$ssh_opts -i $SSH_KEY"
    fi
    
    # Check if WayVNC service is running
    if ssh $ssh_opts -p "$SSH_PORT" "$PI_USER@$PI_HOST" "systemctl is-active --quiet wayvnc.service" 2>/dev/null; then
        log "WayVNC service is running on remote host"
    else
        warning "WayVNC service may not be running on remote host"
    fi
    
    # Check if VNC port is listening
    if ssh $ssh_opts -p "$SSH_PORT" "$PI_USER@$PI_HOST" "netstat -tln 2>/dev/null | grep -q ':$REMOTE_PORT '" 2>/dev/null; then
        log "VNC port $REMOTE_PORT is listening on remote host"
    else
        warning "VNC port $REMOTE_PORT may not be listening on remote host"
    fi
}

# Create SSH tunnel
create_tunnel() {
    log "Creating SSH tunnel..."
    
    local ssh_opts="-L $LOCAL_PORT:localhost:$REMOTE_PORT -N"
    
    if [ -n "$SSH_KEY" ]; then
        ssh_opts="$ssh_opts -i $SSH_KEY"
    fi
    
    if [ "$VERBOSE" = true ]; then
        ssh_opts="$ssh_opts -v"
    fi
    
    if [ "$DAEMON" = true ]; then
        ssh_opts="$ssh_opts -f"
    fi
    
    local tunnel_cmd="ssh $ssh_opts -p $SSH_PORT $PI_USER@$PI_HOST"
    
    if [ "$VERBOSE" = true ]; then
        log "Executing: $tunnel_cmd"
    fi
    
    if [ "$DAEMON" = true ]; then
        # Run in background
        eval "$tunnel_cmd"
        local tunnel_pid=$!
        
        # Wait a moment for tunnel to establish
        sleep 2
        
        if kill -0 $tunnel_pid 2>/dev/null; then
            log "SSH tunnel started in background (PID: $tunnel_pid)"
            echo "$tunnel_pid" > /tmp/wayvnc_tunnel.pid
        else
            error "Failed to start SSH tunnel"
            exit 1
        fi
    else
        # Run in foreground
        log "SSH tunnel established. Press Ctrl+C to stop."
        log "Connect your VNC client to: localhost:$LOCAL_PORT"
        
        eval "$tunnel_cmd"
    fi
}

# Stop background tunnel
stop_tunnel() {
    local pid_file="/tmp/wayvnc_tunnel.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 $pid 2>/dev/null; then
            log "Stopping SSH tunnel (PID: $pid)..."
            kill $pid
            rm -f "$pid_file"
            log "SSH tunnel stopped"
        else
            log "SSH tunnel process not found"
            rm -f "$pid_file"
        fi
    else
        log "No background tunnel found"
    fi
}

# Show tunnel status
show_tunnel_status() {
    log "Tunnel Status:"
    echo "=============="
    echo "Local Port: $LOCAL_PORT"
    echo "Remote Host: $PI_USER@$PI_HOST:$SSH_PORT"
    echo "Remote Port: $REMOTE_PORT"
    echo "SSH Key: ${SSH_KEY:-'Default'}"
    echo ""
    
    # Check if local port is listening
    if check_port_availability "$LOCAL_PORT"; then
        echo "Local Port Status: ✗ Not listening"
    else
        echo "Local Port Status: ✓ Listening"
    fi
    
    # Check background tunnel
    local pid_file="/tmp/wayvnc_tunnel.pid"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 $pid 2>/dev/null; then
            echo "Background Tunnel: ✓ Running (PID: $pid)"
        else
            echo "Background Tunnel: ✗ Not running"
            rm -f "$pid_file"
        fi
    else
        echo "Background Tunnel: ✗ Not running"
    fi
}

# Create connection script
create_connection_script() {
    log "Creating connection script..."
    
    local script_dir="$HOME/.config/wayvnc"
    mkdir -p "$script_dir"
    
    cat > "$script_dir/connect_tunnel.sh" << EOF
#!/bin/bash
# Auto-generated WayVNC tunnel connection script

PI_HOST="$PI_HOST"
PI_USER="$PI_USER"
LOCAL_PORT="$LOCAL_PORT"
REMOTE_PORT="$REMOTE_PORT"
SSH_PORT="$SSH_PORT"
SSH_KEY="${SSH_KEY:-}"

echo "Connecting to WayVNC via SSH tunnel..."
echo "Host: \$PI_HOST"
echo "Local Port: \$LOCAL_PORT"
echo "Remote Port: \$REMOTE_PORT"
echo ""

# Create tunnel
ssh_opts="-L \$LOCAL_PORT:localhost:\$REMOTE_PORT -N"
if [ -n "\$SSH_KEY" ]; then
    ssh_opts="\$ssh_opts -i \$SSH_KEY"
fi

echo "Starting SSH tunnel..."
ssh \$ssh_opts -p \$SSH_PORT \$PI_USER@\$PI_HOST
EOF
    
    chmod +x "$script_dir/connect_tunnel.sh"
    log "Connection script created: $script_dir/connect_tunnel.sh"
}

# Create VNC client launcher
create_vnc_launcher() {
    log "Creating VNC client launcher..."
    
    local script_dir="$HOME/.config/wayvnc"
    mkdir -p "$script_dir"
    
    cat > "$script_dir/launch_vnc.sh" << 'EOF'
#!/bin/bash
# Launch VNC client to tunneled connection

LOCAL_PORT="${1:-5900}"

echo "Launching VNC client to localhost:$LOCAL_PORT..."

# Try different VNC clients
if command -v vinagre &> /dev/null; then
    echo "Using Vinagre VNC client..."
    vinagre "localhost:$LOCAL_PORT" &
elif command -v vncviewer &> /dev/null; then
    echo "Using VNC Viewer..."
    vncviewer "localhost:$LOCAL_PORT" &
elif command -v remmina &> /dev/null; then
    echo "Using Remmina..."
    remmina -c "vnc://localhost:$LOCAL_PORT" &
elif command -v realvnc-vnc-viewer &> /dev/null; then
    echo "Using RealVNC Viewer..."
    realvnc-vnc-viewer "localhost:$LOCAL_PORT" &
else
    echo "No VNC client found. Install one of:"
    echo "- vinagre (GNOME)"
    echo "- tigervnc-viewer"
    echo "- remmina"
    echo "- realvnc-vnc-viewer"
    echo ""
    echo "Or connect manually to: localhost:$LOCAL_PORT"
fi
EOF
    
    chmod +x "$script_dir/launch_vnc.sh"
    log "VNC launcher created: $script_dir/launch_vnc.sh"
}

# Main function
main() {
    parse_args "$@"
    
    log "WayVNC SSH Tunnel Setup"
    echo "======================="
    echo "Host: $PI_USER@$PI_HOST:$SSH_PORT"
    echo "Local Port: $LOCAL_PORT"
    echo "Remote Port: $REMOTE_PORT"
    echo "SSH Key: ${SSH_KEY:-'Default'}"
    echo ""
    
    check_dependencies
    
    if [ "$CHECK_ONLY" = true ]; then
        test_ssh_connection
        check_vnc_service
        show_tunnel_status
        exit 0
    fi
    
    # Check if local port is available
    if ! check_port_availability "$LOCAL_PORT"; then
        error "Local port $LOCAL_PORT is already in use"
        exit 1
    fi
    
    # Test SSH connection
    if ! test_ssh_connection; then
        error "Cannot establish SSH connection"
        exit 1
    fi
    
    # Check VNC service
    check_vnc_service
    
    # Create connection scripts
    create_connection_script
    create_vnc_launcher
    
    # Create tunnel
    create_tunnel
    
    log "Tunnel setup completed"
    echo ""
    echo "Connection Information:"
    echo "======================"
    echo "VNC URL: vnc://localhost:$LOCAL_PORT"
    echo "SSH Tunnel: $PI_USER@$PI_HOST:$SSH_PORT"
    echo ""
    echo "Quick Connect:"
    echo "1. Start tunnel: $HOME/.config/wayvnc/connect_tunnel.sh"
    echo "2. Launch VNC: $HOME/.config/wayvnc/launch_vnc.sh $LOCAL_PORT"
    echo ""
    echo "Manual Connection:"
    echo "Connect your VNC client to: localhost:$LOCAL_PORT"
}

# Handle signals
trap 'log "Received interrupt signal. Stopping tunnel..."; stop_tunnel; exit 0' INT TERM

# Run main function
main "$@" 