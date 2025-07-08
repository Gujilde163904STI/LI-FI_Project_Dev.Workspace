# sync_to_github.ps1
# Sync both workspaces to remote GitHub repositories
# Platform: Windows

param(
    [string]$Username = "",
    [switch]$Split,
    [switch]$Help
)

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Show help if requested
if ($Help) {
    Write-Host "Usage: .\sync_to_github.ps1 [OPTIONS]"
    Write-Host "Options:"
    Write-Host "  -Username USERNAME    GitHub username"
    Write-Host "  -Split               Split into separate repositories"
    Write-Host "  -Help                Show this help message"
    exit 0
}

# Configuration
$MAIN_REPO_NAME = "LI-FI_Project_Dev.Workspace"
$SIM_REPO_NAME = "LI-FI_Project_Simulation.Workspace"

# Check if we're in the right directory
if (-not (Test-Path "LI-FI_Project_Dev.Workspace.code-workspace")) {
    Write-Error "Please run this script from the main workspace directory"
    exit 1
}

Write-Status "Starting GitHub sync process..."

# Check Git
try {
    $null = git --version
    Write-Success "Git found"
}
catch {
    Write-Error "Git not found. Please install Git first."
    exit 1
}

# Check GitHub CLI (optional)
try {
    $null = gh --version
    Write-Success "GitHub CLI found"
    $GITHUB_CLI_AVAILABLE = $true
}
catch {
    Write-Warning "GitHub CLI not found. Manual repository creation required."
    $GITHUB_CLI_AVAILABLE = $false
}

if ($Split) {
    Write-Status "Splitting workspaces into separate repositories..."
    
    # Create temporary directories for splitting
    $TEMP_DIR = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    $MAIN_TEMP = Join-Path $TEMP_DIR $MAIN_REPO_NAME
    $SIM_TEMP = Join-Path $TEMP_DIR $SIM_REPO_NAME
    
    # Create main workspace repository
    Write-Status "Preparing main workspace repository..."
    New-Item -ItemType Directory -Path $MAIN_TEMP -Force | Out-Null
    
    # Copy main workspace files (excluding simulation)
    $excludeItems = @(
        "simulation-workspace",
        ".git",
        "node_modules",
        "venv",
        "__pycache__"
    )
    
    Get-ChildItem -Path . -Exclude $excludeItems | Copy-Item -Destination $MAIN_TEMP -Recurse -Force
    
    # Create simulation workspace repository
    Write-Status "Preparing simulation workspace repository..."
    New-Item -ItemType Directory -Path $SIM_TEMP -Force | Out-Null
    
    # Copy simulation workspace files
    Copy-Item -Path "simulation-workspace\*" -Destination $SIM_TEMP -Recurse -Force
    
    # Add .gitignore files
    $mainGitignore = @"
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
.venv/
ENV/
env/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.cursor/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Build
build/
dist/
*.egg-info/

# Logs
*.log
logs/

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Archive
__archive/
rpi-custom-build/

# Simulation (excluded from main repo)
simulation-workspace/
"@
    
    $simGitignore = @"
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
.venv/
ENV/
env/

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.cursor/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Build
build/
dist/
*.egg-info/

# Logs
*.log
logs/

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
"@
    
    Set-Content -Path (Join-Path $MAIN_TEMP ".gitignore") -Value $mainGitignore
    Set-Content -Path (Join-Path $SIM_TEMP ".gitignore") -Value $simGitignore
    
    # Initialize Git repositories
    Write-Status "Initializing Git repositories..."
    
    # Main workspace
    Set-Location $MAIN_TEMP
    git init
    git add .
    git commit -m "Initial commit: Main development workspace v2-firmware-setup"
    
    # Simulation workspace
    Set-Location $SIM_TEMP
    git init
    git add .
    git commit -m "Initial commit: Simulation workspace v2-simulation-setup"
    
    # Create GitHub repositories if CLI is available
    if ($GITHUB_CLI_AVAILABLE -and $Username) {
        Write-Status "Creating GitHub repositories..."
        
        # Main repository
        Set-Location $MAIN_TEMP
        gh repo create "$Username/$MAIN_REPO_NAME" --public --description "LI-FI Project: Main Development Workspace for light-based TCP/IP communication using Raspberry Pi and ESP8266" --source=. --remote=origin --push
        
        # Simulation repository
        Set-Location $SIM_TEMP
        gh repo create "$Username/$SIM_REPO_NAME" --public --description "LI-FI Project: Simulation Workspace for testing and visualizing device behavior" --source=. --remote=origin --push
        
        Write-Success "GitHub repositories created and pushed!"
        Write-Host ""
        Write-Host "Main Repository: https://github.com/$Username/$MAIN_REPO_NAME"
        Write-Host "Simulation Repository: https://github.com/$Username/$SIM_REPO_NAME"
    }
    else {
        Write-Warning "Manual repository creation required:"
        Write-Host ""
        Write-Host "Main Repository:"
        Write-Host "  1. Create repository: $MAIN_REPO_NAME"
        Write-Host "  2. Push from: $MAIN_TEMP"
        Write-Host ""
        Write-Host "Simulation Repository:"
        Write-Host "  1. Create repository: $SIM_REPO_NAME"
        Write-Host "  2. Push from: $SIM_TEMP"
    }
    
    Set-Location $TEMP_DIR
    Write-Success "Split repositories prepared in: $TEMP_DIR"
    
}
else {
    Write-Status "Syncing as single repository..."
    
    # Check if Git repository exists
    if (-not (Test-Path ".git")) {
        Write-Status "Initializing Git repository..."
        git init
    }
    
    # Add all files
    git add .
    try {
        git commit -m "Update: v2-firmware-setup with workspace separation"
    }
    catch {
        Write-Warning "No changes to commit"
    }
    
    # Create GitHub repository if CLI is available
    if ($GITHUB_CLI_AVAILABLE -and $Username) {
        Write-Status "Creating GitHub repository..."
        gh repo create "$Username/$MAIN_REPO_NAME" --public --description "LI-FI Project: Complete development and simulation workspace for light-based TCP/IP communication" --source=. --remote=origin --push
        
        Write-Success "GitHub repository created and pushed!"
        Write-Host ""
        Write-Host "Repository: https://github.com/$Username/$MAIN_REPO_NAME"
    }
    else {
        Write-Warning "Manual repository creation required:"
        Write-Host "  1. Create repository: $MAIN_REPO_NAME"
        Write-Host "  2. Add remote: git remote add origin https://github.com/$Username/$MAIN_REPO_NAME.git"
        Write-Host "  3. Push: git push -u origin main"
    }
}

Write-Success "Sync process completed!"
Write-Host ""
Write-Host "📚 Next Steps:"
Write-Host "  1. Review the repositories on GitHub"
Write-Host "  2. Set up branch protection rules"
Write-Host "  3. Configure CI/CD workflows"
Write-Host "  4. Add collaborators if needed"
Write-Host ""
Write-Host "🔗 Documentation:"
Write-Host "  - Main workspace: docs\INTEGRATION_GUIDE.md"
Write-Host "  - Simulation workspace: simulation-workspace\README.md"
Write-Host "  - Version info: versioning.md" 