# PromptForge - macOS Edition

Native macOS application built with SwiftUI.

## 🎯 Features

- Native SwiftUI interface
- Three-column layout (Categories, Prompts, Detail)
- Dark/Light mode support
- Color-coded categories
- Real-time search
- Clipboard integration
- Local storage with UserDefaults
- Custom app icon
- Keyboard shortcuts

## 📦 Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0+ (for development)

## 🚀 Installation

### For Users

1. Download `PromptForge-Installer.dmg`
2. Open the DMG file
3. Drag PromptForge.app to Applications folder
4. Launch the app

### For Developers

1. Open `PromptForge.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Press ⌘R to build and run

## 🏗️ Building Distribution

### Create DMG Installer

```bash
# 1. Archive the app
# In Xcode: Product → Archive

# 2. Export the app
# Organizer → Distribute App → Copy App → Save to Desktop

# 3. Create DMG
./create-dmg-simple.sh ~/Desktop/PromptForge.app

# 4. DMG created: PromptForge-Installer.dmg
```

## 📁 Project Structure

```
PromptForge/
├── PromptForgeApp.swift      # App entry point
├── ContentView.swift         # Main UI
├── Models.swift              # Data models
├── DataManager.swift         # Data persistence
├── PromptDetailView.swift    # Detail view
├── AddPromptView.swift       # Create prompt
├── EditPromptView.swift      # Edit prompt
├── AddCategoryView.swift     # Category management
└── Assets.xcassets/          # App icon and assets
    └── AppIcon.appiconset/   # Icon files
```

## 🎨 Icon Generation

The app includes custom icon generation:

```bash
# Generate icon from Python script
python3 generate-icon.py

# Add icons to Xcode
./add-icons-to-xcode-fixed.sh
```

## 🔧 Build Scripts

- `create-dmg-simple.sh` - Create DMG installer with custom icon
- `verify-app-icon.sh` - Verify icon is embedded in app
- `add-app-category.sh` - Add app category to Xcode project
- `generate-icon.py` - Generate app icons from scratch

## 📝 Features in Detail

### Categories
- Create unlimited categories
- Assign colors
- Filter prompts by category
- Delete categories (prompts become uncategorized)

### Prompts
- Create with title and content
- Assign to categories
- Add multiple tags
- Edit and delete
- Search across all fields
- Copy to clipboard with one click

### Storage
- All data saved locally using UserDefaults
- No cloud sync (privacy-first)
- Persists between app launches
- No internet required

## 🐛 Troubleshooting

**Icon not showing:**
- Clean Build Folder (Shift+⌘K)
- Rebuild the project
- Verify icon files in Assets.xcassets

**App won't run:**
- Check minimum macOS version (13.0+)
- Verify code signing
- Check for build errors in Xcode

**Data not persisting:**
- Check UserDefaults permissions
- Verify app isn't sandboxed incorrectly

## 📦 Distribution

The DMG installer includes:
- Professional drag-and-drop interface
- Custom volume icon
- Applications folder shortcut
- Styled Finder window

Size: ~370KB (small!)

## 🎯 System Requirements

- **macOS**: 13.0 (Ventura) or later
- **RAM**: 4GB minimum
- **Disk**: 1MB installed size
- **Architecture**: Universal (Intel + Apple Silicon)

## 📄 License

MIT License - See main README

---

**Built with SwiftUI**  
Native performance, native look and feel
