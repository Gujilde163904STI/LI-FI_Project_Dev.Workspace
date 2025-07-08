# Li-Fi Project Python Environment Setup Script (PowerShell)
# This script sets up a proper Python environment for VS Code extensions

Write-Host "🔧 Setting up Python environment for Li-Fi Project..." -ForegroundColor Green

# Check if Python 3 is available
try {
    $pythonVersion = python3 --version 2>&1
    Write-Host "✅ Python 3 found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python 3 is not installed. Please install Python 3.8+ first." -ForegroundColor Red
    exit 1
}

# Create virtual environment if it doesn't exist
if (-not (Test-Path "venv")) {
    Write-Host "📦 Creating virtual environment..." -ForegroundColor Yellow
    python3 -m venv venv
}

# Activate virtual environment
Write-Host "🔌 Activating virtual environment..." -ForegroundColor Yellow
& "./venv/bin/Activate.ps1"

# Upgrade pip
Write-Host "⬆️ Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip setuptools wheel

# Install essential Python packages
Write-Host "📚 Installing Python development packages..." -ForegroundColor Yellow
pip install `
    black==25.1.0 `
    flake8==7.3.0 `
    pylint==3.3.7 `
    mypy==1.16.1 `
    pytest==8.0.0 `
    pytest-cov==4.1.0 `
    ipython==8.20.0 `
    jupyter==1.0.0 `
    requests==2.31.0 `
    numpy==1.26.0 `
    pandas==2.1.0 `
    matplotlib==3.8.0

# Install Li-Fi specific packages
Write-Host "📡 Installing Li-Fi project dependencies..." -ForegroundColor Yellow
pip install `
    pyserial==3.5 `
    paho-mqtt==1.6.1 `
    websockets==12.0 `
    asyncio-mqtt==0.16.1 `
    fastapi==0.104.0 `
    uvicorn==0.24.0 `
    pydantic==2.5.0

# Create .env file if it doesn't exist
if (-not (Test-Path ".env")) {
    Write-Host "🔐 Creating .env file..." -ForegroundColor Yellow
    @"
# Li-Fi Project Environment Variables
PYTHONPATH=./SCRIPTS:./docs
FLASK_ENV=development
DEBUG=True
"@ | Out-File -FilePath ".env" -Encoding UTF8
}

# Create typings directory for type stubs
if (-not (Test-Path "typings")) {
    New-Item -ItemType Directory -Path "typings" -Force | Out-Null
}

# Test the environment
Write-Host "🧪 Testing Python environment..." -ForegroundColor Yellow
python test_python.py

Write-Host ""
Write-Host "✅ Python environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code to reload Python extension"
Write-Host "2. Select Python interpreter: ./venv/bin/python"
Write-Host "3. Test with: python test_python.py"
Write-Host ""
Write-Host "🔧 Available tools:" -ForegroundColor Cyan
Write-Host "  - black: Code formatting"
Write-Host "  - flake8: Linting"
Write-Host "  - pylint: Advanced linting"
Write-Host "  - mypy: Type checking"
Write-Host "  - pytest: Testing"
Write-Host ""
Write-Host "💡 VS Code commands:" -ForegroundColor Cyan
Write-Host "  - Cmd+Shift+P > Python: Select Interpreter"
Write-Host "  - Cmd+Shift+P > Python: Restart Language Server" 