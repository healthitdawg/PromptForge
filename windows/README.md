# PromptForge - Windows Edition

A native Windows 11 application for managing LLM AI prompts with categories, search, and clipboard integration.

## 🎯 Features

- ✨ **Prompt Management**: Create, edit, and delete prompts
- 📁 **Color-coded Categories**: Organize prompts into custom categories
- 🔍 **Real-time Search**: Quick search across titles, content, and tags
- 📋 **Clipboard Integration**: One-click copy to clipboard
- 🏷️ **Tag Support**: Add tags for better organization
- 💾 **Local Storage**: All data stored locally (no cloud required)
- 🎨 **Modern UI**: Windows 11-style dark theme
- ⌨️ **Keyboard Shortcuts**: Ctrl+N for new prompt, and more
- 🖥️ **Multi-Architecture**: Supports Intel/AMD (x64) and ARM64

## 📦 System Requirements

- **OS**: Windows 11 (also compatible with Windows 10)
- **Architecture**: x64 (Intel/AMD) or ARM64
- **RAM**: 4GB minimum
- **Disk Space**: 200MB

## 🚀 Installation

### For Users (Pre-built Installer)

1. Download `PromptForge-Setup-x64.exe` (for Intel/AMD) or `PromptForge-Setup-arm64.exe` (for ARM)
2. Run the installer
3. Follow the installation wizard
4. Launch PromptForge from Start Menu or Desktop

### For Developers (Build from Source)

**Prerequisites:**
- Node.js 18+ (download from https://nodejs.org/)
- Git (optional)

**Build Steps:**

1. **Clone or download the repository**
   ```bash
   cd PromptForge-Windows
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Run in development mode**
   ```bash
   npm start
   ```

4. **Build installer for Windows**
   ```bash
   # Build for both x64 and ARM64
   npm run build:win

   # Or build for specific architecture
   npm run build:win-x64      # Intel/AMD
   npm run build:win-arm64    # ARM (Surface Pro X, etc.)
   ```

5. **Find installers in `dist/` folder**
   - `PromptForge-Setup-x64.exe` - For Intel/AMD processors
   - `PromptForge-Setup-arm64.exe` - For ARM processors

## 📖 Usage

### Creating a Prompt
1. Click **"New Prompt"** button or press `Ctrl+N`
2. Enter title and content
3. (Optional) Select a category and add tags
4. Click **"Save"**

### Managing Categories
1. Click the **"+"** button next to "Categories"
2. Enter category name
3. Choose a color
4. Click **"Add"**

### Searching Prompts
- Type in the search box at the top
- Search works across titles, content, and tags
- Results update in real-time

### Copying to Clipboard
- Select a prompt
- Click **"Copy to Clipboard"** button
- Content is copied and ready to paste

### Keyboard Shortcuts
- `Ctrl+N` - New Prompt
- `Ctrl+F` - Focus Search (when implemented)
- `Ctrl+Q` - Quit Application

## 🏗️ Tech Stack

- **Electron** - Cross-platform desktop framework
- **HTML/CSS/JavaScript** - Modern web technologies
- **Node.js** - JavaScript runtime
- **electron-builder** - Build and package tool

## 📁 Project Structure

```
PromptForge-Windows/
├── main.js              # Electron main process
├── index.html           # UI structure
├── styles.css           # Styling (Windows 11 theme)
├── app.js               # Application logic
├── package.json         # Dependencies and scripts
├── assets/              # Icons and resources
│   └── icon.png
└── README.md           # This file
```

## 🔧 Configuration

The app stores data locally in:
```
%APPDATA%\PromptForge\
```

Data is stored using localStorage and persists between sessions.

## 🐛 Troubleshooting

**App won't start:**
- Make sure you have Windows 11 or Windows 10 with latest updates
- Try running as Administrator
- Check Windows Event Viewer for errors

**Build fails:**
- Ensure Node.js 18+ is installed
- Delete `node_modules` and run `npm install` again
- Check internet connection for dependency downloads

**SmartScreen warning:**
- This is normal for unsigned applications
- Click "More info" → "Run anyway"
- For production, sign the app with a code signing certificate

## 🔐 Security & Privacy

- ✅ All data stored locally
- ✅ No internet connection required
- ✅ No telemetry or tracking
- ✅ No ads or third-party services
- ✅ Open source - review the code yourself

## 📄 License

MIT License - Feel free to use and modify

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For issues or questions:
- Open an issue on GitHub
- Email: support@promptforge.app (if available)

## 🗺️ Roadmap

- [ ] Cloud sync (optional)
- [ ] Import/Export functionality
- [ ] Custom themes
- [ ] Markdown support
- [ ] Global hotkey
- [ ] System tray integration
- [ ] Templates

## 🎉 Credits

Built with ❤️ using Electron

---

**Version**: 1.0.0  
**Last Updated**: November 2024  
**Platform**: Windows 11 (x64/ARM64)
