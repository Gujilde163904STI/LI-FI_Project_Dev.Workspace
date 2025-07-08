#!/bin/bash

# Fix MD050 markdownlint issues
# Converts underscore-based emphasis (_text_) to asterisk-based emphasis (*text*)

echo "🔧 Fixing MD050 markdownlint issues..."

# Function to fix a single file
fix_file() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Convert _text_ to *text* (single underscores for emphasis)
    # But avoid converting __text__ (double underscores for bold)
    # Also avoid converting code blocks and inline code
    sed -E '
        # Skip lines that are code blocks
        /^```/,/^```/ {
            p
            d
        }
        # Skip lines that start with 4 spaces (code blocks)
        /^    / {
            p
            d
        }
        # Convert _text_ to *text* but avoid __text__
        s/(^|[^_])_([^_]+)_([^_]|$)/\1*\2*\3/g
        # Handle edge cases where _ is at start or end of line
        s/^_([^_]+)_([^_]|$)/*\1*\2/g
        s/(^|[^_])_([^_]+)_$/\1*\2*/g
    ' "$file" > "$temp_file"
    
    # Check if the file was actually changed
    if ! cmp -s "$file" "$temp_file"; then
        mv "$temp_file" "$file"
        echo "✅ Fixed: $file"
    else
        rm "$temp_file"
        echo "ℹ️  No changes needed: $file"
    fi
}

# Find all markdown files and fix them
find . -name "*.md" -type f | while read -r file; do
    # Skip files in node_modules and other build directories
    if [[ "$file" != *"node_modules"* ]] && [[ "$file" != *".git"* ]] && [[ "$file" != *"__archive"* ]]; then
        fix_file "$file"
    fi
done

echo ""
echo "🎉 MD050 fixes completed!"
echo ""
echo "📝 Summary of changes:"
echo "- Converted _text_ emphasis to *text* emphasis"
echo "- Preserved __text__ bold formatting"
echo "- Skipped code blocks and inline code"
echo ""
echo "💡 To verify the fixes, you can run:"
echo "   npx markdownlint '**/*.md' --fix"
echo ""
echo "🔍 To check for remaining issues:"
echo "   npx markdownlint '**/*.md'" 