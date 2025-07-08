#!/bin/bash

# Script to disable problematic .NET extensions that require .NET 6
echo "Disabling .NET extensions that cause runtime requirement issues..."

# List of extensions to disable
EXTENSIONS_TO_DISABLE=(
    "ms-dotnettools.csharp"
    "ms-dotnettools.csdevkit" 
    "ms-dotnettools.vscode-dotnet-runtime"
    "ms-dotnettools.vscode-dotnet-pack"
    "ms-dotnettools.dotnet-interactive-vscode"
    "ms-dotnettools.vscodeintellicode-csharp"
    "kreativ-software.csharpextensions"
)

# Disable each extension
for ext in "${EXTENSIONS_TO_DISABLE[@]}"; do
    echo "Disabling extension: $ext"
    code --disable-extension "$ext" --disable-extension-by-default
done

echo "Extensions disabled. Please restart VS Code to apply changes."
echo "If you need C# support later, re-enable only ms-dotnettools.csharp"
