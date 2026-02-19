# 🚀 How to Build PromptForge on Your Mac

> **You'll need a Mac computer for this.** Windows won't work for this app.

---

## ✅ Before You Start — Check You Have These

### Thing 1 — A Mac running macOS Ventura or newer
Click the 🍎 Apple menu in the top-left corner → click **"About This Mac"**.
You need to see **macOS 13.0** or a higher number. If yours says 12 or lower, ask a grown-up to update it.

### Thing 2 — Xcode (the app that builds Mac apps)
1. Open the **App Store** on your Mac (the blue icon with the "A")
2. Search for **Xcode**
3. Click **Get** → **Install** (it's free but BIG — about 15 GB, so give it time!)
4. Wait for it to finish downloading ☕

### Thing 3 — The PromptForge code on your Mac
You need a copy of the project files. Ask a grown-up to help you clone the repository, or just download the ZIP from GitHub and unzip it somewhere easy to find, like your **Desktop**.

---

## 🏗️ Let's Build It! (3 Easy Ways)

---

### WAY 1 — Double-Click in Xcode (Easiest! 🌟)

1. **Open Finder** (the smiley face icon in your Dock)
2. Navigate to the folder where you put the PromptForge files
3. Open the **`macos`** folder
4. Find the file called **`PromptForge.xcodeproj`** — it has a blue Xcode icon
5. **Double-click** it — Xcode will open automatically
6. At the very top of Xcode, you'll see a toolbar. Find the **▶ Play button** (it looks like a triangle)
7. Click it! Xcode will build the app and launch it 🎉

> 💡 **First time?** Xcode might ask you to install "Command Line Tools." Click **Install** and wait a minute.

---

### WAY 2 — Use the Build Script (Terminal Style 😎)

1. Open **Terminal** — press `Command + Space`, type **Terminal**, hit Enter
2. Type this command and press Enter (change the path to where YOUR files are):
   ```
   cd ~/Desktop/PromptForge
   ```
3. Now type this and press Enter:
   ```
   ./macos/build.sh
   ```
4. Watch the text scroll by — when you see **✓ Debug build →** you're done!
5. Your built app will be inside the `build` folder

---

### WAY 3 — GitHub Builds It For You Automatically (Magic! ✨)

This one happens on the internet — you don't need to do anything on your Mac!

1. Make sure the code is pushed to GitHub (ask a grown-up if you're not sure)
2. Go to the GitHub website and open the PromptForge repository
3. Click the **"Actions"** tab at the top
4. Find the job called **"Build macOS App"** — it should be running (spinning circle 🔄)
5. Wait for it to turn **green ✅** (takes about 10–15 minutes)
6. Click on it, scroll down to **"Artifacts"**, and click **PromptForge-macOS-...**
7. A ZIP file will download — open it and you'll find **PromptForge.app** inside!
8. **Drag PromptForge.app to your Applications folder** and double-click to open it 🎊

---

## 🔧 If Something Goes Wrong

| What you see | What to do |
|---|---|
| *"Xcode is not installed"* | Go back to Step 1 and install Xcode from the App Store |
| *"Command not found"* | Make sure you're in the right folder — try step 2 in Way 2 again |
| Red errors in Xcode | Click the red circle at the top of Xcode and read the message — usually it says what's missing |
| *"Cannot open because the developer cannot be verified"* | Right-click the app → click **Open** → click **Open** again |
| Xcode is taking forever | It's normal the first time! Grab a snack 🍪 and come back in 10 minutes |

---

## 🎮 Using the App

Once it opens, here's what you can do:

| Button / Area | What it does |
|---|---|
| **Left sidebar** | Shows all your folders and tags — click one to filter your prompts |
| **Middle list** | Shows all your prompts — click one to open it |
| **Right editor** | Where you write and edit your prompt |
| **⌘ + N** | Create a brand new prompt |
| **⌘ + S** | Save what you're working on |
| **⌘ + Shift + T** | Test your prompt with an AI (you need an API key in Preferences first) |
| **PromptForge menu → Preferences** | Add your OpenAI API key so you can test prompts |

---

## ❓ Quick Questions

**Q: What is a "prompt"?**
A: It's a message you write to an AI like ChatGPT. PromptForge helps you save and organise your best ones!

**Q: Do I need an internet connection?**
A: Only if you want to test prompts with an AI. The app itself works offline.

**Q: Where does my data get saved?**
A: Right on your Mac! Nothing goes to the internet unless you press "Test with LLM."

**Q: Can I get my data back if I mess something up?**
A: Yes! Every time you save a prompt, the app saves a history. Click the **History** tab in the editor to go back in time.

---

*Happy prompting! 🤖*
