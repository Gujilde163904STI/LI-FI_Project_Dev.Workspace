#!/bin/bash
# Script to build the Raspberry Pi Manager package

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Clean up previous builds
rm -rf build/ dist/ *.egg-info/

# Install build dependencies if needed
pip install --upgrade pip setuptools wheel build

# Build the package
python -m build

echo "Package built successfully!"
echo "To install the package, run:"
echo "pip install dist/rpi_manager-*.whl"

# Make the script executable
chmod +x build_package.sh