# 0049. Privacy Compliance & Hosting Strategy

Date: 2026-01-26

## Status

Accepted

## Context

To release "NeuroStack" on the Apple App Store and Google Play Store, we must comply with strict data safety regulations:
1.  **Public Privacy Policy**: A publicly accessible URL hosting the policy (cannot just be in-app).
2.  **Account/Data Deletion**: Users must be able to request data deletion *without* having the app installed (e.g., via a web form), and also efficiently via the app.
3.  **Data Deletion without Account Deletion**: Users should be able to reset their health data without losing their account status (implied by "granular control" requirements).

## Decision

We have decided to implement a hybrid approach using **Firebase Hosting** and **In-App Actions**:

1.  **Firebase Hosting for Compliance Pages**:
    *   We use the existing Firebase project to host static compliance pages.
    *   **Domain**: `https://neurostack-app.web.app` (created via Firebase multi-site).
    *   **Pages**:
        *   `/privacy`: The full legal text.
        *   `/delete-data`: A dedicated web form for external deletion requests.

2.  **Granular Data Deletion**:
    *   **In-App**: Two distinct actions in `PrivacySettingsScreen`:
        *   "Delete All My Data" (Full Account Deletion).
        *   "Clear Supplement History" (Partial Deletion - resets logs/streaks but keeps user/stack).
    *   **Web Form**: Radio buttons allowing users to choose between "Partial" and "Full" deletion.

3.  **Icon Tree Shaking Fix**:
    *   To ensure optimized release builds, we removed dynamic `IconData` usage in `CommunityPost` and replaced it with a static `switch-case` mapping.

## Consequences

### Positive
*   **Compliance**: Fully satisfies App Store Guideline 5.1.1 (Data Collection and Storage).
*   **Cost**: Zero additional cost (Firebase Hosting free tier).
*   **Maintenance**: Static HTML files are easy to update and version control alongside the app code.
*   **User Experience**: Users have clear, accessible control over their data both in and out of the app.

### Negative
*   **Manual Process**: The web form currently triggers an email (`mailto:`), requiring manual processing by the admin within 30 days. This is acceptable for V1 but should be automated (Cloud Functions) as user base grows.
