#!/bin/bash

APP_PATH="$1"

if [ -z "$APP_PATH" ]; then
    echo "Usage: ./verify-app-icon.sh /path/to/PromptForge.app"
    exit 1
fi

echo "🔍 Checking PromptForge.app icon setup..."
echo ""

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found at: $APP_PATH"
    exit 1
fi

echo "✅ App exists: $APP_PATH"

# Check Info.plist for icon reference
PLIST="$APP_PATH/Contents/Info.plist"
if [ -f "$PLIST" ]; then
    ICON_FILE=$(defaults read "$PLIST" CFBundleIconFile 2>/dev/null)
    if [ -n "$ICON_FILE" ]; then
        echo "✅ Icon file referenced in Info.plist: $ICON_FILE"
    else
        echo "⚠️  No icon file reference in Info.plist"
    fi
else
    echo "❌ Info.plist not found"
fi

# Check for icon files in Resources
RESOURCES="$APP_PATH/Contents/Resources"
if [ -d "$RESOURCES" ]; then
    ICON_COUNT=$(ls "$RESOURCES"/*.icns 2>/dev/null | wc -l)
    if [ $ICON_COUNT -gt 0 ]; then
        echo "✅ Found $ICON_COUNT .icns file(s):"
        ls -lh "$RESOURCES"/*.icns 2>/dev/null
    else
        echo "❌ No .icns files found in Resources folder"
        echo "   This means the app icon wasn't compiled into the app"
        echo "   → Solution: Clean and rebuild in Xcode"
    fi
else
    echo "❌ Resources folder not found"
fi

# Check Assets.car
if [ -f "$RESOURCES/Assets.car" ]; then
    echo "✅ Assets.car exists ($(du -h "$RESOURCES/Assets.car" | cut -f1))"
else
    echo "❌ Assets.car not found (contains compiled asset catalog)"
fi

echo ""
echo "RECOMMENDATION:"
if [ $ICON_COUNT -eq 0 ]; then
    echo "🔧 Rebuild the app in Xcode:"
    echo "   1. Product → Clean Build Folder (Shift+⌘K)"
    echo "   2. Product → Build (⌘B)"
    echo "   3. Product → Archive (for distribution)"
else
    echo "✅ Icon is properly embedded! App should show custom icon."
fi
