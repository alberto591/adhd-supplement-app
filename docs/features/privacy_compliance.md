# Privacy & Data Deletion Features

**Feature ID**: PRIVACY-001
**Related ADR**: [0049-privacy-compliance-hosting.md](../adrs/0049-privacy-compliance-hosting.md)

## Overview

This feature set ensures NeuroStack complies with Apple App Store and Google Play Store data safety requirements. It provides users with transparency (Privacy Policy) and control (Data Deletion) over their personal information.

## Architecture

### 1. Hosting Infrastructure
*   **Provider**: Firebase Hosting
*   **Site Target**: `neurostack-app`
*   **URL**: `https://neurostack-app.web.app`
*   **Configuration**: `firebase.json` maps rewrites for clean URLs (`/privacy`, `/delete-data`).

### 2. Web Components
Located in `web/public/`:
*   `privacy.html`: Static, branded version of the Privacy Policy.
*   `delete-data.html`: A form allowing users to submit deletion requests via `mailto:`.

### 3. In-App Implementation

#### Privacy Settings Screen
*   **View**: `PrivacySettingsScreen`
*   **ViewModel**: `PrivacyViewModel`
*   **Features**:
    *   **External Links**: Direct URL launcher to hosted pages.
    *   **Clear History**: Calls `PrivacyViewModel.clearAllHealthData()` to wipe logs via `LogRepository`.
    *   **Delete Account**: Calls `AuthRepository.deleteUser()` after clearing data.

#### Repository Layer
*   `LogRepository.clearAllLogs(userId)`: Batch deletes all `daily_logs` subcollections for the user.

## Release Process

When releasing or updating compliance docs:
1.  Update `PRIVACY_POLICY.md` (Source of Truth).
2.  Update `web/public/privacy.html` to match.
3.  Run `firebase deploy --only hosting` to push changes live.

## Testing

*   **Manual**: Verify URLs load and `mailto` links open default email client.
*   **Unit**: `PrivacyViewModelTest` verifies that `clearAllHealthData` triggers the correct repository calls.
