#!/bin/bash

# Emergency Git Push Script
# This script will force push all changes to GitHub

echo "=== Emergency Git Push for LI-FI Project ==="

# Navigate to project directory
cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

# Set Git configuration
export GIT_EDITOR=nano
git config --global core.editor nano
git config --global merge.tool vimdiff

echo "Step 1: Check Git status..."
git status --porcelain

echo ""
echo "Step 2: Add all files..."
git add .

echo ""
echo "Step 3: Commit changes..."
git commit -m "Complete Mac setup: VS Code config, extensions, scripts, GitHub auth with PAT - $(date '+%Y-%m-%d %H:%M')" || echo "Nothing new to commit"

echo ""
echo "Step 4: Push to GitHub..."
if git push origin main; then
    echo "🎉 SUCCESS! All files pushed to GitHub!"
    echo "📂 Repository: https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
    echo ""
    echo "✅ Files now available for Windows sync:"
    echo "   - .vscode/settings.json (VS Code configuration)"
    echo "   - scripts/install_extensions.sh (Mac extension installer)"
    echo "   - scripts/install_extensions_windows.ps1 (Windows extension installer)"
    echo "   - scripts/sync_git.sh (Git sync script)"
    echo "   - scripts/test_github_auth.sh (Authentication test)"
    echo "   - .gitignore (Optimized for embedded development)"
    echo "   - .gitattributes (Git LFS configuration)"
    echo ""
    echo "🪟 Windows Setup Instructions:"
    echo "1. git clone https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"
    echo "2. Run: .\\scripts\\install_extensions_windows.ps1"
    echo "3. Always run: git pull origin main"
else
    echo "❌ Push failed! Check the error above."
fi
