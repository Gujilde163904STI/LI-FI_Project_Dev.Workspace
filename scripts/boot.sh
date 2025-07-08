#!/usr/bin/env bash
set -e

# LI-FI Development Environment Boot Script
# Checks services, mounts volumes, starts UI, and opens browser

SERVICES=("coder.service" "wayvnc.service" "skaffold.service")
DOCKER_IMAGE="lifi-dev:latest"

echo "🚀 LI-FI Development Environment Boot Sequence"
echo "============================================="

# Function to check if service is running
check_service() {
    local service=$1
    if systemctl --user is-active --quiet "$service"; then
        echo "✅ $service is running"
        return 0
    else
        echo "❌ $service is not running"
        return 1
    fi
}

# Function to start service
start_service() {
    local service=$1
    echo "🔄 Starting $service..."
    systemctl --user start "$service"
    sleep 2
    if check_service "$service"; then
        echo "✅ $service started successfully"
    else
        echo "❌ Failed to start $service"
        return 1
    fi
}

# Check if Docker image exists
check_docker_image() {
    if docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
        echo "✅ Docker image $DOCKER_IMAGE exists"
        return 0
    else
        echo "❌ Docker image $DOCKER_IMAGE not found"
        echo "🔄 Building Docker image..."
        docker build -t "$DOCKER_IMAGE" .
        return $?
    fi
}

# Start Docker container if not running
start_docker_container() {
    local container_name="lifi-dev-boot"
    
    # Stop existing container if running
    docker stop "$container_name" 2>/dev/null || true
    docker rm "$container_name" 2>/dev/null || true
    
    echo "🔄 Starting Docker container..."
    docker run -d \
        --name "$container_name" \
        --privileged \
        -v /dev:/dev \
        -v "$(pwd):/workspace" \
        -v "$HOME/.cache:/workspace/.cache" \
        -p 5678:5678 \
        -p 8080:8080 \
        -p 5050:5050 \
        -p 7080:7080 \
        "$DOCKER_IMAGE" \
        tail -f /dev/null
    
    if docker ps | grep -q "$container_name"; then
        echo "✅ Docker container started successfully"
        return 0
    else
        echo "❌ Failed to start Docker container"
        return 1
    fi
}

# Start TUI Dashboard
start_tui_dashboard() {
    echo "🖥️  Starting TUI Dashboard..."
    if command -v python3 >/dev/null 2>&1; then
        python3 ./tools/tui/lifi_dashboard.py &
        echo "✅ TUI Dashboard started"
    else
        echo "⚠️  Python3 not found, skipping TUI Dashboard"
    fi
}

# Start Web UI
start_web_ui() {
    echo "🌐 Starting Web UI..."
    if command -v python3 >/dev/null 2>&1; then
        python3 ./tools/webui/app.py &
        sleep 3
        echo "✅ Web UI started at http://localhost:5050"
    else
        echo "⚠️  Python3 not found, skipping Web UI"
    fi
}

# Open browser to Coder or VNC
open_browser() {
    local platform=$(uname -s)
    
    # Wait for services to be ready
    sleep 5
    
    # Try to open Coder first
    if systemctl --user is-active --quiet coder.service; then
        echo "🌐 Opening Coder in browser..."
        case "$platform" in
            "Darwin")
                open http://localhost:7080
                ;;
            "Linux")
                xdg-open http://localhost:7080 2>/dev/null || sensible-browser http://localhost:7080
                ;;
            *)
                echo "⚠️  Please open http://localhost:7080 in your browser"
                ;;
        esac
    else
        echo "⚠️  Coder service not running, opening Web UI instead..."
        case "$platform" in
            "Darwin")
                open http://localhost:5050
                ;;
            "Linux")
                xdg-open http://localhost:5050 2>/dev/null || sensible-browser http://localhost:5050
                ;;
            *)
                echo "⚠️  Please open http://localhost:5050 in your browser"
                ;;
        esac
    fi
}

# Main boot sequence
main() {
    echo "🔍 Checking services..."
    local all_services_ok=true
    
    for service in "${SERVICES[@]}"; do
        if ! check_service "$service"; then
            echo "🔄 Attempting to start $service..."
            if ! start_service "$service"; then
                echo "❌ Failed to start $service"
                all_services_ok=false
            fi
        fi
    done
    
    if ! check_docker_image; then
        echo "❌ Docker image build failed"
        exit 1
    fi
    
    if ! start_docker_container; then
        echo "❌ Docker container start failed"
        exit 1
    fi
    
    start_tui_dashboard
    start_web_ui
    open_browser
    
    echo ""
    echo "🎉 LI-FI Development Environment is ready!"
    echo "📊 Services: $([ "$all_services_ok" = true ] && echo "All running" || echo "Some issues")"
    echo "🐳 Docker: Running"
    echo "🖥️  TUI: Available"
    echo "🌐 Web UI: http://localhost:5050"
    echo "💻 Coder: http://localhost:7080"
    echo ""
    echo "Use the following commands:"
    echo "  ./tools/tui/lifi_dashboard.py    # TUI Dashboard"
    echo "  ./tools/webui/app.py             # Web UI"
    echo "  docker exec -it lifi-dev-boot bash  # Container shell"
}

# Run main function
main 