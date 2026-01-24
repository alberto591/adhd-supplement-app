# ADR 0041: Decommissioning Mocks and Production Data Hardening

**Date:** 2026-01-24  
**Status:** Accepted  
**Deciders:** Antigravity (AI Architect), User

## Context

During early development, the app relied heavily on mock repositories (`MockSupplementRepository`, `MockStackRepository`) and a hardcoded demo user (`test@daily-stack.com`). This was useful for UI prototyping but created "magic" side effects (auto-login, persistent mock data) that interfered with production Firebase integration and real user testing.

## Decision

Decommission all development mocks and enforce a strict **Firebase-first** data architecture.

### Key Actions

1.  **Deletions**: All `mock_*.dart` files in `infrastructure/repositories/` were deleted.
2.  **Removal of Auto-Login**: The `SplashScreen` no longer automatically signs in the demo user. Authentication is now strictly user-initiated.
3.  **ViewModel Cleanup**: All ViewModels were audited to remove `userId` fallbacks. If no user is logged in, the `userId` is empty, and the app reflects an unauthenticated state correctly.
4.  **Seeding Migration**: The `SeedingService` was promoted from "test utility" to a "production support service" used to initialize global supplement data in Firestore.

## Consequences

**Positive:**
- "What you see is what you get": No more phantom data that doesn't exist in Firestore.
- Improved Security: No hardcoded credentials or bypasses.
- Ready for App Store: The app now follows standard authentication flows required for submission.

**Negative:**
- Development requires a valid Firebase connection (Internet required).
- "Empty States" are more apparent when a user first signs up.

## Mitigations
- Improved "Onboarding" and "Empty State" UI in the Dashboard.
- Retained `SeedingService` with a manual trigger in "System Health" for developers to reset the environment state.
