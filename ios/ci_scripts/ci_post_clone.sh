#!/bin/sh

# Fail this script if any of the commands it's running fails
set -e

# The working directory is the root of the repository
echo "Current directory: $(pwd)"

# 1. Install Flutter
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# 2. Setup Flutter
echo "Setting up Flutter..."
flutter precache --ios
flutter pub get

# 3. Install Pods
echo "Installing CocoaPods..."
cd ios
pod install

exit 0
