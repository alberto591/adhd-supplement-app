#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Make sure we are in the root of the repo
cd $CI_PRIMARY_REPOSITORY_PATH

echo "🚀 Starting ci_post_clone.sh (V4)"
echo "📂 Current directory: $(pwd)"

# Define Flutter settings
FLUTTER_CHANNEL="stable"
FLUTTER_HOME="$HOME/flutter"

# 1. Install Flutter (Clean Install)
if [ -d "$FLUTTER_HOME" ]; then
    echo "🗑️ Removing existing Flutter directory to ensure clean slate..."
    rm -rf "$FLUTTER_HOME"
fi

echo "📦 Installing Flutter ($FLUTTER_CHANNEL)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_CHANNEL $FLUTTER_HOME

# Add Flutter to PATH
export PATH="$PATH:$FLUTTER_HOME/bin"

echo "✅ Flutter version:"
flutter --version

# 2. Pre-cache iOS Artifacts (CRITICAL FIX)
echo "📦 Pre-caching iOS artifacts..."
flutter precache --ios

# 3. Setup Flutter Dependencies
# Disable analytics to prevent hanging
flutter config --no-analytics

echo "🔄 Running flutter pub get..."
flutter pub get

# 4. Verify Generated Config
echo "🧐 Verifying ios/Flutter/Generated.xcconfig..."
if [ -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "✅ Generated.xcconfig successfully created by pub get!"
    head -n 5 ios/Flutter/Generated.xcconfig
else
    echo "❌ Generated.xcconfig MISSING after pub get. Attempting fallback build..."
    # Fallback to force generation
    flutter build ios --config-only --no-codesign --no-pub || true
    
    if [ -f "ios/Flutter/Generated.xcconfig" ]; then
        echo "✅ Generated.xcconfig created by fallback build!"
    else
        echo "🔥 FATAL: Could not generate Generated.xcconfig."
        exit 1
    fi
fi

# 5. Install CocoaPods
echo "🥥 Installing Pods..."
cd ios

# Explicitly check for Flutter.xcframework before pod install to fail fast if missing
FLUTTER_XCFRAMEWORK="$FLUTTER_HOME/bin/cache/artifacts/engine/ios/Flutter.xcframework"
if [ ! -d "$FLUTTER_XCFRAMEWORK" ]; then
    echo "🔥 FATAL: Flutter.xcframework NOT FOUND at $FLUTTER_XCFRAMEWORK"
    echo "Directory listing of $FLUTTER_HOME/bin/cache/artifacts/engine/ios/:"
    ls -R "$FLUTTER_HOME/bin/cache/artifacts/engine/ios/" || echo "Directory does not exist."
    exit 1
else
    echo "✅ Flutter.xcframework found at $FLUTTER_XCFRAMEWORK"
fi

pod install --repo-update

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
