# 0055. Android ProGuard Configuration for GSON/LocalNotifications

Date: 2026-02-01

## Status

Accepted

## Context

We identified a fatal crash on Android release builds (Issue 6735f872...) occurring when the application attempts to schedule or refresh reminders.

**Crash Signature:**
`io.flutter.plugins.firebase.crashlytics.FlutterError: PlatformException(error, TypeToken must be created with a type argument: new TypeToken<...>() {}; When using code shrinkers (ProGuard, R8, ...) make sure that generic signatures are preserved.)`

**Root Cause:**
The `flutter_local_notifications` plugin uses GSON to serialize and de-serialize scheduled notifications. GSON relies on Java's generic `TypeToken` to identify types at runtime. During release builds, the R8/ProGuard shrinker was stripping these generic signatures to save space, causing GSON to fail when de-obfuscating notifications.

## Decision

Update `android/app/proguard-rules.pro` to explicitly preserve generic signatures and prevent the obfuscation/stripping of GSON and `flutter_local_notifications` model classes.

### Implemented Rules:
1.  **Preserve Signatures**: Added `-keepattributes EnclosingMethod` and `-keepattributes InnerClasses` (in addition to existing `Signature`).
2.  **GSON Protection**: Kept all classes in `com.google.gson.**` and specifically preserved `TypeToken` and its subclasses.
3.  **Plugin Protection**: Kept all classes in `com.dexterous.flutterlocalnotifications.**` and its data models.

## Consequences

### Positive
- **Fixes Fatal Crash**: Users can now safely use the application persistence and reminder features in release builds without experiencing crashes.
- **Reliable Scheduling**: Ensures that notifications stored on the device can be correctly loaded and managed by the plugin.

### Negative
- **Minimal Binary Size Increase**: Preserving these signatures adds a negligible amount of metadata to the final APK/AAB.
