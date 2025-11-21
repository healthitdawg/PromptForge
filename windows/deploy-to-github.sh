#!/bin/bash

echo "🚀 PromptForge Windows - GitHub Deployment"
echo "=========================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed"
    echo "   Install from: https://git-scm.com/"
    exit 1
fi

echo "✓ Git is installed"
echo ""

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ Username cannot be empty"
    exit 1
fi

REPO_NAME="promptforge-windows"
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo ""
echo "📦 Repository will be: $REPO_URL"
echo ""
echo "⚠️  Before continuing, create the repository on GitHub:"
echo "   1. Go to: https://github.com/new"
echo "   2. Repository name: $REPO_NAME"
echo "   3. Make it Public or Private"
echo "   4. Don't add README, .gitignore, or license"
echo "   5. Click 'Create repository'"
echo ""
read -p "Press Enter when repository is created..."

echo ""
echo "🔧 Initializing git repository..."

# Initialize git if not already
if [ ! -d .git ]; then
    git init
    echo "✓ Git initialized"
else
    echo "✓ Git already initialized"
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'GITIGNORE'
node_modules/
dist/
.DS_Store
*.log
npm-debug.log*
.env
.env.local
GITIGNORE
    echo "✓ .gitignore created"
fi

# Add all files
echo ""
echo "📝 Adding files to git..."
git add .

# Commit
echo "💾 Creating commit..."
git commit -m "Initial commit - PromptForge Windows with GitHub Actions"

# Set main branch
git branch -M main

# Add remote
echo "🔗 Adding remote..."
git remote remove origin 2>/dev/null
git remote add origin "$REPO_URL"

# Push
echo "⬆️  Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! Code pushed to GitHub!"
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Go to: https://github.com/$GITHUB_USER/$REPO_NAME"
    echo ""
    echo "2. Click 'Actions' tab"
    echo ""
    echo "3. Click 'Build Windows Installer' workflow"
    echo ""
    echo "4. Click 'Run workflow' button (right side)"
    echo ""
    echo "5. Click green 'Run workflow' button"
    echo ""
    echo "6. Wait 5-10 minutes for build"
    echo ""
    echo "7. Download installers from 'Artifacts' section"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📖 For detailed instructions, see GITHUB-BUILD.md"
    echo ""
else
    echo ""
    echo "❌ Push failed. Common issues:"
    echo "   • Repository doesn't exist on GitHub"
    echo "   • Wrong username"
    echo "   • Need to authenticate (GitHub will prompt)"
    echo ""
    echo "Try again or push manually with:"
    echo "   git push -u origin main"
fi

