#!/bin/bash

# VS Code Performance Troubleshooting Script
# This script helps diagnose extension-related performance issues

echo "🔍 VS Code Performance Troubleshooting"
echo "======================================"

# Function to launch VS Code with disabled extensions
launch_safe_mode() {
    echo "📝 Launching VS Code with all extensions disabled..."
    code --disable-extensions "$@"
}

# Function to list installed extensions
list_extensions() {
    echo "📋 Currently installed extensions:"
    code --list-extensions | sort
}

# Function to enable extensions one by one
enable_extension() {
    local extension="$1"
    if [ -z "$extension" ]; then
        echo "❌ Please provide an extension ID"
        return 1
    fi
    
    echo "✅ Enabling extension: $extension"
    code --enable-extension "$extension"
}

# Function to disable specific extension
disable_extension() {
    local extension="$1"
    if [ -z "$extension" ]; then
        echo "❌ Please provide an extension ID"
        return 1
    fi
    
    echo "🚫 Disabling extension: $extension"
    code --disable-extension "$extension"
}

# Function to show performance tips
show_tips() {
    echo "💡 Performance Optimization Tips:"
    echo "  1. Start with safe mode: code --disable-extensions"
    echo "  2. Enable extensions one by one to identify culprits"
    echo "  3. Check for extensions with high CPU usage"
    echo "  4. Consider alternatives for heavy extensions"
    echo "  5. Regular extension updates help performance"
}

# Main menu
case "$1" in
    "safe"|"--safe")
        launch_safe_mode "${@:2}"
        ;;
    "list"|"--list")
        list_extensions
        ;;
    "enable"|"--enable")
        enable_extension "$2"
        ;;
    "disable"|"--disable")
        disable_extension "$2"
        ;;
    "tips"|"--tips")
        show_tips
        ;;
    *)
        echo "Usage: $0 [safe|list|enable|disable|tips] [extension-id]"
        echo ""
        echo "Commands:"
        echo "  safe     - Launch VS Code with all extensions disabled"
        echo "  list     - List all installed extensions"
        echo "  enable   - Enable specific extension"
        echo "  disable  - Disable specific extension"
        echo "  tips     - Show performance optimization tips"
        echo ""
        echo "Examples:"
        echo "  $0 safe"
        echo "  $0 list"
        echo "  $0 enable ms-python.python"
        echo "  $0 disable ms-python.python"
        ;;
esac
