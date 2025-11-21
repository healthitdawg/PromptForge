# PromptForge

A cross-platform AI prompt management application for macOS and Windows 11.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![Windows](https://img.shields.io/badge/Windows-11-blue)

## 🎯 Features

- ✨ **Prompt Management**: Create, edit, and organize your LLM prompts
- 📁 **Color-coded Categories**: Organize prompts with custom categories
- 🔍 **Real-time Search**: Find prompts instantly across titles, content, and tags
- 📋 **Clipboard Integration**: One-click copy to clipboard
- 🏷️ **Tag Support**: Add multiple tags for better organization
- 💾 **Local Storage**: All data stored locally - no cloud, no tracking
- 🎨 **Native UI**: SwiftUI on macOS, Electron with Windows 11 styling
- 🔐 **Privacy First**: No internet required, no data collection

## 📦 Downloads

### macOS
- **Requirements**: macOS 13+ (Ventura or later)
- **Architecture**: Universal (Intel & Apple Silicon)
- **Download**: [PromptForge-Installer.dmg](macos/PromptForge-Installer.dmg)
- **Size**: ~370KB

### Windows
- **Requirements**: Windows 10/11
- **Architectures**: x64 (Intel/AMD) and ARM64
- **Download**: See [Releases](https://github.com/healthitdawg/PromptForge/releases)
- **Size**: ~150MB per installer

## 🚀 Quick Start

### macOS
1. Download `PromptForge-Installer.dmg`
2. Open the DMG file
3. Drag PromptForge to Applications folder
4. Launch from Applications or Launchpad

### Windows
1. Download `PromptForge-Setup-x64.exe` or `PromptForge-Setup-arm64.exe`
2. Run the installer
3. Follow the installation wizard
4. Launch from Start Menu or Desktop shortcut

## 🛠️ Development

### macOS Development

**Requirements:**
- Xcode 15.0+
- macOS 13+
- Swift 5.9+

**Setup:**
```bash
cd macos
open PromptForge.xcodeproj
# Press ⌘R to build and run
```

**Build Distribution:**
```bash
cd macos
# Archive in Xcode: Product → Archive
# Then run:
./create-dmg-simple.sh ~/Desktop/PromptForge.app
```

### Windows Development

**Requirements:**
- Node.js 18+
- npm 9+

**Setup:**
```bash
cd windows
npm install
npm start
```

**Build Distribution:**
```bash
cd windows
npm run build:win       # Build both x64 and ARM64
npm run build:win-x64   # Intel/AMD only
npm run build:win-arm64 # ARM only
```

## 📖 Documentation

- [macOS Build Guide](macos/README-MACOS.md)
- [Windows Build Guide](windows/BUILD-GUIDE.md)
- [GitHub Actions Setup](windows/GITHUB-BUILD.md)
- [Windows Testing Guide](windows/WINDOWS-SETUP.md)

## 🏗️ Technology Stack

### macOS
- **Language**: Swift
- **Framework**: SwiftUI
- **Storage**: UserDefaults
- **Architecture**: Native macOS app

### Windows
- **Language**: JavaScript/HTML/CSS
- **Framework**: Electron
- **Storage**: localStorage
- **Architecture**: Cross-platform (runs on macOS too!)

## 📁 Project Structure

```
PromptForge/
├── macos/                      # macOS native app
│   ├── PromptForge/           # Swift source files
│   ├── PromptForge.xcodeproj/ # Xcode project
│   ├── PromptForge-Installer.dmg # Ready-to-use installer
│   └── create-dmg-simple.sh   # Build script
│
├── windows/                    # Windows Electron app
│   ├── main.js                # Electron main process
│   ├── index.html             # Application UI
│   ├── styles.css             # Windows 11 styling
│   ├── app.js                 # Application logic
│   └── .github/workflows/     # CI/CD automation
│
└── README.md                  # This file
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Built with SwiftUI for macOS
- Built with Electron for Windows
- Icons generated with Python/Pillow
- CI/CD powered by GitHub Actions

## 📧 Support

For issues, questions, or suggestions:
- Open an [Issue](https://github.com/healthitdawg/PromptForge/issues)
- Check [Discussions](https://github.com/healthitdawg/PromptForge/discussions)

## 🗺️ Roadmap

- [ ] Cloud sync (optional)
- [ ] Import/Export functionality
- [ ] Custom themes
- [ ] Markdown support in prompts
- [ ] Global keyboard shortcuts
- [ ] Prompt templates
- [ ] Multi-language support
- [ ] Linux version

## 📊 Stats

- **Lines of Code**: ~7,000+
- **Languages**: Swift, JavaScript, HTML, CSS
- **Platforms**: 2 (macOS, Windows)
- **Architectures**: 3 (Intel x64, Apple Silicon, ARM64)

---

**Made with ❤️ for the AI community**

Version: 1.0.0  
Last Updated: November 2024
