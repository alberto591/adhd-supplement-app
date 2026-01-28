#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Make sure we are in the root of the repo
cd $CI_PRIMARY_REPOSITORY_PATH

echo "🚀 Starting ci_post_clone.sh (V3)"
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

# 2. Setup Flutter Dependencies
# Disable analytics to prevent hanging
flutter config --no-analytics

echo "🔄 Running flutter pub get..."
flutter pub get

# 3. Verify Generated Config (Critical Step)
echo "🧐 Verifying ios/Flutter/Generated.xcconfig..."
if [ -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "✅ Generated.xcconfig successfully created by pub get!"
    # Print content for debugging (first 5 lines)
    head -n 5 ios/Flutter/Generated.xcconfig
else
    echo "❌ Generated.xcconfig MISSING after pub get. Attempting generic build..."
    # Fallback: simple build command just to generate config, skipping signing/codes
    flutter build ios --config-only --no-codesign --no-pub || true
    
    if [ -f "ios/Flutter/Generated.xcconfig" ]; then
        echo "✅ Generated.xcconfig created by fallback build!"
    else
        echo "🔥 FATAL: Could not generate Generated.xcconfig."
        exit 1
    fi
fi

# 4. Install CocoaPods
echo "🥥 Installing Pods..."
cd ios

# Check that Podfile can see the config
# (The Podfile throws error if Generated.xcconfig is missing, so this acts as a check)
pod install --repo-update

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
