#!/bin/bash

# Create DMG installer with custom icon for PromptForge
APP_PATH="$1"
APP_NAME="PromptForge"
DMG_NAME="${APP_NAME}-Installer.dmg"
VOLUME_NAME="${APP_NAME}"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: App not found at $APP_PATH"
    echo "Usage: ./create-dmg-simple.sh /path/to/PromptForge.app"
    exit 1
fi

echo "🎨 Creating professional DMG installer..."

# Create ICNS from PNG icons first
if [ -f "icon_512x512@2x.png" ]; then
    echo "Converting icon to ICNS format..."
    mkdir -p AppIcon.iconset
    
    # Use existing PNG files
    cp icon_16x16.png AppIcon.iconset/icon_16x16.png
    cp icon_32x32.png AppIcon.iconset/icon_16x16@2x.png
    cp icon_32x32.png AppIcon.iconset/icon_32x32.png
    cp icon_64x64@2x.png AppIcon.iconset/icon_32x32@2x.png
    
    # Generate missing sizes from larger icons
    sips -z 128 128 icon_256x256@2x.png --out AppIcon.iconset/icon_128x128.png 2>/dev/null
    cp icon_256x256@2x.png AppIcon.iconset/icon_128x128@2x.png
    sips -z 256 256 icon_512x512@2x.png --out AppIcon.iconset/icon_256x256.png 2>/dev/null
    cp icon_512x512@2x.png AppIcon.iconset/icon_256x256@2x.png
    sips -z 512 512 icon_1024x1024@2x.png --out AppIcon.iconset/icon_512x512.png 2>/dev/null
    cp icon_1024x1024@2x.png AppIcon.iconset/icon_512x512@2x.png
    
    iconutil -c icns AppIcon.iconset -o VolumeIcon.icns 2>/dev/null
    rm -rf AppIcon.iconset
fi

# Create temporary folder
mkdir -p dmg-temp
cp -R "$APP_PATH" dmg-temp/
ln -s /Applications dmg-temp/Applications

# Copy volume icon
if [ -f "VolumeIcon.icns" ]; then
    cp VolumeIcon.icns dmg-temp/.VolumeIcon.icns
fi

# Create writable DMG first
echo "Creating temporary DMG..."
rm -f temp.dmg
hdiutil create -volname "$VOLUME_NAME" -srcfolder dmg-temp -ov -format UDRW temp.dmg > /dev/null

# Mount it
echo "Mounting and customizing..."
DEV_NAME=$(hdiutil attach -readwrite -noverify -noautoopen temp.dmg | grep "/Volumes/${VOLUME_NAME}" | awk '{print $1}')
MOUNT_POINT="/Volumes/${VOLUME_NAME}"

sleep 2

# Set custom icon if available
if [ -f "VolumeIcon.icns" ] && [ -d "$MOUNT_POINT" ]; then
    cp VolumeIcon.icns "$MOUNT_POINT/.VolumeIcon.icns" 2>/dev/null
    SetFile -c icnC "$MOUNT_POINT/.VolumeIcon.icns" 2>/dev/null
    SetFile -a C "$MOUNT_POINT" 2>/dev/null
fi

# Customize Finder view with AppleScript
osascript <<APPLESCRIPT 2>/dev/null
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {200, 200, 800, 500}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 128
        set background color of viewOptions to {11776, 13056, 16384}
        delay 1
        set position of item "PromptForge.app" of container window to {150, 150}
        set position of item "Applications" of container window to {450, 150}
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
APPLESCRIPT

# Unmount
sync
hdiutil detach "${DEV_NAME}" > /dev/null

# Convert to compressed, read-only
echo "Compressing final DMG..."
rm -f "$DMG_NAME"
hdiutil convert temp.dmg -format UDZO -o "$DMG_NAME" > /dev/null

# Cleanup
rm -rf dmg-temp temp.dmg VolumeIcon.icns

echo ""
echo "✅ DMG installer created successfully!"
echo "📦 File: $DMG_NAME"
echo "📏 Size: $(du -h "$DMG_NAME" | cut -f1)"
echo ""
echo "🎉 Ready to distribute!"
