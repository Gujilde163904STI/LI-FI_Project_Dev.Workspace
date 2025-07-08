#!/bin/bash

# Extension Sync Script - generates commands for Windows
# This creates a PowerShell script for Windows to install the same extensions

REQUIRED_EXTENSIONS=(
    "ms-python.python"
    "ms-vscode.cpptools"
    "platformio.platformio-ide"
    "espressif.esp-idf-extension"
    "esbenp.prettier-vscode"
    "streetsidesoftware.code-spell-checker"
    "redhat.vscode-yaml"
    "github.copilot"
    "github.copilot-chat"
    "ms-azuretools.vscode-docker"
    "detachhead.basedpyright"
    "charliermarsh.ruff"
    "dankeboy36.vscode-arduino-api"
    "davescodemusings.esptool"
)

echo "=== Generating Windows Extension Install Script ==="

cat > scripts/install_extensions_windows.ps1 << 'EOF'
# Windows PowerShell script to install VS Code extensions for LI-FI Project
# Run this in PowerShell on Windows machine

Write-Host "=== Installing LI-FI Project Extensions on Windows ===" -ForegroundColor Green

$extensions = @(
EOF

for ext in "${REQUIRED_EXTENSIONS[@]}"; do
    echo "    \"$ext\"" >> scripts/install_extensions_windows.ps1
done

cat >> scripts/install_extensions_windows.ps1 << 'EOF'
)

foreach ($ext in $extensions) {
    Write-Host "Installing $ext..." -ForegroundColor Yellow
    code --install-extension $ext
}

Write-Host "=== Extension installation complete! ===" -ForegroundColor Green
Write-Host "Restart VS Code to activate all extensions." -ForegroundColor Cyan
EOF

echo "✅ Created scripts/install_extensions_windows.ps1"
echo "Copy this file to your Windows machine and run it in PowerShell."
