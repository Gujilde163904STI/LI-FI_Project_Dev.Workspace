#!/bin/bash

# LI-FI Project Configuration Summary Report
# Run this to get complete status of your development environment

PROJECT_DIR="/Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace"
cd "$PROJECT_DIR" || exit 1

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                      LI-FI EMBEDDED PROJECT SETUP SUMMARY                   ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "🎯 ROLE: Mac = Main Dev HQ | Windows = Flash + Hardware Runner"
echo "📂 PROJECT: $PROJECT_DIR"
echo ""

echo "═══ GIT CONFIGURATION ═══"
echo "📍 User: $(git config user.name) <$(git config user.email)>"
echo "📍 Remote: $(git remote get-url origin)"
echo "📍 Branch: $(git branch --show-current)"
echo "📍 Status: $(git status --porcelain | wc -l | tr -d ' ') uncommitted changes"
echo ""

echo "═══ GIT LFS TRACKED FILES ═══"
if [ -f .gitattributes ]; then
    grep "filter=lfs" .gitattributes | head -5
    echo "  ... ($(grep -c "filter=lfs" .gitattributes) total LFS file types)"
else
    echo "❌ No .gitattributes file found"
fi
echo ""

echo "═══ DEVELOPMENT TOOLS ═══"
echo "🐍 Python: $(python3 --version 2>/dev/null || echo "Not found")"
echo "📦 Node.js: $(node --version 2>/dev/null || echo "Not found")"
echo "🔥 Git: $(git --version)"
echo "🔥 Firebase: $(which firebase >/dev/null && firebase --version | head -1 || echo "Not installed")"
echo "⚡ PlatformIO: $(platformio --version 2>/dev/null || echo "Not installed")"
echo "🐳 Docker: $(docker --version 2>/dev/null || echo "Not installed (disabled on Mac)")"
echo ""

echo "═══ TERMINAL CONFIGURATION ═══"
echo "🖥️  Default Shell: $SHELL"
echo "🖥️  Terminal Profile: $(grep -A 2 'terminal.integrated.defaultProfile.osx' .vscode/settings.json 2>/dev/null | grep -o '"[^"]*"' | head -1 || echo "Not configured")"
echo "🖥️  Renderer: $(grep 'terminal.integrated.rendererType' .vscode/settings.json 2>/dev/null | grep -o '"[^"]*"' | tail -1 || echo "Default")"
echo ""

echo "═══ VS CODE EXTENSIONS ═══"
echo "📦 Installed Extensions:"
if command -v code >/dev/null; then
    code --list-extensions | grep -E "(python|cpp|platformio|esp|prettier|spell|yaml|copilot|docker|ruff|arduino)" | head -10
    echo "  ... ($(code --list-extensions | wc -l | tr -d ' ') total extensions)"
else
    echo "❌ VS Code CLI not available"
fi
echo ""

echo "═══ PROJECT SCRIPTS ═══"
echo "🔄 Available Scripts:"
ls -la scripts/*.sh 2>/dev/null | awk '{print "   " $9}' || echo "❌ No scripts found"
echo ""

echo "═══ SYNC INSTRUCTIONS ═══"
echo "🍎 Mac → GitHub:"
echo "   ./scripts/sync_git.sh \"your commit message\""
echo ""
echo "🪟 Windows ← GitHub:"
echo "   git pull origin main"
echo ""
echo "🔧 Windows Extension Setup:"
echo "   Copy scripts/install_extensions_windows.ps1 to Windows"
echo "   Run in PowerShell: .\\install_extensions_windows.ps1"
echo ""

echo "═══ NEXT STEPS ═══"
echo "✅ Mac setup complete!"
echo "1. Test terminal: Open new VS Code terminal"
echo "2. Test Git: Run ./scripts/sync_git.sh"
echo "3. Setup Windows: Copy extension script to Windows PC"
echo "4. Sync workflow: Mac pushes → Windows pulls"
echo ""

echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                         SETUP COMPLETE! 🚀                                  ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
