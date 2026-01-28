#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Make sure we are in the root of the repo
cd $CI_PRIMARY_REPOSITORY_PATH

# Turn on verbose command echoing
set -x

echo "🚀 Starting ci_post_clone.sh"
echo "📂 Current directory: $(pwd)"
ls -la

# Define Flutter settings
FLUTTER_CHANNEL="stable"
# Let's trust the latest stable to avoid version matching issues unless strictly necessary
FLUTTER_HOME="$HOME/flutter"

# 1. Install Flutter (Robust Check)
if [ ! -d "$FLUTTER_HOME" ]; then
    echo "📦 Installing Flutter ($FLUTTER_CHANNEL)..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_CHANNEL $FLUTTER_HOME
else
    echo "📦 Flutter directory found. Cleaning and updating..."
    # Often reusing the workspace can cause issues if not clean
    rm -rf "$FLUTTER_HOME"
    git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_CHANNEL $FLUTTER_HOME
fi

# Add Flutter to PATH for this session
export PATH="$PATH:$FLUTTER_HOME/bin"

# Verify Flutter installation
echo "✅ Flutter version:"
flutter --version

# 2. Setup Flutter Dependencies
echo "🔄 Running flutter pub get in $(pwd)..."
# Explicitly disable analytics to avoid hanging or prompts
flutter config --no-analytics
flutter pub get

# 3. Explicitly Build iOS bundle to force generation of xcconfig
echo "🔨 Running flutter build ios --config-only..."
flutter build ios --config-only --no-codesign

# 4. Verify Generated Files
echo "🧐 Verifying generated iOS/Flutter config..."
if [ -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "✅ Generated.xcconfig FOUND!"
    cat ios/Flutter/Generated.xcconfig
else
    echo "❌ Generated.xcconfig NOT FOUND in $(pwd)/ios/Flutter/"
    ls -R ios/Flutter
    exit 1
fi

# 5. Install CocoaPods
echo "🥥 Installing Pods..."
cd ios
# Install CocoaPods if missing (unlikely on Xcode Cloud but safe)
if ! command -v pod &> /dev/null; then
    echo "⚠️ CocoaPods not found, installing..."
    sudo gem install cocoapods
fi

# PodRepoUpdate can be slow or fail, use --no-repo-update if repo is fresh enough, 
# but for safety on cloud let's stick to installing what's locked.
pod install

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
