#!/bin/bash

# Required extensions for LI-FI Embedded Development
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

echo "=== Installing Required Extensions ==="

# Get list of currently installed extensions
INSTALLED=$(code --list-extensions)

# Install required extensions
for ext in "${REQUIRED_EXTENSIONS[@]}"; do
    if echo "$INSTALLED" | grep -q "^$ext$"; then
        echo "✓ $ext already installed"
    else
        echo "Installing $ext..."
        code --install-extension "$ext"
    fi
done

echo "=== Extensions Setup Complete ==="
