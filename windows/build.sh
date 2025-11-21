#!/bin/bash

echo "🏗️  Building PromptForge for Windows..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "   Download from: https://nodejs.org/"
    exit 1
fi

echo "✓ Node.js version: $(node --version)"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Build for Windows
echo "🔨 Building Windows installers..."
echo "   This will create builds for both x64 and ARM64 architectures"
echo ""

npm run build:win

echo ""
echo "✅ Build complete!"
echo ""
echo "📦 Installers created in dist/ folder:"
echo "   - PromptForge-Setup-x64.exe (Intel/AMD)"
echo "   - PromptForge-Setup-arm64.exe (ARM)"
echo ""
echo "🚀 Ready to distribute!"
