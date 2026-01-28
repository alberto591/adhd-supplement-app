#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Turn on verbose command echoing
set -x

echo "🚀 Starting ci_post_clone.sh"
echo "📂 Current directory: $(pwd)"
ls -la

# Define Flutter settings
FLUTTER_CHANNEL="stable"
FLUTTER_VERSION="3.27.1" # Use a specific version or leave generic
FLUTTER_HOME="$HOME/flutter"

# 1. Install Flutter
if [ ! -d "$FLUTTER_HOME" ]; then
    echo "📦 Installing Flutter ($FLUTTER_CHANNEL)..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_CHANNEL $FLUTTER_HOME
else
    echo "📦 Flutter already installed."
fi

# Add Flutter to PATH for this session
export PATH="$PATH:$FLUTTER_HOME/bin"

# Verify Flutter installation
echo "✅ Flutter version:"
flutter --version

# 2. Setup Flutter Dependencies
echo "🔄 Running flutter pub get..."
flutter pub get

# 3. Verify Generated Files
echo "🧐 Verifying generated iOS/Flutter config..."
if [ -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "✅ Generated.xcconfig FOUND!"
    cat ios/Flutter/Generated.xcconfig
else
    echo "❌ Generated.xcconfig NOT FOUND in $(pwd)/ios/Flutter/"
    ls -R ios/Flutter
    exit 1
fi

# 4. Install CocoaPods
echo "🥥 Installing Pods..."
cd ios
# Install CocoaPods if missing (unlikely on Xcode Cloud but safe)
if ! command -v pod &> /dev/null; then
    echo "⚠️ CocoaPods not found, installing..."
    sudo gem install cocoapods
fi

pod install --repo-update

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
