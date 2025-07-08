#!/bin/bash

# Install formatter tooling for Li-Fi Project
# This script installs all necessary formatters for different file types

set -e

echo "🔧 Installing formatter tooling for Li-Fi Project..."

# Install Python formatters
echo "📦 Installing Python formatters..."
pip install black isort

# Install Node.js formatters (if npm is available)
if command -v npm &> /dev/null; then
    echo "📦 Installing Node.js formatters..."
    npm install --save-dev prettier prettier-plugin-yaml
else
    echo "⚠️  npm not found, skipping Node.js formatters"
fi

# Install shell formatter (optional)
if command -v go &> /dev/null; then
    echo "📦 Installing shfmt (shell formatter)..."
    go install mvdan.cc/sh/v3/cmd/shfmt@latest
else
    echo "⚠️  Go not found, skipping shfmt installation"
    echo "   You can install shfmt manually: go install mvdan.cc/sh/v3/cmd/shfmt@latest"
fi

# Install clang-format (if not already installed)
if ! command -v clang-format &> /dev/null; then
    echo "📦 Installing clang-format..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install clang-format
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y clang-format
    else
        echo "⚠️  Please install clang-format manually for your OS"
    fi
else
    echo "✅ clang-format already installed"
fi

echo "✅ Formatter installation complete!"
echo ""
echo "📋 Available formatters:"
echo "  • Python: black, isort"
echo "  • JavaScript/JSON/YAML: prettier"
echo "  • C++/Arduino: clang-format"
echo "  • Shell: shfmt (if installed)"
echo ""
echo "🚀 Usage:"
echo "  • Python: black . && isort ."
echo "  • JS/JSON/YAML: npx prettier --write ."
echo "  • C++: clang-format -i **/*.{cpp,h,c}"
echo "  • Shell: shfmt -w **/*.sh" 