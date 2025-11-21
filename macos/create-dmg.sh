#!/bin/bash

# Create DMG installer for PromptForge
# Usage: ./create-dmg.sh /path/to/PromptForge.app

APP_PATH="$1"
APP_NAME="PromptForge"
DMG_NAME="${APP_NAME}-Installer.dmg"
VOLUME_NAME="${APP_NAME}"
TMP_DMG="tmp-${DMG_NAME}"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH"
    echo "Usage: ./create-dmg.sh /path/to/PromptForge.app"
    exit 1
fi

# Create temporary folder
mkdir -p dmg-contents
cp -R "$APP_PATH" dmg-contents/
ln -s /Applications dmg-contents/Applications

# Create DMG
echo "Creating DMG..."
hdiutil create -volname "$VOLUME_NAME" -srcfolder dmg-contents -ov -format UDZO "$DMG_NAME"

# Cleanup
rm -rf dmg-contents

echo "✅ DMG created: $DMG_NAME"
echo "Users can drag ${APP_NAME}.app to Applications folder"
