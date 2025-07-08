#!/bin/zsh

# Set the target lib directory (update this path if needed)
LIB_DIR="./Arduino.Core-Dev/Arduino-Core/app/lib"

# Create lib directory if it doesn't exist
mkdir -p "$LIB_DIR"

# Download the correct JARs
curl -L -o "$LIB_DIR/commons-exec-1.3.jar" "https://repo1.maven.org/maven2/org/apache/commons/commons-exec/1.3/commons-exec-1.3.jar"
curl -L -o "$LIB_DIR/commons-lang3-3.12.0.jar" "https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar"

# Optionally remove old versions
rm -f "$LIB_DIR/commons-exec-1.1.jar" "$LIB_DIR/commons-lang3-3.8.1.jar"

echo "✅ JARs updated in $LIB_DIR"
