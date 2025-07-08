# LI-FI Project: Rebuild Docker Container Script (PowerShell)
# Rebuilds the development container with updated extensions and settings

param(
    [switch]$Force,
    [switch]$Verbose
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "🔧 LI-FI Project: Rebuilding Docker Container" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Success "Docker is running"
}
catch {
    Write-Error "Docker is not running. Please start Docker Desktop and try again."
    exit 1
}

# Get the workspace directory
$WorkspaceDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Write-Status "Workspace directory: $WorkspaceDir"

# Stop any running containers
Write-Status "Stopping any running LI-FI containers..."
try {
    docker stop li-fi-dev-container 2>$null
    docker rm li-fi-dev-container 2>$null
    Write-Success "Stopped existing containers"
}
catch {
    Write-Warning "No existing containers to stop"
}

# Remove old image
Write-Status "Removing old container image..."
try {
    docker rmi li-fi-dev:latest 2>$null
    Write-Success "Removed old image"
}
catch {
    Write-Warning "No old image to remove"
}

# Build new image
Write-Status "Building new container image..."
Set-Location $WorkspaceDir
try {
    docker build -f Dockerfile -t li-fi-dev:latest .
    Write-Success "Container image built successfully!"
}
catch {
    Write-Error "Failed to build container image."
    exit 1
}

# Run the new container
Write-Status "Starting new container..."
try {
    docker run -d `
        --name li-fi-dev-container `
        --privileged `
        -v /dev:/dev `
        -v "${WorkspaceDir}:/workspace" `
        -p 5678:5678 `
        -p 9229:9229 `
        -p 5901:5901 `
        li-fi-dev:latest
    
    Write-Success "Container started successfully!"
    $ContainerId = docker ps -q --filter name=li-fi-dev-container
    Write-Status "Container ID: $ContainerId"
    Write-Status "You can now connect to the container using VS Code Remote Containers extension."
}
catch {
    Write-Error "Failed to start container."
    exit 1
}

# Show container status
Write-Status "Container status:"
docker ps --filter name=li-fi-dev-container

Write-Host ""
Write-Success "Container rebuild complete!"
Write-Status "To connect to the container:"
Write-Host "  1. Open VS Code" -ForegroundColor White
Write-Host "  2. Press Ctrl+Shift+P" -ForegroundColor White
Write-Host "  3. Select 'Remote-Containers: Attach to Running Container'" -ForegroundColor White
Write-Host "  4. Choose 'li-fi-dev-container'" -ForegroundColor White
Write-Host ""
Write-Status "Or use the command:"
$ContainerId = docker ps -q --filter name=li-fi-dev-container
Write-Host "  code --folder-uri vscode-remote://attached-container+${ContainerId}/workspace" -ForegroundColor White 