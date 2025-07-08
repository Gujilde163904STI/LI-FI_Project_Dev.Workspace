#!/bin/bash

# Complete LI-FI Project Push & Verification Script
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    COMPLETE LI-FI PROJECT PUSH & VERIFICATION               ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"

cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

# Step 1: Verify PAT is working
echo "🔐 Step 1: Verifying GitHub PAT..."
PAT_RESPONSE=$(curl -s -H "Authorization: token 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" "https://api.github.com/user")
if echo "$PAT_RESPONSE" | grep -q '"login": "Gujilde163904STI"'; then
    echo "✅ PAT is valid for user: Gujilde163904STI"
else
    echo "❌ PAT validation failed"
    exit 1
fi

# Step 2: Configure Git properly
echo "🔧 Step 2: Configuring Git..."
git config --global user.name "Gujilde163904"
git config --global user.email "gujilde.163904@puertoprincesa.sti.edu.ph"
git config --global credential.helper store
git config --global core.editor "echo"
git config --global pull.rebase false
git config --global diff.ignoreSubmodules dirty

# Step 3: Update remote URL with working PAT
echo "🌐 Step 3: Setting up remote URL..."
git remote set-url origin "https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"
echo "Remote URL: $(git remote get-url origin | sed 's/ghp_[^@]*/ghp_***/')"

# Step 4: Test connection
echo "🔗 Step 4: Testing connection..."
if git ls-remote origin >/dev/null 2>&1; then
    echo "✅ Connection to GitHub successful"
else
    echo "❌ Connection failed"
    exit 1
fi

# Step 5: Add all essential files
echo "📁 Step 5: Adding all configuration files..."
git add .gitignore --force
git add .gitattributes --force
git add .vscode/settings.json
git add .vscode/tasks.json 2>/dev/null || true
git add scripts/install_extensions.sh
git add scripts/install_extensions_windows.ps1
git add scripts/sync_git.sh
git add scripts/test_new_pat.sh
git add scripts/project_summary.sh
git add scripts/complete_git_fix.sh
git add scripts/ultimate_github_fix.sh
git add MAC_SETUP_COMPLETE.md
git add PUSH_NOW.sh 2>/dev/null || true

# Add this verification script too
git add scripts/complete_push_verification.sh

echo "Files staged for commit:"
git diff --cached --name-only

# Step 6: Commit changes
echo "💾 Step 6: Committing changes..."
git commit -m "Complete LI-FI Mac setup: VS Code config, extensions, scripts, Git LFS, PAT auth - Ready for Windows sync $(date '+%Y-%m-%d %H:%M')"

# Step 7: Push to GitHub
echo "🚀 Step 7: Pushing to GitHub..."
if git push origin main; then
    echo ""
    echo "🎉 SUCCESS! LI-FI Project successfully pushed to GitHub!"
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                           PUSH VERIFICATION COMPLETE                        ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📂 Repository: https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
    echo ""
    echo "✅ WINDOWS READY FILES:"
    echo "   🔧 .vscode/settings.json - VS Code configuration"
    echo "   📦 scripts/install_extensions_windows.ps1 - Extension installer"
    echo "   🔄 scripts/sync_git.sh - Git sync workflow"
    echo "   📋 scripts/project_summary.sh - Project status"
    echo "   🗂️  .gitattributes - Git LFS for large files"
    echo "   🚫 .gitignore - Optimized for embedded development"
    echo ""
    echo "🪟 WINDOWS SETUP COMMANDS:"
    echo "1. git clone https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"
    echo "2. cd LI-FI_Project_Dev.Workspace"
    echo "3. .\\scripts\\install_extensions_windows.ps1"
    echo ""
    echo "🔄 SYNC WORKFLOW:"
    echo "Mac: ./scripts/sync_git.sh \"commit message\" → GitHub"
    echo "Windows: git pull origin main ← GitHub"
    echo ""
    echo "🎯 ROLE ASSIGNMENT:"
    echo "Mac = Development HQ | Windows = Hardware Runner & Device Flasher"
    echo ""
else
    echo "❌ Push failed! Error details above."
    echo "Repository URL: $(git remote get-url origin | sed 's/ghp_[^@]*/ghp_***/')"
    echo "Git status:"
    git status --porcelain
    exit 1
fi

# Step 8: Final verification
echo "🔍 Step 8: Final verification..."
echo "Current branch: $(git branch --show-current)"
echo "Latest commit: $(git log --oneline -1)"
echo "Remote status: $(git status --porcelain -b | head -1)"

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║    🎉 LI-FI PROJECT FULLY SYNCHRONIZED - READY FOR SEAMLESS WINDOWS SYNC!   ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
