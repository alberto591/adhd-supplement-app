#!/bin/bash

# Usage: ./scripts/upload_missing_dsym.sh <UUID>
# Example: ./scripts/upload_missing_dsym.sh 52F5912E-8E19-30C7-ACCF-5D1DB340B5EA

if [ -z "$1" ]; then
  echo "❌ Error: Please provide the dSYM UUID as an argument."
  echo "Usage: $0 <UUID>"
  exit 1
fi

UUID=$1
echo "🔍 Searching for dSYM with UUID: $UUID..."

# Use mdfind to search for the UUID in dSYM files on the system
# This relies on Spotlight indexing
DSYM_PATH=$(mdfind "com_apple_xcode_dsym_uuids == $UUID" | grep ".dSYM$")

if [ -z "$DSYM_PATH" ]; then
  echo "❌ Error: Could not find any dSYM file matching UUID: $UUID"
  echo "Make sure the archive exists in ~/Library/Developer/Xcode/Archives"
  exit 1
fi

echo "✅ Found dSYM at: $DSYM_PATH"
echo "🚀 Uploading to Firebase Crashlytics..."

# Path to the upload-symbols tool in the local Pods
UPLOAD_TOOL="./ios/Pods/FirebaseCrashlytics/upload-symbols"
GOOGLE_SERVICE_PLIST="./ios/Runner/GoogleService-Info.plist"

if [ ! -f "$UPLOAD_TOOL" ]; then
  echo "❌ Error: Upload tool not found at $UPLOAD_TOOL"
  echo "Try running 'pod install' in the ios directory."
  exit 1
fi

if [ ! -f "$GOOGLE_SERVICE_PLIST" ]; then
  echo "❌ Error: GoogleService-Info.plist not found at $GOOGLE_SERVICE_PLIST"
  exit 1
fi

"$UPLOAD_TOOL" -gsp "$GOOGLE_SERVICE_PLIST" -p ios "$DSYM_PATH"

if [ $? -eq 0 ]; then
  echo "✅ Successfully uploaded dSYM!"
else
  echo "❌ Failed to upload dSYM."
  exit 1
fi
