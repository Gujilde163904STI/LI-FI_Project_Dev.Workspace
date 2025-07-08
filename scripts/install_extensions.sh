#!/bin/bash

# LI-FI Embedded Development - VS Code Extensions Installer (Mac/Linux)
# This script installs all required extensions for seamless Mac ↔ Windows development

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

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                LI-FI EMBEDDED DEVELOPMENT - EXTENSION INSTALLER              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "🎯 Target: Mac/Linux VS Code"
echo "📦 Extensions: ${#REQUIRED_EXTENSIONS[@]} required for LI-FI development"
echo ""

# Check if VS Code CLI is available
if ! command -v code >/dev/null 2>&1; then
    echo "❌ VS Code CLI not found!"
    echo "💡 Install VS Code command line tools:"
    echo "   1. Open VS Code"
    echo "   2. Press Cmd+Shift+P (Mac) or Ctrl+Shift+P (Linux)"
    echo "   3. Type 'Shell Command: Install code command in PATH'"
    echo "   4. Run this script again"
    exit 1
fi

echo "✅ VS Code CLI found: $(which code)"
echo ""

# Get list of currently installed extensions
echo "🔍 Checking currently installed extensions..."
INSTALLED=$(code --list-extensions)
INSTALLED_COUNT=$(echo "$INSTALLED" | wc -l)
echo "📊 Currently installed: $INSTALLED_COUNT extensions"
echo ""

# Install required extensions
echo "🚀 Installing required extensions..."
NEWLY_INSTALLED=0
ALREADY_INSTALLED=0

for ext in "${REQUIRED_EXTENSIONS[@]}"; do
    if echo "$INSTALLED" | grep -q "^$ext$"; then
        echo "✓ $ext (already installed)"
        ((ALREADY_INSTALLED++))
    else
        echo "⬇️  Installing $ext..."
        if code --install-extension "$ext" >/dev/null 2>&1; then
            echo "✅ $ext (installed successfully)"
            ((NEWLY_INSTALLED++))
        else
            echo "❌ $ext (installation failed)"
        fi
    fi
done

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                            INSTALLATION COMPLETE                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Summary:"
echo "   ✅ Already installed: $ALREADY_INSTALLED"
echo "   ⬇️  Newly installed: $NEWLY_INSTALLED"
echo "   📦 Total required: ${#REQUIRED_EXTENSIONS[@]}"
echo ""
echo "🔄 Sync Status: Mac extensions ready for Windows matching"
echo "🪟 Next step: Run install_extensions_windows.ps1 on Windows PC"
echo ""
echo "🎯 LI-FI Development Ready: Arduino, ESP8266, ESP32, Raspberry Pi"
