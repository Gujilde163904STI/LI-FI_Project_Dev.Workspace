#!/bin/bash

# Fix extension issues and provide guidance
echo "🔧 Fixing extension issues..."

# Check if we're in a VS Code workspace
if [ -f ".vscode/settings.json" ]; then
    echo "📁 Found VS Code workspace settings"
    
    # Create a backup of current settings
    cp .vscode/settings.json .vscode/settings.json.backup
    
    # Add Python extension configuration to fix Kylin Python issues
    cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.black-formatter",
        "ms-python.flake8"
    ],
    "unwantedRecommendations": [
        "kylin.python"
    ]
}
EOF

    echo "✅ Created extensions.json with recommended Python extensions"
    echo "❌ Added kylin.python to unwanted recommendations"
fi

# Check for Python environment
echo ""
echo "🐍 Checking Python environment..."
if command -v python3 &> /dev/null; then
    echo "✅ Python3 found: $(python3 --version)"
else
    echo "❌ Python3 not found"
fi

if command -v pip3 &> /dev/null; then
    echo "✅ pip3 found: $(pip3 --version)"
else
    echo "❌ pip3 not found"
fi

# Create a Python environment setup script
cat > setup_python_env.sh << 'EOF'
#!/bin/bash

# Setup Python environment for Li-Fi project
echo "🐍 Setting up Python environment for Li-Fi project..."

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source .venv/bin/activate

# Install required packages
echo "📥 Installing required packages..."
pip install --upgrade pip
pip install -r requirements.txt 2>/dev/null || echo "No requirements.txt found"

# Install development tools
echo "🛠️ Installing development tools..."
pip install black flake8 pylint pytest

echo ""
echo "✅ Python environment setup complete!"
echo ""
echo "💡 To activate the environment:"
echo "   source .venv/bin/activate"
echo ""
echo "💡 To deactivate the environment:"
echo "   deactivate"
echo ""
echo "🔧 VS Code Python extension should now work correctly"
EOF

chmod +x setup_python_env.sh

# Create a basic requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    cat > requirements.txt << 'EOF'
# Li-Fi Project Python Dependencies
# Core dependencies
numpy>=1.21.0
scipy>=1.7.0

# IoT and hardware
RPi.GPIO>=0.7.0
pyserial>=3.5

# Development tools
black>=21.0.0
flake8>=3.9.0
pylint>=2.8.0
pytest>=6.0.0

# Documentation
sphinx>=4.0.0
sphinx-rtd-theme>=0.5.0
EOF

    echo "✅ Created requirements.txt with basic dependencies"
fi

echo ""
echo "🎉 Extension fixes completed!"
echo ""
echo "📝 Summary of fixes:"
echo "- Created .vscode/extensions.json with recommended extensions"
echo "- Added kylin.python to unwanted recommendations"
echo "- Created setup_python_env.sh for Python environment setup"
echo "- Created requirements.txt with basic dependencies"
echo ""
echo "🚀 Next steps:"
echo "1. Run: ./setup_python_env.sh"
echo "2. Restart VS Code/Cursor"
echo "3. The Kylin Python extension should be disabled"
echo "4. Use the recommended Python extensions instead"
echo ""
echo "🔧 If you still have issues:"
echo "- Disable the Kylin Python extension manually in VS Code"
echo "- Install the Microsoft Python extension instead"
echo "- Run: source .venv/bin/activate to use the virtual environment" 