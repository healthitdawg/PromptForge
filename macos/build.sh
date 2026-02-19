#!/usr/bin/env bash
# PromptForge macOS Local Build Script
# Usage:
#   ./macos/build.sh                    # Debug build (fast)
#   ./macos/build.sh release            # Release archive + zip
#   ./macos/build.sh clean              # Remove derived data
#
# Prerequisites: Xcode 15+ installed, run from repo root.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$REPO_ROOT/macos/PromptForge.xcodeproj"
SCHEME="PromptForge"
DERIVED="$REPO_ROOT/build/DerivedData"
ARCHIVE="$REPO_ROOT/build/PromptForge.xcarchive"
EXPORT="$REPO_ROOT/build/export"

MODE="${1:-debug}"

# ─── Helpers ─────────────────────────────────────────────────────────────────

log()  { echo "▶ $*"; }
ok()   { echo "✓ $*"; }
die()  { echo "✗ $*" >&2; exit 1; }

require_xcode() {
    command -v xcodebuild >/dev/null 2>&1 || die "xcodebuild not found. Install Xcode 15+."
    XCODE_VER=$(xcodebuild -version 2>/dev/null | head -1)
    log "$XCODE_VER"
}

# ─── Actions ─────────────────────────────────────────────────────────────────

do_clean() {
    log "Cleaning build artefacts…"
    rm -rf "$REPO_ROOT/build"
    ok "Clean complete."
}

do_debug() {
    require_xcode
    log "Building Debug (arm64 + x86_64)…"
    mkdir -p "$DERIVED"

    xcodebuild build \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -configuration Debug \
        -destination "platform=macOS,arch=arm64" \
        -derivedDataPath "$DERIVED" \
        CODE_SIGN_IDENTITY="-" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        ${XCPRETTY:+| xcpretty --color}

    APP="$DERIVED/Build/Products/Debug/PromptForge.app"
    if [[ -d "$APP" ]]; then
        ok "Debug build → $APP"
        log "App size: $(du -sh "$APP" | awk '{print $1}')"
    else
        die "Build succeeded but app not found at $APP"
    fi
}

do_release() {
    require_xcode
    log "Archiving Release build…"
    mkdir -p "$REPO_ROOT/build"

    xcodebuild archive \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -configuration Release \
        -archivePath "$ARCHIVE" \
        -derivedDataPath "$DERIVED" \
        CODE_SIGN_IDENTITY="-" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO

    ok "Archive → $ARCHIVE"

    # Export unsigned .app
    cat > /tmp/ExportOptions.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>mac-application</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
PLIST

    xcodebuild -exportArchive \
        -archivePath "$ARCHIVE" \
        -exportPath "$EXPORT" \
        -exportOptionsPlist /tmp/ExportOptions.plist \
        CODE_SIGN_IDENTITY="-" \
        CODE_SIGNING_REQUIRED=NO

    APP="$EXPORT/PromptForge.app"
    ZIP="$REPO_ROOT/build/PromptForge-macOS.zip"

    if [[ -d "$APP" ]]; then
        ok "Exported → $APP"
        log "Creating zip…"
        cd "$EXPORT"
        zip -r --symlinks "$ZIP" PromptForge.app
        ok "Zip → $ZIP ($(du -sh "$ZIP" | awk '{print $1}'))"
    else
        die "Export succeeded but app not found at $APP"
    fi
}

# ─── Dispatch ─────────────────────────────────────────────────────────────────

case "$MODE" in
    clean)   do_clean ;;
    release) do_release ;;
    debug)   do_debug ;;
    *)       die "Unknown mode '$MODE'. Use: debug | release | clean" ;;
esac
