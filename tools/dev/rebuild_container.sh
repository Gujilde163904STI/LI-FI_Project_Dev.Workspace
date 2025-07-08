#!/bin/bash

# LI-FI Project: Rebuild Docker Container Script
# Rebuilds the development container with updated extensions and settings

set -e

echo "🔧 LI-FI Project: Rebuilding Docker Container"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Get the workspace directory
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
print_status "Workspace directory: $WORKSPACE_DIR"

# Stop any running containers
print_status "Stopping any running LI-FI containers..."
docker stop li-fi-dev-container 2>/dev/null || true
docker rm li-fi-dev-container 2>/dev/null || true

# Remove old image
print_status "Removing old container image..."
docker rmi li-fi-dev:latest 2>/dev/null || true

# Build new image
print_status "Building new container image..."
cd "$WORKSPACE_DIR"
docker build -f Dockerfile -t li-fi-dev:latest .

if [ $? -eq 0 ]; then
    print_success "Container image built successfully!"
else
    print_error "Failed to build container image."
    exit 1
fi

# Run the new container
print_status "Starting new container..."
docker run -d \
    --name li-fi-dev-container \
    --privileged \
    -v /dev:/dev \
    -v "$WORKSPACE_DIR:/workspace" \
    -p 5678:5678 \
    -p 9229:9229 \
    -p 5901:5901 \
    li-fi-dev:latest

if [ $? -eq 0 ]; then
    print_success "Container started successfully!"
    print_status "Container ID: $(docker ps -q --filter name=li-fi-dev-container)"
    print_status "You can now connect to the container using VS Code Remote Containers extension."
else
    print_error "Failed to start container."
    exit 1
fi

# Show container status
print_status "Container status:"
docker ps --filter name=li-fi-dev-container

echo ""
print_success "Container rebuild complete!"
print_status "To connect to the container:"
echo "  1. Open VS Code"
echo "  2. Press Ctrl+Shift+P"
echo "  3. Select 'Remote-Containers: Attach to Running Container'"
echo "  4. Choose 'li-fi-dev-container'"
echo ""
print_status "Or use the command:"
echo "  code --folder-uri vscode-remote://attached-container+$(docker ps -q --filter name=li-fi-dev-container)/workspace" 