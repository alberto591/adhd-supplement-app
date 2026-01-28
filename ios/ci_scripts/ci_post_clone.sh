#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# Make sure we are in the root of the repo
cd $CI_PRIMARY_REPOSITORY_PATH

echo "🚀 Starting ci_post_clone.sh (V6: The Nuclear Option)"
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

# 3. FORCE Build Config (The Change from V5)
# Instead of trusting precache, we FORCE a config-only build.
# This guarantees that the engine artifacts are downloaded AND placed exactly where Xcode expects.
echo "🔨 Running flutter build ios --config-only (Force)..."
flutter build ios --config-only --no-codesign --no-pub

# 4. Verify Generated Config
echo "🧐 Verifying ios/Flutter/Generated.xcconfig..."
if [ -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "✅ Generated.xcconfig successfully created!"
    head -n 5 ios/Flutter/Generated.xcconfig
else
    echo "🔥 FATAL: Could not generate Generated.xcconfig."
    exit 1
fi

# 5. Install CocoaPods with Retries (ANTIFLAKE)
echo "🥥 Installing Pods..."
cd ios

# Retry loop definition
MAX_RETRIES=3
COUNT=0
SUCCESS=false

set +e # Temporarily disable exit-on-error for the loop

while [ $COUNT -lt $MAX_RETRIES ]; do
    echo "🥥 Pod install attempt $(($COUNT + 1))..."
    # Using --repo-update to ensure fresh specs
    if pod install --repo-update; then
        SUCCESS=true
        break
    else
        echo "⚠️ Pod install failed (Attempt $(($COUNT + 1))). Retrying in 15s..."
        COUNT=$(($COUNT + 1))
        
        # Diagnostics on failure
        echo "Diagnostics: Checking for Flutter.xcframework..."
        ls -R "$FLUTTER_HOME/bin/cache/artifacts/engine/ios/" || echo "Artifacts dir incomplete"
        
        sleep 15
    fi
done

set -e # Re-enable exit-on-error

if [ "$SUCCESS" = false ]; then
    echo "🔥 FATAL: Pod install failed after $MAX_RETRIES attempts."
    exit 1
fi

echo "🎉 ci_post_clone.sh completed successfully."
exit 0
