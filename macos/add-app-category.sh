#!/bin/bash

# Add App Category to Xcode project
PROJECT_PATH="PromptForge.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_PATH" ]; then
    echo "❌ Project file not found"
    exit 1
fi

echo "🔧 Adding App Category to Xcode project..."

# Backup original
cp "$PROJECT_PATH" "$PROJECT_PATH.backup"

# Add LSApplicationCategoryType to build settings
# For macOS, we'll add it to the project file
perl -i -pe 's/(PRODUCT_NAME = "\$\(TARGET_NAME\)";)/$1\n\t\t\t\tINFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.productivity";/g' "$PROJECT_PATH"

echo "✅ Added App Category: Productivity"
echo ""
echo "Now in Xcode:"
echo "1. Close Xcode if it's open"
echo "2. Re-open the project"
echo "3. Clean Build Folder (Shift+⌘K)"
echo "4. Build (⌘B)"
echo ""
echo "Backup saved as: $PROJECT_PATH.backup"
