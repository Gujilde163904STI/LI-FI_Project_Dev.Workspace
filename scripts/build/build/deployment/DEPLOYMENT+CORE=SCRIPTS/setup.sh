#!/bin/bash
# scripts/setup.sh
# Project environment setup script
#
# Usage:
#   bash scripts/setup.sh

# Set up Python venv in workspace root
cd "$(dirname "$0")/.."

echo "🔧 Setting up LI-FI Project environment..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

if [ ! -d "venv" ]; then
  python3 -m venv venv
  echo "✅ Virtual environment created."
fi

source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Inform about serial permissions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "⚠️ Ensure serial permissions:"
  echo "👉 sudo usermod -a -G dialout $USER && reboot"
fi

echo "✅ Setup complete!"