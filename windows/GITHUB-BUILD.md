# PromptForge Windows - GitHub Actions Build Guide

## 🚀 Automated Cloud Building

This project includes GitHub Actions to automatically build Windows installers!

## 📋 Setup Instructions

### Step 1: Push to GitHub

1. **Create a new repository on GitHub**
   - Go to: https://github.com/new
   - Name it: `promptforge-windows`
   - Keep it Public or Private (your choice)
   - Click "Create repository"

2. **Push your code** (run on your Mac):
   ```bash
   cd /Users/john.brosius/Documents/PromptForge-Windows
   git init
   git add .
   git commit -m "Initial commit - PromptForge Windows"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/promptforge-windows.git
   git push -u origin main
   ```

### Step 2: Automatic Build Triggers

The build will automatically run when:
- ✅ You push to main/master branch
- ✅ You create a pull request
- ✅ You manually trigger it (see below)

### Step 3: Manual Build (Recommended First Time)

1. Go to your GitHub repo
2. Click **"Actions"** tab
3. Click **"Build Windows Installer"** workflow
4. Click **"Run workflow"** button (right side)
5. Click green **"Run workflow"** button
6. Wait 5-10 minutes for build to complete

### Step 4: Download Installers

After build completes:
1. Click on the completed workflow run
2. Scroll to **"Artifacts"** section at bottom
3. Download:
   - `PromptForge-Windows-x64.zip`
   - `PromptForge-Windows-ARM64.zip`
4. Extract to get `.exe` installers

## 🎯 What Gets Built

Each build creates:
- **PromptForge-Setup-x64.exe** - For Intel/AMD processors
- **PromptForge-Setup-arm64.exe** - For ARM processors (Surface Pro X, etc.)

Both installers include:
- Professional NSIS installer
- Desktop shortcut option
- Start Menu entry
- Uninstaller
- Proper Windows integration

## 📦 Distribution

Share the downloaded `.exe` files with users:
- Via website download
- Email attachment
- Cloud storage link
- USB drive

## 🏷️ Creating Releases

To create a GitHub Release with installers:

1. Tag your version:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions will automatically:
   - Build installers
   - Create a Release
   - Attach installers to the Release

3. Share the Release page with users!

## ⚡ Build Status

Check build status:
- Visit: `https://github.com/YOUR_USERNAME/promptforge-windows/actions`
- See all builds and their status
- Download artifacts from any successful build

## 🔧 Troubleshooting

**Build fails:**
- Check Actions tab for error logs
- Usually caused by invalid package.json
- Make sure all files are committed

**Can't find artifacts:**
- Builds only keep artifacts for 30 days
- Run workflow again to get fresh installers

**No "Run workflow" button:**
- Make sure you're on the Actions tab
- Must be repo owner or have write access

## 💡 Tips

- **Free:** GitHub Actions is free for public repos
- **Fast:** Builds complete in 5-10 minutes
- **Reliable:** Uses official Microsoft Windows VMs
- **No Windows PC needed:** Build from anywhere!

## 📊 Build Limits (Free Tier)

- ✅ 2,000 minutes/month for public repos
- ✅ 500 MB artifact storage
- ✅ Unlimited builds for open source

Perfect for this project! Each build takes ~10 minutes.

## 🎉 Next Steps

1. Push code to GitHub
2. Trigger first build
3. Download installers
4. Test on Windows PC
5. Distribute to users!

---

**Questions?** Check the Actions tab for detailed logs and build output.
