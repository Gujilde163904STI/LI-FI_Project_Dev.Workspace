#!/usr/bin/env bash
set -e

SERVICES=("coder.service" "wayvnc.service" "skaffold.service")
CONTAINERS=("lifi-dev" "esp8266" "rpi3" "rpi4")

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -s, --services       Reset systemd services only"
    echo "  -c, --containers     Reset Docker containers only"
    echo "  -l, --logs           Clear logs only"
    echo "  -a, --all            Full reset (default)"
    echo "  -f, --force          Force reset without prompts"
    echo "  -h, --help           Show this help"
}

RESET_SERVICES=false
RESET_CONTAINERS=false
CLEAR_LOGS=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--services)
            RESET_SERVICES=true
            shift
            ;;
        -c|--containers)
            RESET_CONTAINERS=true
            shift
            ;;
        -l|--logs)
            CLEAR_LOGS=true
            shift
            ;;
        -a|--all)
            RESET_SERVICES=true
            RESET_CONTAINERS=true
            CLEAR_LOGS=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Default to all if no specific options
if [[ "$RESET_SERVICES" == false && "$RESET_CONTAINERS" == false && "$CLEAR_LOGS" == false ]]; then
    RESET_SERVICES=true
    RESET_CONTAINERS=true
    CLEAR_LOGS=true
fi

reset_services() {
    echo "=== Resetting Systemd Services ==="
    for svc in "${SERVICES[@]}"; do
        echo "Stopping $svc..."
        systemctl --user stop "$svc" 2>/dev/null || true
        echo "Starting $svc..."
        systemctl --user start "$svc" 2>/dev/null || true
    done
    echo "Services reset complete."
}

reset_containers() {
    echo "=== Resetting Docker Containers ==="
    for container in "${CONTAINERS[@]}"; do
        echo "Stopping container $container..."
        docker stop "$container" 2>/dev/null || true
        echo "Removing container $container..."
        docker rm "$container" 2>/dev/null || true
    done
    
    # Clean up dangling images
    echo "Cleaning up dangling images..."
    docker image prune -f 2>/dev/null || true
    
    echo "Containers reset complete."
}

clear_logs() {
    echo "=== Clearing Logs ==="
    
    # Clear systemd logs
    for svc in "${SERVICES[@]}"; do
        echo "Clearing logs for $svc..."
        journalctl --user --vacuum-time=1s -u "$svc" 2>/dev/null || true
    done
    
    # Clear Docker logs
    echo "Clearing Docker logs..."
    sudo sh -c 'truncate -s 0 /var/lib/docker/containers/*/*-json.log' 2>/dev/null || true
    
    # Clear Skaffold logs
    echo "Clearing Skaffold logs..."
    rm -f ~/.skaffold/logs/* 2>/dev/null || true
    
    echo "Logs cleared."
}

main() {
    echo "LI-FI Development Reset"
    echo "======================"
    
    if [[ "$FORCE" == false ]]; then
        echo "This will reset:"
        [[ "$RESET_SERVICES" == true ]] && echo "  - Systemd services"
        [[ "$RESET_CONTAINERS" == true ]] && echo "  - Docker containers"
        [[ "$CLEAR_LOGS" == true ]] && echo "  - All logs"
        
        read -p "Continue? [y/N]: " yn
        if [[ ! "$yn" =~ ^[Yy]$ ]]; then
            echo "Reset cancelled."
            exit 0
        fi
    fi
    
    if [[ "$RESET_SERVICES" == true ]]; then
        reset_services
    fi
    
    if [[ "$RESET_CONTAINERS" == true ]]; then
        reset_containers
    fi
    
    if [[ "$CLEAR_LOGS" == true ]]; then
        clear_logs
    fi
    
    echo ""
    echo "[SUCCESS] Development environment reset complete!"
    echo "You can now start fresh builds or debug sessions."
}

main 