#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Make sure we are in the root of the repo
cd $CI_PRIMARY_REPOSITORY_PATH

echo "🚀 Starting ci_post_clone.sh (V5: Network Proof)"
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

# 5. Install CocoaPods with Retries (ANTIFLAKE)
echo "🥥 Installing Pods..."
cd ios

# Explicitly check for Flutter.xcframework
FLUTTER_XCFRAMEWORK="$FLUTTER_HOME/bin/cache/artifacts/engine/ios/Flutter.xcframework"
if [ ! -d "$FLUTTER_XCFRAMEWORK" ]; then
    echo "🔥 FATAL: Flutter.xcframework NOT FOUND at $FLUTTER_XCFRAMEWORK"
    exit 1
else
    echo "✅ Flutter.xcframework found at $FLUTTER_XCFRAMEWORK"
fi

# Retry loop definition
MAX_RETRIES=3
COUNT=0
SUCCESS=false

set +e # Temporarily disable exit-on-error for the loop

while [ $COUNT -lt $MAX_RETRIES ]; do
    echo "🥥 Pod install attempt $(($COUNT + 1))..."
    # Using --repo-update to ensure fresh specs, but capturing output
    if pod install --repo-update; then
        SUCCESS=true
        break
    else
        echo "⚠️ Pod install failed (Attempt $(($COUNT + 1))). Retrying in 15s..."
        COUNT=$(($COUNT + 1))
        sleep 15
    fi
done

set -e # Re-enable exit-on-error

if [ "$SUCCESS" = false ]; then
    echo "🔥 FATAL: Pod install failed after $MAX_RETRIES attempts. Check network logs."
    exit 1
fi

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
