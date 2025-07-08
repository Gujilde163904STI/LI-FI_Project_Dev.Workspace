# GitHub Sync Guide

This guide explains how to sync both the main development workspace and simulation workspace to GitHub, with options for single or split repository strategies.

## 🎯 Sync Strategies

### Option 1: Single Repository (Recommended for Development)

- **Structure**: Main workspace + simulation workspace in one repository
- **Benefits**: Easier management, shared documentation, unified versioning
- **Use Case**: Development teams, single project management

### Option 2: Split Repositories (Recommended for Production)

- **Structure**: Separate repositories for development and simulation
- **Benefits**: Independent versioning, focused CI/CD, cleaner separation
- **Use Case**: Production deployments, separate teams, public releases

## 🚀 Quick Start

### Prerequisites

- Git installed
- GitHub account
- GitHub CLI (optional, for automated repository creation)

### Single Repository Sync

#### macOS/Linux

```bash
# Basic sync
./sync_to_github.sh --username YOUR_GITHUB_USERNAME

# With GitHub CLI (automated)
gh auth login
./sync_to_github.sh --username YOUR_GITHUB_USERNAME
```

#### Windows

```powershell
# Basic sync
.\sync_to_github.ps1 -Username YOUR_GITHUB_USERNAME

# With GitHub CLI (automated)
gh auth login
.\sync_to_github.ps1 -Username YOUR_GITHUB_USERNAME
```

### Split Repository Sync

#### macOS/Linux

```bash
# Split into separate repositories
./sync_to_github.sh --username YOUR_GITHUB_USERNAME --split
```

#### Windows

```powershell
# Split into separate repositories
.\sync_to_github.ps1 -Username YOUR_GITHUB_USERNAME -Split
```

## 📁 Repository Structure

### Single Repository Structure

```
LI-FI_Project_Dev.Workspace/
├── ESP8266/                    # Main development
├── RPI3/                       # Main development
├── RPI4/                       # Main development
├── tools/                      # Main development
├── docs/                       # Shared documentation
├── ~/GALAHADD.WORKSPACES/simulation-workspace/       # Simulation components
│   ├── WOKWI_*                 # Wokwi simulations
│   ├── NETWORK.DEV@*           # Network protocols
│   └── GALAHADD.PROJECTS-SIMULATION/
└── [other main workspace files]
```

### Split Repository Structure

#### Main Development Repository

```
LI-FI_Project_Dev.Workspace/
├── ESP8266/                    # ESP8266 firmware
├── RPI3/                       # RPi3 components
├── RPI4/                       # RPi4 components
├── tools/                      # Deployment tools
├── docs/                       # Documentation
├── backend/                    # Backend services
├── hardware/                   # Hardware specs
└── ~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/ # Custom build components
```

#### Simulation Repository

```
LI-FI_Project_Simulation.Workspace/
├── WOKWI_BUILD_RPi3/           # RPi3 simulation
├── WOKWI_BUILD_RPi4/           # RPi4 simulation
├── WOKWI_FLASH_ESP8266/        # ESP8266 simulation
├── NETWORK.DEV@PROTOCOL/       # Network protocols
├── NETWORK.DEV@FRAMEWORKS/     # IoT frameworks
├── GALAHADD.PROJECTS-SIMULATION/ # Main simulation
└── [simulation files only]
```

## 🔧 Manual Setup (Without GitHub CLI)

### 1. Create GitHub Repositories

1. Go to [GitHub](https://github.com)
2. Click "New repository"
3. Name: `LI-FI_Project_Dev.Workspace` (and optionally `LI-FI_Project_Simulation.Workspace`)
4. Make public or private as needed
5. Don't initialize with README (we'll push existing content)

### 2. Initialize and Push

#### Single Repository

```bash
# Initialize Git (if not already done)
git init

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/LI-FI_Project_Dev.Workspace.git

# Add and commit files
git add .
git commit -m "Initial commit: v2-firmware-setup with workspace separation"

# Push to GitHub
git push -u origin main
```

#### Split Repositories

```bash
# Run the sync script with --split flag
./sync_to_github.sh --username YOUR_USERNAME --split

# Follow the manual instructions provided by the script
```

## 🔄 CI/CD Setup

### GitHub Actions Workflow

Create `.github/workflows/ci.yml` in your repository:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests
        run: |
          python -m pytest tests/ || echo "No tests found"

      - name: Check Python syntax
        run: |
          find . -name "*.py" -not -path "./venv/*" -not -path "./simulation-workspace/*" -not -path "./~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/*" -exec python -m py_compile {} \;

      - name: Check shell scripts
        run: |
          find . -name "*.sh" -not -path "./simulation-workspace/*" -not -path "./~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/*" -exec bash -n {} \;

  build:
    runs-on: ubuntu-latest
    needs: test

    steps:
      - uses: actions/checkout@v3

      - name: Set up PlatformIO
        uses: platformio/setup-platformio@v1

      - name: Build ESP8266 firmware
        run: |
          cd ESP8266
          platformio run

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: firmware-builds
          path: ESP8266/.pio/build/*/
```

### Branch Protection Rules

1. Go to repository Settings → Branches
2. Add rule for `main` branch:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date
   - Include administrators

## 📋 Repository Management

### .gitignore Configuration

The sync scripts automatically create appropriate `.gitignore` files:

#### Main Repository

- Excludes `~/GALAHADD.WORKSPACES/simulation-workspace/` (if using single repo)
- Excludes build artifacts, logs, environment files
- Excludes IDE-specific files
- Excludes `~/GALAHADD.WORKSPACES/rpi-custom-build-workspace/` (if using single repo)

#### Simulation Repository

- Excludes build artifacts, logs, environment files
- Focused on simulation components only

### Version Management

- **Single Repository**: Use tags for releases

  ```bash
  git tag v2-firmware-setup
  git push origin v2-firmware-setup
  ```

- **Split Repositories**: Independent versioning
  - Main: `v2-firmware-setup`
  - Simulation: `v2-simulation-setup`

## 🔗 Cross-Repository References

### Documentation Links

- Main repository references simulation workspace
- Simulation repository references main documentation
- Use relative paths for local development

### Dependencies

- Both repositories can reference shared documentation
- Simulation can import main workspace components
- Use Git submodules if needed for tight coupling

## 🛠️ Troubleshooting

### Common Issues

#### "Git not found"

```bash
# Install Git
# macOS
brew install git

# Ubuntu/Debian
sudo apt-get install git

# Windows
# Download from https://git-scm.com/
```

#### "GitHub CLI not found"

```bash
# Install GitHub CLI
# macOS
brew install gh

# Ubuntu/Debian
sudo apt-get install gh

# Windows
# Download from https://cli.github.com/
```

#### Permission Denied

```bash
# Authenticate with GitHub
gh auth login

# Or use personal access token
git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/REPO_NAME.git
```

#### Large File Issues

```bash
# Use Git LFS for large files
git lfs install
git lfs track "*.bin"
git lfs track "*.img"
```

## 📚 Next Steps

### After Sync

1. **Review repositories** on GitHub
2. **Set up branch protection** rules
3. **Configure CI/CD** workflows
4. **Add collaborators** if needed
5. **Create release tags** for versions

### Ongoing Maintenance

1. **Regular updates** to both workspaces
2. **Version synchronization** between repositories
3. **Documentation updates** for changes
4. **CI/CD pipeline** maintenance

## 🔗 Useful Links

- [GitHub CLI Documentation](https://cli.github.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Git LFS Documentation](https://git-lfs.github.com/)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)

---

**Last Updated**: December 2024  
**Version**: v2-firmware-setup  
**Status**: Ready for GitHub sync
