#!/bin/bash
# Transfer LI-FI Project from macOS to Windows
# Run this script on macOS before sending to Windows client

echo "🚀 Preparing LI-FI Project for Windows Transfer"
echo "=============================================="

PROJECT_NAME="lifi_project_$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="${PROJECT_NAME}.tar.gz"

# Create a clean copy without macOS-specific files
echo "📁 Creating clean project copy..."
mkdir -p "../${PROJECT_NAME}"

# Copy essential files and directories
cp -r . "../${PROJECT_NAME}/" 2>/dev/null || true

# Remove macOS-specific files and directories from the copy
cd "../${PROJECT_NAME}"

echo "🧹 Cleaning macOS-specific files..."
find . -name ".DS_Store" -delete
find . -name "*.pyc" -delete
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
rm -rf .venv/ 2>/dev/null || true
rm -rf venv/ 2>/dev/null || true
rm -rf .pio/ 2>/dev/null || true
rm -rf build/ 2>/dev/null || true

# Create Windows-specific setup files
echo "🪟 Creating Windows-specific setup files..."

# Windows batch setup script
cat > setup_windows.bat << 'EOF'
@echo off
echo Setting up LI-FI Project on Windows...
echo =====================================

echo Installing Python dependencies...
pip install -r requirements.txt

echo Testing environment...
python setup_environment.py

echo Opening project in VS Code...
code LI-FI_Project_Dev.Workspace.code-workspace

echo.
echo Setup complete! Your LI-FI development environment is ready.
pause
EOF

# Windows PowerShell setup script
cat > setup_windows.ps1 << 'EOF'
Write-Host "Setting up LI-FI Project on Windows..." -ForegroundColor Green
Write-Host "======================================"

Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

Write-Host "Testing environment..." -ForegroundColor Yellow  
python setup_environment.py

Write-Host "Opening project in VS Code..." -ForegroundColor Yellow
code LI-FI_Project_Dev.Workspace.code-workspace

Write-Host ""
Write-Host "Setup complete! Your LI-FI development environment is ready." -ForegroundColor Green
Read-Host "Press Enter to continue"
EOF

# Update VS Code settings for Windows
echo "⚙️ Updating VS Code settings for Windows compatibility..."

# Create Windows-specific VS Code settings
python3 << 'EOF'
import json

# Load existing workspace file
try:
    with open('LI-FI_Project_Dev.Workspace.code-workspace', 'r') as f:
        workspace = json.load(f)
    
    # Update Python interpreter path for Windows
    workspace['settings']['python.defaultInterpreterPath'] = 'python'
    
    # Update Arduino path for Windows (common locations)
    workspace['settings']['arduino.path'] = 'C:\\Program Files (x86)\\Arduino'
    
    # Update compiler path for Windows
    workspace['settings']['C_Cpp.default.compilerPath'] = 'gcc'
    
    # Save updated workspace
    with open('LI-FI_Project_Dev.Workspace.code-workspace', 'w') as f:
        json.dump(workspace, f, indent=2)
    
    print("✅ Updated VS Code workspace for Windows")
    
except Exception as e:
    print(f"⚠️ Could not update VS Code workspace: {e}")
EOF

# Go back to parent directory
cd ..

# Create archive
echo "📦 Creating transfer archive..."
tar -czf "${ARCHIVE_NAME}" "${PROJECT_NAME}/"

# Calculate file size
SIZE=$(ls -lh "${ARCHIVE_NAME}" | awk '{print $5}')

echo ""
echo "✅ Transfer package created successfully!"
echo "📦 Archive: ${ARCHIVE_NAME}"
echo "💾 Size: ${SIZE}"
echo ""
echo "📋 Transfer Instructions:"
echo "1. Send ${ARCHIVE_NAME} to your Windows client"
echo "2. On Windows, extract with: tar -xzf ${ARCHIVE_NAME}"
echo "3. Run setup_windows.bat or setup_windows.ps1"
echo "4. Open VS Code with the .code-workspace file"
echo ""
echo "🔧 Windows Requirements:"
echo "- Python 3.8+ installed"
echo "- VS Code installed"
echo "- Git installed (recommended)"
echo "- ESP8266 USB drivers (CH340/CP2102)"

# Clean up
rm -rf "${PROJECT_NAME}/"

echo ""
echo "🎉 Ready for Windows deployment!"
