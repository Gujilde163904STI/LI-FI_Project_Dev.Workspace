#!/bin/bash

# Complete Git Fix and Push Script
echo "=== LI-FI Project Git Fix and Push ==="

cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

# Step 1: Fix Git configuration
echo "Step 1: Configuring Git..."
git config --global credential.helper store
git config --global user.name "Gujilde163904"
git config --global user.email "gujilde.163904@puertoprincesa.sti.edu.ph"
git config --global core.editor "echo"
git config --global merge.tool vimdiff
git config --global pull.rebase false

# Step 2: Set up credentials
echo "Step 2: Setting up GitHub credentials..."
echo "https://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:@github.com" > ~/.git-credentials

# Step 3: Update remote URL with PAT
echo "Step 3: Updating remote URL..."
git remote set-url origin "https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"

# Step 4: Add .gitattributes (now that it's unignored)
echo "Step 4: Adding .gitattributes..."
git add .gitattributes --force

# Step 5: Add all our configuration files
echo "Step 5: Adding configuration files..."
git add .gitignore
git add .vscode/settings.json
git add scripts/install_extensions.sh
git add scripts/install_extensions_windows.ps1
git add scripts/sync_git.sh
git add scripts/test_github_auth.sh
git add scripts/project_summary.sh
git add MAC_SETUP_COMPLETE.md
git add PUSH_NOW.sh

# Step 6: Ignore submodule changes for this commit
echo "Step 6: Ignoring submodule changes..."
git config --global diff.ignoreSubmodules dirty
git config --global status.submoduleSummary false

# Step 7: Commit our changes
echo "Step 7: Committing changes..."
git commit -m "Complete LI-FI Mac setup: VS Code config, extensions, scripts, Git LFS, PAT auth"

# Step 8: Push to GitHub
echo "Step 8: Pushing to GitHub..."
if git push origin main; then
    echo ""
    echo "🎉 SUCCESS! LI-FI Project pushed to GitHub!"
    echo "📂 Repository: https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
    echo ""
    echo "✅ Available for Windows sync:"
    echo "   - All VS Code configuration"
    echo "   - Extension installation scripts"
    echo "   - Git sync workflows"
    echo "   - Git LFS for large files"
    echo ""
    echo "🪟 Windows Setup:"
    echo "1. git clone https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"
    echo "2. .\\scripts\\install_extensions_windows.ps1"
    echo "3. Always: git pull origin main"
else
    echo "❌ Push failed. Check the error above."
    echo "Remote URL: $(git remote get-url origin)"
    echo "Git status:"
    git status --porcelain
fi
