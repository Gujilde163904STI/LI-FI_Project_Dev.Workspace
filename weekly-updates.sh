#!/bin/bash

# Weekly Container and Extension Update Script
# Automates updates for VS Code extensions and dev containers

echo "📅 Weekly Update Manager"
echo "======================="

# Configuration
LOG_FILE="$HOME/.weekly-updates.log"
CONTAINER_NAME="devcontainer"  # Adjust as needed

# Function to log messages
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

# Function to update VS Code extensions
update_vscode_extensions() {
    log_message "🔄 Updating VS Code extensions..."
    
    # Get list of installed extensions
    local extensions=$(code --list-extensions)
    local update_count=0
    
    if [ -n "$extensions" ]; then
        log_message "📋 Found $(echo "$extensions" | wc -l) extensions to check"
        
        # Update all extensions
        while IFS= read -r extension; do
            if [ -n "$extension" ]; then
                log_message "  Updating: $extension"
                code --install-extension "$extension" --force
                ((update_count++))
            fi
        done <<< "$extensions"
        
        log_message "✅ Updated $update_count extensions"
    else
        log_message "❌ No extensions found"
    fi
}

# Function to update dev containers
update_dev_containers() {
    log_message "🐳 Updating dev containers..."
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        log_message "❌ Docker is not running. Skipping container updates."
        return 1
    fi
    
    # Update base images for dev containers
    local images_updated=0
    
    # Common dev container base images
    local base_images=(
        "mcr.microsoft.com/vscode/devcontainers/base:ubuntu"
        "mcr.microsoft.com/vscode/devcontainers/python:3"
        "mcr.microsoft.com/vscode/devcontainers/javascript-node:16"
        "mcr.microsoft.com/vscode/devcontainers/cpp:ubuntu"
    )
    
    for image in "${base_images[@]}"; do
        if docker image inspect "$image" >/dev/null 2>&1; then
            log_message "  Updating image: $image"
            docker pull "$image"
            ((images_updated++))
        fi
    done
    
    # Update containers using devcontainer CLI if available
    if command -v devcontainer >/dev/null 2>&1; then
        log_message "🛠️  Running devcontainer updates..."
        
        # Find devcontainer.json files
        local devcontainer_configs=$(find . -name "devcontainer.json" -type f 2>/dev/null)
        
        if [ -n "$devcontainer_configs" ]; then
            while IFS= read -r config; do
                local dir=$(dirname "$config")
                log_message "  Updating devcontainer in: $dir"
                
                # Run apt update and upgrade in container
                devcontainer exec --workspace-folder "$dir" bash -c "
                    if command -v apt >/dev/null 2>&1; then
                        apt update && apt upgrade -y
                    elif command -v yum >/dev/null 2>&1; then
                        yum update -y
                    elif command -v apk >/dev/null 2>&1; then
                        apk update && apk upgrade
                    fi
                " 2>/dev/null || log_message "  ⚠️  Failed to update packages in $dir"
            done <<< "$devcontainer_configs"
        else
            log_message "  No devcontainer.json files found"
        fi
    else
        log_message "  devcontainer CLI not available, skipping container package updates"
    fi
    
    log_message "✅ Updated $images_updated base images"
}

# Function to cleanup old Docker images
cleanup_docker() {
    log_message "🧹 Cleaning up Docker resources..."
    
    if ! docker info >/dev/null 2>&1; then
        log_message "❌ Docker is not running. Skipping cleanup."
        return 1
    fi
    
    # Remove dangling images
    local dangling_images=$(docker images -f "dangling=true" -q)
    if [ -n "$dangling_images" ]; then
        log_message "  Removing dangling images..."
        docker rmi $dangling_images
    fi
    
    # Clean up unused containers, networks, and volumes
    docker system prune -f
    log_message "✅ Docker cleanup completed"
}

# Function to check system health
check_system_health() {
    log_message "🏥 Checking system health..."
    
    # Check available disk space
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 85 ]; then
        log_message "⚠️  WARNING: Disk usage is ${disk_usage}%"
    else
        log_message "✅ Disk usage: ${disk_usage}%"
    fi
    
    # Check memory usage
    local memory_info=$(sysctl vm.swapusage 2>/dev/null)
    if [ -n "$memory_info" ]; then
        log_message "💾 Memory: $memory_info"
    fi
    
    # Check for rogue processes
    local high_cpu_processes=$(ps aux | awk '$3 > 20 {print $2, $3, $11}' | head -5)
    if [ -n "$high_cpu_processes" ]; then
        log_message "⚠️  High CPU processes detected:"
        echo "$high_cpu_processes" | while read -r line; do
            log_message "    $line"
        done
    fi
}

# Function to create a scheduled update using cron
setup_cron_job() {
    local script_path="$(realpath "$0")"
    local cron_line="0 9 * * 0 $script_path run > /dev/null 2>&1"
    
    log_message "📅 Setting up weekly cron job..."
    
    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "$script_path"; then
        log_message "✅ Cron job already exists"
    else
        # Add cron job
        (crontab -l 2>/dev/null; echo "$cron_line") | crontab -
        log_message "✅ Added weekly cron job (Sundays at 9 AM)"
    fi
}

# Function to remove cron job
remove_cron_job() {
    local script_path="$(realpath "$0")"
    
    log_message "🗑️  Removing cron job..."
    
    crontab -l 2>/dev/null | grep -v "$script_path" | crontab -
    log_message "✅ Cron job removed"
}

# Function to run full update cycle
run_updates() {
    log_message "🚀 Starting weekly update cycle..."
    
    check_system_health
    update_vscode_extensions
    update_dev_containers
    cleanup_docker
    
    log_message "🎉 Weekly update cycle completed!"
}

# Function to show status
show_status() {
    echo "📊 Weekly Update Status"
    echo "======================"
    
    if [ -f "$LOG_FILE" ]; then
        echo "📋 Recent log entries:"
        tail -20 "$LOG_FILE"
    else
        echo "❌ No log file found"
    fi
    
    echo ""
    echo "⏰ Cron job status:"
    if crontab -l 2>/dev/null | grep -q "$(realpath "$0")"; then
        echo "✅ Scheduled updates are active"
        crontab -l | grep "$(realpath "$0")"
    else
        echo "❌ No scheduled updates found"
    fi
}

# Main menu
case "$1" in
    "run"|"--run")
        run_updates
        ;;
    "extensions"|"--extensions")
        update_vscode_extensions
        ;;
    "containers"|"--containers")
        update_dev_containers
        ;;
    "cleanup"|"--cleanup")
        cleanup_docker
        ;;
    "health"|"--health")
        check_system_health
        ;;
    "schedule"|"--schedule")
        setup_cron_job
        ;;
    "unschedule"|"--unschedule")
        remove_cron_job
        ;;
    "status"|"--status")
        show_status
        ;;
    *)
        echo "Usage: $0 [run|extensions|containers|cleanup|health|schedule|unschedule|status]"
        echo ""
        echo "Commands:"
        echo "  run         - Run full update cycle"
        echo "  extensions  - Update VS Code extensions only"
        echo "  containers  - Update dev containers only"
        echo "  cleanup     - Cleanup Docker resources"
        echo "  health      - Check system health"
        echo "  schedule    - Setup weekly cron job"
        echo "  unschedule  - Remove cron job"
        echo "  status      - Show current status"
        echo ""
        echo "Examples:"
        echo "  $0 run"
        echo "  $0 schedule"
        echo "  $0 status"
        ;;
esac
