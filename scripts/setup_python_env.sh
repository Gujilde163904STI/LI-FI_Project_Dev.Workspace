#!/bin/bash

# Li-Fi Project Python Environment Setup Script
# This script sets up a proper Python environment for VS Code extensions

set -e

echo "🔧 Setting up Python environment for Li-Fi Project..."

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "⬆️ Upgrading pip..."
pip install --upgrade pip setuptools wheel

# Install essential Python packages
echo "📚 Installing Python development packages..."
pip install \
    black==25.1.0 \
    flake8==7.3.0 \
    pylint==3.3.7 \
    mypy==1.16.1 \
    pytest==8.0.0 \
    pytest-cov==4.1.0 \
    ipython==8.20.0 \
    jupyter==1.0.0 \
    requests==2.31.0 \
    numpy==1.26.0 \
    pandas==2.1.0 \
    matplotlib==3.8.0

# Install Li-Fi specific packages
echo "📡 Installing Li-Fi project dependencies..."
pip install \
    pyserial==3.5 \
    paho-mqtt==1.6.1 \
    websockets==12.0 \
    asyncio-mqtt==0.16.1 \
    fastapi==0.104.0 \
    uvicorn==0.24.0 \
    pydantic==2.5.0

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "🔐 Creating .env file..."
    cat > .env << EOF
# Li-Fi Project Environment Variables
PYTHONPATH=./docs
FLASK_ENV=development
DEBUG=True
EOF
fi

# Create typings directory for type stubs
mkdir -p typings

# Test the environment
echo "🧪 Testing Python environment..."
python test_python.py

echo ""
echo "✅ Python environment setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Restart VS Code to reload Python extension"
echo "2. Select Python interpreter: ./venv/bin/python"
echo "3. Test with: python test_python.py"
echo ""
echo "🔧 Available tools:"
echo "  - black: Code formatting"
echo "  - flake8: Linting"
echo "  - pylint: Advanced linting"
echo "  - mypy: Type checking"
echo "  - pytest: Testing"
echo ""
echo "💡 VS Code commands:"
echo "  - Cmd+Shift+P > Python: Select Interpreter"
echo "  - Cmd+Shift+P > Python: Restart Language Server"
