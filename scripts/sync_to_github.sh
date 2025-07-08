#!/bin/bash
# sync_to_github.sh
# Sync both workspaces to remote GitHub repositories
# Platform: macOS/Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
MAIN_REPO_NAME="LI-FI_Project_Dev.Workspace"
SIM_REPO_NAME="LI-FI_Project_Simulation.Workspace"
GITHUB_USERNAME=""
SPLIT_REPOS=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --username)
            GITHUB_USERNAME="$2"
            shift 2
            ;;
        --split)
            SPLIT_REPOS=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --username USERNAME    GitHub username"
            echo "  --split               Split into separate repositories"
            echo "  --help                Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if we're in the right directory
if [ ! -f "LI-FI_Project_Dev.Workspace.code-workspace" ]; then
    print_error "Please run this script from the main workspace directory"
    exit 1
fi

print_status "Starting GitHub sync process..."

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git not found. Please install Git first."
    exit 1
fi

# Check GitHub CLI (optional)
if command -v gh &> /dev/null; then
    print_success "GitHub CLI found"
    GITHUB_CLI_AVAILABLE=true
else
    print_warning "GitHub CLI not found. Manual repository creation required."
    GITHUB_CLI_AVAILABLE=false
fi

if [ "$SPLIT_REPOS" = true ]; then
    print_status "Splitting workspaces into separate repositories..."
    
    # Create temporary directories for splitting
    TEMP_DIR=$(mktemp -d)
    MAIN_TEMP="$TEMP_DIR/$MAIN_REPO_NAME"
    SIM_TEMP="$TEMP_DIR/$SIM_REPO_NAME"
    
    # Create main workspace repository
    print_status "Preparing main workspace repository..."
    mkdir -p "$MAIN_TEMP"
    
    # Copy main workspace files (excluding simulation)
    rsync -av --exclude='simulation-workspace/' --exclude='rpi-custom-build-workspace/' --exclude='.git/' --exclude='node_modules/' --exclude='venv/' --exclude='__pycache__/' . "$MAIN_TEMP/"
    
    # Create simulation workspace repository
    print_status "Preparing simulation workspace repository..."
    mkdir -p "$SIM_TEMP"
    
    # Copy simulation workspace files
    rsync -av ~/GALAHADD.WORKSPACES/simulation-workspace/ "$SIM_TEMP/"
    
    # Add .gitignore files
    cat > "$MAIN_TEMP/.gitignore" << 'EOF'
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
rpi-custom-build-workspace/
EOF

    cat > "$SIM_TEMP/.gitignore" << 'EOF'
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
EOF

    # Initialize Git repositories
    print_status "Initializing Git repositories..."
    
    # Main workspace
    cd "$MAIN_TEMP"
    git init
    git add .
    git commit -m "Initial commit: Main development workspace v2-firmware-setup"
    
    # Simulation workspace
    cd "$SIM_TEMP"
    git init
    git add .
    git commit -m "Initial commit: Simulation workspace v2-simulation-setup"
    
    # Create GitHub repositories if CLI is available
    if [ "$GITHUB_CLI_AVAILABLE" = true ] && [ -n "$GITHUB_USERNAME" ]; then
        print_status "Creating GitHub repositories..."
        
        # Main repository
        cd "$MAIN_TEMP"
        gh repo create "$GITHUB_USERNAME/$MAIN_REPO_NAME" --public --description "LI-FI Project: Main Development Workspace for light-based TCP/IP communication using Raspberry Pi and ESP8266" --source=. --remote=origin --push
        
        # Simulation repository
        cd "$SIM_TEMP"
        gh repo create "$GITHUB_USERNAME/$SIM_REPO_NAME" --public --description "LI-FI Project: Simulation Workspace for testing and visualizing device behavior" --source=. --remote=origin --push
        
        print_success "GitHub repositories created and pushed!"
        echo ""
        echo "Main Repository: https://github.com/$GITHUB_USERNAME/$MAIN_REPO_NAME"
        echo "Simulation Repository: https://github.com/$GITHUB_USERNAME/$SIM_REPO_NAME"
    else
        print_warning "Manual repository creation required:"
        echo ""
        echo "Main Repository:"
        echo "  1. Create repository: $MAIN_REPO_NAME"
        echo "  2. Push from: $MAIN_TEMP"
        echo ""
        echo "Simulation Repository:"
        echo "  1. Create repository: $SIM_REPO_NAME"
        echo "  2. Push from: $SIM_TEMP"
    fi
    
    cd "$TEMP_DIR"
    print_success "Split repositories prepared in: $TEMP_DIR"
    
else
    print_status "Syncing as single repository..."
    
    # Check if Git repository exists
    if [ ! -d ".git" ]; then
        print_status "Initializing Git repository..."
        git init
    fi
    
    # Add all files
    git add .
    git commit -m "Update: v2-firmware-setup with workspace separation" || print_warning "No changes to commit"
    
    # Create GitHub repository if CLI is available
    if [ "$GITHUB_CLI_AVAILABLE" = true ] && [ -n "$GITHUB_USERNAME" ]; then
        print_status "Creating GitHub repository..."
        gh repo create "$GITHUB_USERNAME/$MAIN_REPO_NAME" --public --description "LI-FI Project: Complete development and simulation workspace for light-based TCP/IP communication" --source=. --remote=origin --push
        
        print_success "GitHub repository created and pushed!"
        echo ""
        echo "Repository: https://github.com/$GITHUB_USERNAME/$MAIN_REPO_NAME"
    else
        print_warning "Manual repository creation required:"
        echo "  1. Create repository: $MAIN_REPO_NAME"
        echo "  2. Add remote: git remote add origin https://github.com/$GITHUB_USERNAME/$MAIN_REPO_NAME.git"
        echo "  3. Push: git push -u origin main"
    fi
fi

print_success "Sync process completed!"
echo ""
echo "📚 Next Steps:"
echo "  1. Review the repositories on GitHub"
echo "  2. Set up branch protection rules"
echo "  3. Configure CI/CD workflows"
echo "  4. Add collaborators if needed"
echo ""
echo "🔗 Documentation:"
echo "  - Main workspace: docs/INTEGRATION_GUIDE.md"
echo "  - Simulation workspace: ~/GALAHADD.WORKSPACES/simulation-workspace/README.md"
echo "  - Version info: versioning.md" 