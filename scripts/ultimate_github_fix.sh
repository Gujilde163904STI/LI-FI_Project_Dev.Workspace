#!/bin/bash

# Ultimate GitHub Authentication Fix for LI-FI Project
echo "=== Ultimate GitHub Authentication Fix ==="

cd /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace

echo "Step 1: Clearing all existing Git credentials..."
# Clear existing credential helpers
git config --global --unset credential.helper 2>/dev/null || true
git config --local --unset credential.helper 2>/dev/null || true

# Remove old credential files
rm -f ~/.git-credentials 2>/dev/null || true

echo "Step 2: Setting up fresh Git configuration..."
# Configure Git with your details
git config --global user.name "Gujilde163904"
git config --global user.email "gujilde.163904@puertoprincesa.sti.edu.ph"

# Disable VS Code Git integration temporarily
export GIT_TERMINAL_PROMPT=0
export GIT_ASKPASS=""

echo "Step 3: Testing different authentication methods..."

# Method 1: Direct PAT in URL
echo "Trying Method 1: PAT in URL..."
git remote set-url origin "https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"

if git ls-remote origin >/dev/null 2>&1; then
    echo "✅ Method 1 successful! Pushing..."
    if git push origin main; then
        echo "🎉 SUCCESS! Repository pushed to GitHub!"
        echo "🔗 https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
        exit 0
    fi
fi

# Method 2: Username:PAT format
echo "Trying Method 2: Username:PAT format..."
git remote set-url origin "https://Gujilde163904STI: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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"

if git ls-remote origin >/dev/null 2>&1; then
    echo "✅ Method 2 successful! Pushing..."
    if git push origin main; then
        echo "🎉 SUCCESS! Repository pushed to GitHub!"
        echo "🔗 https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
        exit 0
    fi
fi

# Method 3: Check if repository exists under different name
echo "Trying Method 3: Checking repository variations..."

# Try with correct username
git remote set-url origin "https://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@github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace.git"

if git ls-remote origin >/dev/null 2>&1; then
    echo "✅ Method 3 successful! Pushing..."
    if git push origin main; then
        echo "🎉 SUCCESS! Repository pushed to GitHub!"
        echo "🔗 https://github.com/Gujilde163904STI/LI-FI_Project_Dev.Workspace"
        exit 0
    fi
fi

echo "❌ All methods failed. Let's check PAT status..."

# Test PAT directly
echo "Testing PAT with GitHub API..."
response=$(curl -s -H "Authorization: token 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" "https://api.github.com/user")

if echo "$response" | grep -q '"login"'; then
    username=$(echo "$response" | grep '"login"' | cut -d'"' -f4)
    echo "✅ PAT is valid for user: $username"
    
    # Try with correct username from API
    git remote set-url origin "https://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@github.com/$username/LI-FI_Project_Dev.Workspace.git"
    
    if git push origin main; then
        echo "🎉 SUCCESS! Repository pushed to GitHub!"
        echo "🔗 https://github.com/$username/LI-FI_Project_Dev.Workspace"
    else
        echo "❌ Push still failed. The repository might not exist."
        echo "💡 Create it manually at: https://github.com/new"
        echo "Repository name: LI-FI_Project_Dev.Workspace"
    fi
else
    echo "❌ PAT is invalid or expired"
    echo "🔄 Generate a new PAT at: https://github.com/settings/tokens"
    echo "Required scopes: repo, workflow"
fi
