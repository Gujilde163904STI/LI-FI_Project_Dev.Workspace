#!/bin/bash

# Simple GitHub Authentication Test
echo "=== GitHub Authentication Test ==="

cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

echo "Testing Git remote access..."
if git ls-remote origin >/dev/null 2>&1; then
    echo "✅ GitHub Authentication SUCCESS!"
    echo "🔗 Repository: $(git remote get-url origin)"
    echo "🌿 Branch: $(git branch --show-current)"
    
    echo ""
    echo "Adding test commit..."
    echo "# GitHub Authentication Test - $(date)" > github_auth_test.md
    git add github_auth_test.md
    git commit -m "Test: GitHub authentication with PAT - $(date)"
    
    echo ""
    echo "Pushing to GitHub..."
    if git push origin main; then
        echo "🎉 SUCCESS! Changes pushed to GitHub!"
        echo "📋 You can now use this repository for Mac ↔ Windows sync"
        
        # Clean up test file
        rm github_auth_test.md
        git add github_auth_test.md
        git commit -m "Clean up: Remove auth test file"
        git push origin main
        
    else
        echo "❌ Push failed. Check your PAT permissions."
    fi
else
    echo "❌ GitHub Authentication FAILED!"
    echo "Please check your Personal Access Token."
fi
