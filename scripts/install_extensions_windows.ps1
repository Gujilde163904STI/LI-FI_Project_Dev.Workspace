# Windows PowerShell script to install VS Code extensions for LI-FI Project
# Run this in PowerShell on Windows machine

Write-Host "=== Installing LI-FI Project Extensions on Windows ===" -ForegroundColor Green

$extensions = @(
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

foreach ($ext in $extensions) {
    Write-Host "Installing $ext..." -ForegroundColor Yellow
    code --install-extension $ext
}

Write-Host "=== Extension installation complete! ===" -ForegroundColor Green
Write-Host "Restart VS Code to activate all extensions." -ForegroundColor Cyan
