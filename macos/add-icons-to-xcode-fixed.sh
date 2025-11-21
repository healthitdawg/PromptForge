#!/bin/bash

ASSETS_PATH="PromptForge/Assets.xcassets/AppIcon.appiconset"

echo "Adding icons to Xcode project..."

# Copy existing icon files to match Xcode naming
cp icon_16x16.png "$ASSETS_PATH/"
cp icon_32x32.png "$ASSETS_PATH/icon_32x32@2x.png"
cp icon_32x32.png "$ASSETS_PATH/"
cp icon_64x64@2x.png "$ASSETS_PATH/"
cp icon_128x128@2x.png "$ASSETS_PATH/icon_128x128.png"
cp icon_128x128@2x.png "$ASSETS_PATH/"
cp icon_256x256@2x.png "$ASSETS_PATH/icon_256x256.png"
cp icon_256x256@2x.png "$ASSETS_PATH/"
cp icon_512x512@2x.png "$ASSETS_PATH/icon_512x512.png"
cp icon_512x512@2x.png "$ASSETS_PATH/"
cp icon_1024x1024@2x.png "$ASSETS_PATH/"

# Update Contents.json
cat > "$ASSETS_PATH/Contents.json" << 'JSONEOF'
{
  "images" : [
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "icon_16x16.png",
      "scale" : "1x"
    },
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "icon_32x32@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "icon_32x32.png",
      "scale" : "1x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "icon_64x64@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "icon_128x128.png",
      "scale" : "1x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "icon_256x256@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "icon_256x256.png",
      "scale" : "1x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "icon_512x512@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "icon_512x512.png",
      "scale" : "1x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "icon_1024x1024@2x.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
JSONEOF

echo "✅ Icons added successfully!"
ls -la "$ASSETS_PATH"/*.png
