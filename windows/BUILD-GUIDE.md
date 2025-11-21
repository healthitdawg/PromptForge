# Building Windows Installers - Complete Guide

## 🎯 You Have 3 Options

### Option 1: GitHub Actions (Easiest - No Windows PC Needed!) ⭐

**Perfect if you:** Don't have Windows, want automated builds

1. Push code to GitHub:
   ```bash
   cd /Users/john.brosius/Documents/PromptForge-Windows
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/promptforge-windows.git
   git push -u origin main
   ```

2. Go to repo → Actions → Build Windows Installer → Run workflow

3. Wait 5-10 minutes

4. Download installers from Artifacts section

**Pros:**
✅ No Windows PC needed
✅ Free with GitHub
✅ Builds both x64 and ARM64
✅ Repeatable and automated
✅ Can create releases automatically

**Cons:**
❌ Requires GitHub account
❌ 5-10 minute wait time
❌ Needs internet connection

---

### Option 2: Build on Windows PC (Most Common)

**Perfect if you:** Have access to a Windows PC

**On Windows PC:**

1. Install Node.js from https://nodejs.org/ (if not installed)

2. Extract PromptForge-Windows.zip

3. Open PowerShell/Command Prompt

4. Navigate to folder:
   ```
   cd C:\path\to\PromptForge-Windows
   ```

5. Install dependencies:
   ```
   npm install
   ```

6. Build installers:
   ```
   npm run build:win
   ```
   Or build specific architecture:
   ```
   npm run build:win-x64      # Intel/AMD only
   npm run build:win-arm64    # ARM only
   ```

7. Wait 5-10 minutes

8. Find installers in `dist/` folder:
   - `PromptForge-Setup-x64.exe`
   - `PromptForge-Setup-arm64.exe`

**Pros:**
✅ Most straightforward
✅ Full control over build process
✅ Can test immediately
✅ No external dependencies

**Cons:**
❌ Requires Windows PC
❌ Need to setup build environment
❌ Manual process

---

### Option 3: Cloud VM Service

**Perfect if you:** Need one-time build, no Windows PC, don't want GitHub

Use services like:
- Azure Virtual Machines (free trial)
- AWS EC2 Windows (free tier)
- Google Cloud Compute (free credits)

1. Create Windows VM
2. Install Node.js
3. Upload files
4. Run build commands
5. Download installers
6. Delete VM

**Pros:**
✅ No physical Windows PC needed
✅ Pay-as-you-go (can be free)
✅ Powerful build servers

**Cons:**
❌ More complex setup
❌ May cost money
❌ Requires cloud account

---

## 📦 What You Get

All methods produce the same output:

### x64 Installer (Intel/AMD)
- **File:** `PromptForge-Setup-x64.exe`
- **Size:** ~150MB (includes Electron runtime)
- **For:** Standard Windows PCs and laptops

### ARM64 Installer (ARM)
- **File:** `PromptForge-Setup-arm64.exe`
- **Size:** ~150MB
- **For:** Surface Pro X, Snapdragon laptops

### Installer Features
✓ Professional NSIS installer
✓ Desktop shortcut option
✓ Start Menu shortcut
✓ Uninstaller included
✓ Installation directory selection
✓ No admin rights required (installs to user folder)

---

## 🚀 Distribution After Building

### For End Users:

**Easy Install:**
1. Double-click the `.exe` installer
2. Click "Next" through wizard
3. Choose installation location (optional)
4. Select desktop shortcut (optional)
5. Click "Install"
6. Launch PromptForge!

### Sharing Methods:

**Direct Distribution:**
- Upload to your website
- Share via Google Drive/Dropbox
- Email (if < 25MB, compress first)
- USB drives
- Network shares

**Professional Distribution:**
- Microsoft Store (requires developer account)
- Chocolatey package manager
- WinGet package manager
- Your company software portal

**Release Page:**
- Create GitHub Release
- Attach installers
- Write release notes
- Share release URL

---

## 📋 Pre-Distribution Checklist

Before distributing to users:

### Testing:
- [ ] Install on clean Windows 10 PC
- [ ] Install on Windows 11 PC
- [ ] Test on x64 processor
- [ ] Test on ARM64 if possible
- [ ] Verify all features work
- [ ] Check uninstaller works
- [ ] Test desktop shortcut
- [ ] Test Start Menu entry

### Files:
- [ ] Both .exe files built successfully
- [ ] File sizes reasonable (~150MB each)
- [ ] No build errors in logs
- [ ] Version number correct
- [ ] Icon displays in installer

### Documentation:
- [ ] README included in installer
- [ ] Release notes written
- [ ] System requirements listed
- [ ] Support contact provided

---

## 🔐 Code Signing (Optional but Recommended)

**Without code signing:**
- Windows SmartScreen shows warning
- Users must click "More info" → "Run anyway"
- Works fine, just extra step for users

**With code signing ($$$):**
- No SmartScreen warnings
- Professional appearance
- User trust increased
- Costs $100-$500/year

**How to get certificate:**
1. Purchase from: DigiCert, Sectigo, SSL.com
2. Verify your identity/company
3. Receive certificate file
4. Update package.json with cert path
5. Rebuild with signing enabled

**For this project:** Code signing is optional. Most users can click through SmartScreen.

---

## 🎯 Recommended Workflow

**For Development:**
1. Use GitHub Actions for builds
2. Test installers on Windows VM or PC
3. Iterate and improve

**For Release:**
1. Update version in package.json
2. Create git tag: `git tag v1.0.0`
3. Push tag: `git push origin v1.0.0`
4. GitHub Actions auto-builds and creates Release
5. Share Release URL with users

**For Users:**
1. Download .exe from Release page
2. Run installer
3. Enjoy PromptForge!

---

## 📊 Build Time & Size Estimates

| Task | Time | Size |
|------|------|------|
| npm install | 2-3 min | ~400MB |
| Build x64 | 5-8 min | ~150MB |
| Build ARM64 | 5-8 min | ~150MB |
| Upload artifact | 1-2 min | - |
| Total | 10-15 min | ~300MB total |

---

## 🆘 Troubleshooting Builds

**"Cannot find module 'electron'"**
→ Run `npm install` first

**"NSIS not found"**
→ electron-builder will download it automatically (Windows only)

**Build hangs at "packaging"**
→ Normal! This step takes 3-5 minutes

**"Out of memory" error**
→ Close other apps, increase VM RAM, or build one arch at a time

**Artifacts not showing in GitHub Actions**
→ Check build completed successfully, scroll to bottom of run page

---

## 💡 Pro Tips

1. **Version Numbers:** Update in package.json before each build
2. **Changelog:** Keep CHANGELOG.md updated for users
3. **Testing:** Always test on fresh Windows install
4. **Automation:** GitHub Actions is the easiest long-term
5. **Backup:** Keep all .exe files backed up
6. **Distribution:** GitHub Releases is cleanest for users

---

## 🎉 You're Ready!

Choose your build method and create those installers!

**Quick Start:** Use GitHub Actions - it's free and automatic! 🚀

See GITHUB-BUILD.md for detailed GitHub Actions setup.
