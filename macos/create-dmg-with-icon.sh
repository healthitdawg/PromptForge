#!/bin/bash

# Create DMG installer with custom icon for PromptForge
# Usage: ./create-dmg-with-icon.sh /path/to/PromptForge.app

APP_PATH="$1"
APP_NAME="PromptForge"
DMG_NAME="${APP_NAME}-Installer.dmg"
VOLUME_NAME="${APP_NAME}"
BACKGROUND_COLOR="#2E3440"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH"
    echo "Usage: ./create-dmg-with-icon.sh /path/to/PromptForge.app"
    exit 1
fi

echo "🎨 Creating DMG with custom icon and layout..."

# Create temporary folder
mkdir -p dmg-contents
cp -R "$APP_PATH" dmg-contents/
ln -s /Applications dmg-contents/Applications

# Create a temporary DMG
echo "Creating temporary DMG..."
hdiutil create -volname "$VOLUME_NAME" -srcfolder dmg-contents -ov -format UDRW temp.dmg

# Mount the temporary DMG
echo "Mounting DMG..."
DEV_NAME=$(hdiutil attach -readwrite -noverify -noautoopen temp.dmg | grep "/Volumes/${VOLUME_NAME}" | awk '{print $1}')
MOUNT_POINT="/Volumes/${VOLUME_NAME}"

# Wait for mount
sleep 2

# Set custom icon for the DMG (using the app's icon)
if [ -f "icon_512x512@2x.png" ]; then
    # Convert PNG to ICNS
    mkdir -p AppIcon.iconset
    sips -z 16 16     icon_16x16.png --out AppIcon.iconset/icon_16x16.png
    sips -z 32 32     icon_32x32.png --out AppIcon.iconset/icon_16x16@2x.png
    sips -z 32 32     icon_32x32.png --out AppIcon.iconset/icon_32x32.png
    sips -z 64 64     icon_64x64@2x.png --out AppIcon.iconset/icon_32x32@2x.png
    sips -z 128 128   icon_128x128.png --out AppIcon.iconset/icon_128x128.png
    sips -z 256 256   icon_256x256@2x.png --out AppIcon.iconset/icon_128x128@2x.png
    sips -z 256 256   icon_256x256.png --out AppIcon.iconset/icon_256x256.png
    sips -z 512 512   icon_512x512@2x.png --out AppIcon.iconset/icon_256x256@2x.png
    sips -z 512 512   icon_512x512.png --out AppIcon.iconset/icon_512x512.png
    sips -z 1024 1024 icon_1024x1024@2x.png --out AppIcon.iconset/icon_512x512@2x.png
    
    iconutil -c icns AppIcon.iconset -o VolumeIcon.icns
    
    # Copy icon to mounted volume
    cp VolumeIcon.icns "$MOUNT_POINT/.VolumeIcon.icns"
    
    # Set custom icon attribute
    SetFile -c icnC "$MOUNT_POINT/.VolumeIcon.icns"
    SetFile -a C "$MOUNT_POINT"
    
    # Cleanup
    rm -rf AppIcon.iconset
fi

# Set window position and icon positions with AppleScript
osascript <<EOD
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 700, 450}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 128
        set background color of viewOptions to {11776, 13056, 16384}
        set position of item "PromptForge.app" of container window to {150, 150}
        set position of item "Applications" of container window to {450, 150}
        update without registering applications
        delay 2
    end tell
end tell
EOD

# Unmount
echo "Finalizing DMG..."
hdiutil detach "${DEV_NAME}"

# Convert to compressed read-only DMG
hdiutil convert temp.dmg -format UDZO -o "$DMG_NAME"

# Cleanup
rm -rf dmg-contents temp.dmg VolumeIcon.icns

echo ""
echo "✅ DMG created with custom icon: $DMG_NAME"
echo "📦 Size: $(du -h "$DMG_NAME" | cut -f1)"
echo "🎨 Features: Custom volume icon, styled background, arranged layout"
