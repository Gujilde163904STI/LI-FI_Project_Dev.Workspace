#!/bin/bash

# GitHub PAT Testing and Push Script
echo "=== GitHub PAT Test and Push ==="

# REPLACE THIS WITH YOUR NEW PAT
NEW_PAT="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"

if [ "$NEW_PAT" = "PASTE_YOUR_NEW_PAT_HERE" ]; then
    echo "❌ Please edit this script and replace NEW_PAT with your actual token!"
    echo "Edit: scripts/test_new_pat.sh"
    exit 1
fi

cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

echo "Testing new PAT with GitHub API..."
response=$(curl -s -H "Authorization: token $NEW_PAT" "https://api.github.com/user")

if echo "$response" | grep -q '"login"'; then
    username=$(echo "$response" | grep '"login"' | cut -d'"' -f4)
    echo "✅ PAT is valid for user: $username"
    
    echo "Setting up Git with new PAT..."
    git remote set-url origin "https://$NEW_PAT@github.com/$username/LI-FI_Project_Dev.Workspace.git"
    
    echo "Testing connection..."
    if git ls-remote origin >/dev/null 2>&1; then
        echo "✅ Connection successful!"
        
        echo "Pushing to GitHub..."
        if git push origin main; then
            echo ""
            echo "🎉 SUCCESS! LI-FI Project is now on GitHub!"
            echo "🔗 Repository: https://github.com/$username/LI-FI_Project_Dev.Workspace"
            echo ""
            echo "✅ Ready for Windows sync:"
            echo "1. git clone https://$NEW_PAT@github.com/$username/LI-FI_Project_Dev.Workspace.git"
            echo "2. Run extension installer scripts"
            echo "3. Mac → GitHub → Windows workflow ready!"
        else
            echo "❌ Push failed. Repository might not exist."
            echo "💡 Create it manually: https://github.com/new"
            echo "Repository name: LI-FI_Project_Dev.Workspace"
        fi
    else
        echo "❌ Connection failed"
    fi
else
    echo "❌ PAT is still invalid"
    echo "Response: $response"
fi
