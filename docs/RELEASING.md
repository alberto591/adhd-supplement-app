# Release Signing & Deployment Guide

This document outlines the steps to prepare **FocusStack** for production release on Android and iOS.

---

## 1. Android Release Signing

### A. Generate a Keystore
Run the following command in your terminal. Replace `[YOUR_PASSWORD]` with a secure password.

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload -storepass [YOUR_PASSWORD] -keypass [YOUR_PASSWORD]
```

### B. Configure `key.properties`
Create a file at `android/key.properties` (this file is git-ignored) with the following content:

```properties
storePassword=[YOUR_PASSWORD]
keyPassword=[YOUR_PASSWORD]
keyAlias=upload
storeFile=upload-keystore.jks
```

### C. Build the App Bundle (AAB)
Run the following command to generate the release bundle for Google Play:

```bash
flutter build appbundle --release
```
The file will be located at `build/app/outputs/bundle/release/app-release.aab`.

---

## 2. iOS Release Signing

### A. App Store Connect
1. Log in to [App Store Connect](https://appstoreconnect.apple.com/).
2. Ensure the App ID `com.neurostack2.app` is registered.
3. Create a new App record for **NeuroStack**.

### B. Xcode Configuration
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** project in the project navigator.
3. Go to **Signing & Capabilities**.
4. Ensure **Automatically manage signing** is checked.
5. Select your **Team**.

### C. Build the Archive
From the terminal, run:

```bash
flutter build ipa --release
```

Then, open the generated `build/ios/archive/Runner.xcarchive` in Xcode Organizer and click **Distribute App** to upload it to App Store Connect.

---

## 3. Privacy Policy & Compliance

### A. Privacy Policy URL
The app's internal links are centralized in `lib/config/app_config.dart`.
Ensure your live policy is hosted at:
`https://neurostack-app.web.app/privacy`

### B. Data Deletion
Apple requires a way for users to delete their account and data.
This is implemented in **Profile > Privacy & Security > Delete All My Data**.
A manual request form is also linked at:
`https://neurostack-app.web.app/delete-data`
