# ADR 0044: Real-time User Profile Syncing

## Status
Accepted

## Context
XP and Level updates are critical for user retention in an ADHD-focused app. However, while `DailyStackViewModel` was correctly updating the Firestore document, the UI (often managed by `AuthProvider`) would not reflect these changes until the app was restarted or the user manually refreshed certain screens. This lack of immediate feedback broke the "Dopamine Loop" essential for gamification.

## Decision
Implement real-time profile syncing using Firestore snapshots.
1. **Repository Extension**: Added a `watchUser(String userId)` method to the `AuthRepository` interface and `FirebaseAuthRepository`.
2. **Reactive Provider**: Updated `AuthProvider` to subscribe to the `watchUser` stream upon authentication.
3. **Automatic Cleanup**: The subscription is automatically canceled on sign-out or provider disposal.
4. **State Management**: `AuthProvider` now broadcasts state changes whenever the underlying Firestore user document changes (XP, Level, etc.).

## Consequences
- **Positive**: Instant visual feedback for XP gains and achievement unlocks.
- **Positive**: Single source of truth (Firestore) pushed automatically to all UI consumers.
- **Positive**: Reduced need for manual `refresh()` calls in ViewModels.
- **Negative**: Persistent listener increases Firestore read usage (mitigated by focus on simple user document).

## Compliance
- **ADHD UI Optimizer**: Enhances "Instant Feedback" and "Gamification Engagement."
- **Architecture**: Follows the Reactive Repository pattern.
