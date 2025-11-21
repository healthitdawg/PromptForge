#!/bin/bash

# Create PKG installer for PromptForge
# Usage: ./create-pkg.sh /path/to/PromptForge.app

APP_PATH="$1"
APP_NAME="PromptForge"
PKG_NAME="${APP_NAME}-Installer.pkg"
IDENTIFIER="com.yourcompany.promptforge"
VERSION="1.0.0"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH"
    echo "Usage: ./create-pkg.sh /path/to/PromptForge.app"
    exit 1
fi

# Create package structure
mkdir -p pkg-root/Applications
cp -R "$APP_PATH" pkg-root/Applications/

# Build the package
echo "Creating PKG installer..."
pkgbuild --root pkg-root \
         --identifier "$IDENTIFIER" \
         --version "$VERSION" \
         --install-location / \
         "$PKG_NAME"

# Cleanup
rm -rf pkg-root

echo "✅ PKG created: $PKG_NAME"
echo "Users can double-click to install to /Applications"
