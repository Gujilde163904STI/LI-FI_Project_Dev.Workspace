#!/bin/bash

# Coder CLI Wrapper for LI-FI Project
# Provides easy access to Coder commands and configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
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

# Check if Coder is installed
check_coder_installation() {
    if ! command -v coder &> /dev/null; then
        error "Coder is not installed. Please run: ./tools/dev/coder_install.sh"
        exit 1
    fi
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [COMMAND] [OPTIONS]

Commands:
    server          Start Coder server
    local           Start local development server
    remote          Start remote development server
    login           Login to Coder instance
    logout          Logout from Coder instance
    workspace       Manage workspaces
    template        Manage templates
    user            Manage users
    status          Show Coder status
    config          Show/edit configuration
    logs            Show server logs
    service         Manage systemd service (Linux only)
    help            Show this help message

Examples:
    $0 server                    # Start Coder server
    $0 local                     # Start local development server
    $0 remote                    # Start remote development server
    $0 login https://coder.example.com
    $0 workspace list           # List workspaces
    $0 template list            # List templates
    $0 status                   # Show status
    $0 config show              # Show configuration
    $0 service enable           # Enable systemd service (Linux)

Environment Variables:
    CODER_CONFIG_DIR            Coder configuration directory
    CODER_DATA_DIR              Coder data directory
    CODER_BIN_DIR               Coder binary directory
EOF
}

# Start Coder server
start_server() {
    local config_file="$CODER_CONFIG_DIR/config.yaml"
    
    if [ -f "$config_file" ]; then
        log "Starting Coder server with configuration..."
        coder server --config "$config_file"
    else
        log "Starting Coder server with default configuration..."
        coder server
    fi
}

# Start local development server
start_local() {
    log "Starting Coder local development server..."
    echo "Access URL: http://localhost:8080"
    echo "Press Ctrl+C to stop"
    
    local config_file="$CODER_CONFIG_DIR/config.yaml"
    if [ -f "$config_file" ]; then
        coder server --config "$config_file" --address "localhost:8080"
    else
        coder server --address "localhost:8080"
    fi
}

# Start remote development server
start_remote() {
    log "Starting Coder remote development server..."
    echo "Access URL: http://0.0.0.0:8080"
    echo "Press Ctrl+C to stop"
    
    local config_file="$CODER_CONFIG_DIR/config.yaml"
    if [ -f "$config_file" ]; then
        coder server --config "$config_file" --address "0.0.0.0:8080"
    else
        coder server --address "0.0.0.0:8080"
    fi
}

# Login to Coder instance
login_coder() {
    local url="$1"
    
    if [ -z "$url" ]; then
        echo "Enter Coder instance URL:"
        read -r url
    fi
    
    log "Logging into Coder instance: $url"
    coder login "$url"
}

# Logout from Coder instance
logout_coder() {
    log "Logging out from Coder instance..."
    coder logout
}

# Manage workspaces
manage_workspaces() {
    local action="$1"
    
    case "$action" in
        "list")
            log "Listing workspaces..."
            coder workspace list
            ;;
        "create")
            log "Creating workspace..."
            coder workspace create
            ;;
        "delete")
            local workspace="$2"
            if [ -z "$workspace" ]; then
                echo "Enter workspace name to delete:"
                read -r workspace
            fi
            log "Deleting workspace: $workspace"
            coder workspace delete "$workspace"
            ;;
        "start")
            local workspace="$2"
            if [ -z "$workspace" ]; then
                echo "Enter workspace name to start:"
                read -r workspace
            fi
            log "Starting workspace: $workspace"
            coder workspace start "$workspace"
            ;;
        "stop")
            local workspace="$2"
            if [ -z "$workspace" ]; then
                echo "Enter workspace name to stop:"
                read -r workspace
            fi
            log "Stopping workspace: $workspace"
            coder workspace stop "$workspace"
            ;;
        *)
            echo "Workspace actions: list, create, delete, start, stop"
            echo "Usage: $0 workspace [action] [workspace_name]"
            ;;
    esac
}

# Manage templates
manage_templates() {
    local action="$1"
    
    case "$action" in
        "list")
            log "Listing templates..."
            coder template list
            ;;
        "create")
            log "Creating template..."
            coder template create
            ;;
        "delete")
            local template="$2"
            if [ -z "$template" ]; then
                echo "Enter template name to delete:"
                read -r template
            fi
            log "Deleting template: $template"
            coder template delete "$template"
            ;;
        *)
            echo "Template actions: list, create, delete"
            echo "Usage: $0 template [action] [template_name]"
            ;;
    esac
}

# Manage users
manage_users() {
    local action="$1"
    
    case "$action" in
        "list")
            log "Listing users..."
            coder user list
            ;;
        "create")
            log "Creating user..."
            coder user create
            ;;
        "delete")
            local user="$2"
            if [ -z "$user" ]; then
                echo "Enter username to delete:"
                read -r user
            fi
            log "Deleting user: $user"
            coder user delete "$user"
            ;;
        *)
            echo "User actions: list, create, delete"
            echo "Usage: $0 user [action] [username]"
            ;;
    esac
}

# Show Coder status
show_status() {
    log "Coder Status:"
    echo "============="
    
    # Check if Coder is installed
    if command -v coder &> /dev/null; then
        local version=$(coder version 2>/dev/null | head -1 || echo "unknown")
        echo "✓ Coder installed: $version"
    else
        echo "✗ Coder not installed"
        return 1
    fi
    
    # Check configuration
    if [ -f "$CODER_CONFIG_DIR/config.yaml" ]; then
        echo "✓ Configuration exists: $CODER_CONFIG_DIR/config.yaml"
    else
        echo "✗ Configuration not found"
    fi
    
    # Check if server is running
    if pgrep -f "coder server" > /dev/null; then
        echo "✓ Coder server is running"
    else
        echo "✗ Coder server is not running"
    fi
    
    # Check port availability
    if netstat -tln 2>/dev/null | grep -q ":8080 "; then
        echo "✓ Port 8080 is listening"
    else
        echo "✗ Port 8080 is not listening"
    fi
    
    # Show configuration summary
    if [ -f "$CODER_CONFIG_DIR/config.yaml" ]; then
        echo ""
        echo "Configuration Summary:"
        echo "====================="
        grep -E "^(address|access_url|tls_enable|log_level):" "$CODER_CONFIG_DIR/config.yaml" || echo "No configuration found"
    fi
}

# Show/edit configuration
manage_config() {
    local action="$1"
    
    case "$action" in
        "show")
            if [ -f "$CODER_CONFIG_DIR/config.yaml" ]; then
                log "Showing configuration:"
                cat "$CODER_CONFIG_DIR/config.yaml"
            else
                error "Configuration file not found: $CODER_CONFIG_DIR/config.yaml"
            fi
            ;;
        "edit")
            if [ -f "$CODER_CONFIG_DIR/config.yaml" ]; then
                log "Editing configuration..."
                ${EDITOR:-nano} "$CODER_CONFIG_DIR/config.yaml"
            else
                error "Configuration file not found: $CODER_CONFIG_DIR/config.yaml"
            fi
            ;;
        "backup")
            if [ -f "$CODER_CONFIG_DIR/config.yaml" ]; then
                local backup_file="$CODER_CONFIG_DIR/config.yaml.backup.$(date +%Y%m%d_%H%M%S)"
                cp "$CODER_CONFIG_DIR/config.yaml" "$backup_file"
                log "Configuration backed up to: $backup_file"
            else
                error "Configuration file not found"
            fi
            ;;
        "restore")
            local backup_file="$2"
            if [ -z "$backup_file" ]; then
                echo "Available backups:"
                ls -la "$CODER_CONFIG_DIR"/config.yaml.backup.* 2>/dev/null || echo "No backups found"
                echo "Enter backup file to restore:"
                read -r backup_file
            fi
            if [ -f "$backup_file" ]; then
                cp "$backup_file" "$CODER_CONFIG_DIR/config.yaml"
                log "Configuration restored from: $backup_file"
            else
                error "Backup file not found: $backup_file"
            fi
            ;;
        *)
            echo "Config actions: show, edit, backup, restore"
            echo "Usage: $0 config [action] [backup_file]"
            ;;
    esac
}

# Show server logs
show_logs() {
    log "Showing Coder server logs..."
    
    # Check if systemd service is running
    if systemctl is-active --quiet coder.service 2>/dev/null; then
        echo "Systemd service logs:"
        journalctl -u coder.service -f
    else
        echo "No systemd service found. Check for running coder processes:"
        ps aux | grep coder
    fi
}

# Manage systemd service (Linux only)
manage_service() {
    local action="$1"
    
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        error "Systemd service management is only available on Linux"
        return 1
    fi
    
    case "$action" in
        "enable")
            log "Enabling Coder systemd service..."
            sudo systemctl enable coder.service
            ;;
        "disable")
            log "Disabling Coder systemd service..."
            sudo systemctl disable coder.service
            ;;
        "start")
            log "Starting Coder systemd service..."
            sudo systemctl start coder.service
            ;;
        "stop")
            log "Stopping Coder systemd service..."
            sudo systemctl stop coder.service
            ;;
        "restart")
            log "Restarting Coder systemd service..."
            sudo systemctl restart coder.service
            ;;
        "status")
            log "Coder systemd service status:"
            sudo systemctl status coder.service
            ;;
        *)
            echo "Service actions: enable, disable, start, stop, restart, status"
            echo "Usage: $0 service [action]"
            ;;
    esac
}

# Main function
main() {
    check_coder_installation
    
    local command="$1"
    shift || true
    
    case "$command" in
        "server")
            start_server
            ;;
        "local")
            start_local
            ;;
        "remote")
            start_remote
            ;;
        "login")
            login_coder "$@"
            ;;
        "logout")
            logout_coder
            ;;
        "workspace")
            manage_workspaces "$@"
            ;;
        "template")
            manage_templates "$@"
            ;;
        "user")
            manage_users "$@"
            ;;
        "status")
            show_status
            ;;
        "config")
            manage_config "$@"
            ;;
        "logs")
            show_logs
            ;;
        "service")
            manage_service "$@"
            ;;
        "help"|"--help"|"-h")
            show_usage
            ;;
        "")
            show_usage
            ;;
        *)
            error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@" 