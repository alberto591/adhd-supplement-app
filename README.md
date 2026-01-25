# ADHD Supplement App

A cross-platform mobile application built with Flutter for ADHD supplement education and referral tracking.

## Architecture

This project uses a hybrid of **Hexagonal Architecture** and **MVVM**:

- **domain/**: Models and Repository interfaces (Pure logic).
- **application/**: ViewModels managing state.
- **infrastructure/**: Firebase and Local service implementations.
- **presentation/**: UI Screens (Views) and Widgets.
- **config/**: Dependency Injection (GetIt) and global settings.

## Dependencies

- **Firebase**: Backend, Authentication, and Firestore.
- **URL Launcher**: Opening referral links.
- **Local Notifications**: User reminders and alerts.
- **Provider & GetIt**: State management and Dependency Injection.

## Getting Started

1. Ensure you have Flutter installed.
2. Run `flutter pub get` to install dependencies.
3. For Firebase, add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platforms.
4. This app uses RevenueCat for billing. You must provide your API keys when running or building:
   ```bash
   flutter run --dart-define=RC_ANDROID_KEY=your_android_key --dart-define=RC_IOS_KEY=your_ios_key
   ```
