# Release & Versioning Guide

This guide explains how to manage app versions for NeuroStack to ensure smooth deployments to the Google Play Store and Apple App Store.

## 📌 The Golden Rule of Versioning
**Every single release (and every upload attempt to fix an error) must have a higher "Build Number" than the previous one.** If you upload a file with a number that has already been used (or even an abandoned upload with that number), the store will reject it.

> [!IMPORTANT]
> If a build fails to upload or you need to re-upload for any reason, you **must** increment the number again.

---

## 🛠 How to Update Versioning
In Flutter, versioning is controlled in the `pubspec.yaml` file using the following format:

```yaml
version: 1.0.0+1
```

- **`1.0.0` (Marketing Version)**: This is what users see (e.g., `1.0.1`, `2.0.0`).
- **`+1` (Build Number/Version Code)**: This is an internal integer that MUST increase with every upload.

### 🤖 Android (Google Play)
- Maps to `versionCode` in Gradle.
- **Requirement**: Must be a positive integer.
- **Error if forgotten**: *"Version code X has already been used. Try another version code."*

### 🍎 iOS (App Store)
- Maps to `CFBundleVersion`.
- **Requirement**: Must be unique for the same marketing version.
- **Error if forgotten**: App Store Connect will reject the binary during "Processing".

---

## 🚀 Step-by-Step Release Workflow

1.  **Open `pubspec.yaml`**:
    Locate the `version:` line.
2.  **Increment the numbers**:
    - If it was `1.0.0+2`, change it to `1.0.0+3`.
    - If you are doing a major update, change it to `1.1.0+4`.
3.  **Clean and Rebuild**:
    Always run `flutter clean` before a final production build to ensure no stale artifacts are included.
    ```bash
    flutter clean
    flutter pub get
    flutter build appbundle --release  # For Android
    flutter build ipa --release        # For iOS
    ```

## ⚠️ Troubleshooting: "Version Code Already Used"
If you see this error:
1. Stop.
2. Increase the number after the `+` in `pubspec.yaml`.
3. Run the build command again.
4. Upload the new file.

> [!TIP]
> Keep a log of your releases in `docs/RELEASE_LOG.md` to track which build numbers correspond to which features.
