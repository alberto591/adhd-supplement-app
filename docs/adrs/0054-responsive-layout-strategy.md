# 0054. Responsive Layout Strategy on Small Devices

Date: 2026-02-01

## Status

Accepted

## Context

During the pre-launch testing phase, we identified several UI overflow issues on smaller iOS devices (specifically iPhone SE class devices with 667px height).

Key issues identified:
1.  **Welcome Screen (`OnboardingExplainerScreen`)**: The rigid `Column` structure with `Spacer` widgets pushed content off-screen, resulting in a ~17px overflow.
2.  **Dashboard Loading State (`DailyStackScreen`)**: The skeleton loader (placeholder UI) exceeded the viewport height, causing "yellow/black striped" overflow errors during the 3-second data loading phase.

These issues degrade the first-time user experience and can block critical actions (like the "Get Started" button) on supported devices.

## Decision

We will adopt a "Scroll-First" strategy for all screen layouts that risk exceeding 600px in vertical height.

### 1. `CustomScrollView` + `SliverFillRemaining` for Full-Height Layouts

For screens that are designed to fill the viewport (like onboarding screens or centered auth screens), we will use the following structure:

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverFillRemaining(
        hasScrollBody: false, // Important: Allows content to be smaller than viewport or expanding
        child: Column(
          children: [
            // Content
            Spacer(), // Spacer works correctly here by filling remaining viewport space
            // Bottom Buttons
          ],
        ),
      ),
    ],
  ),
)
```

**Reasoning:**
-   **Why not `SingleChildScrollView`?** A standard `SingleChildScrollView` with a `Column` does not support `Spacer()` or `Expanded()` widgets properly because the scroll view gives them infinite height constraints.
-   **Why `SliverFillRemaining`?** This widget forces the child to fill the *viewport* at minimum, allowing `Spacer()` to work for vertical centering on large screens. However, if the content's intrinsic height exceeds the viewport (e.g., on iPhone SE), it automatically becomes scrollable.

### 2. `SingleChildScrollView` for Long Content / Skeletons

For standard content screens or loading skeletons that are top-aligned (not vertically centered), we will wrap the layout in `SingleChildScrollView`:

```dart
SingleChildScrollView(
  child: Column(
    children: [
       // Skeleton items
    ],
  ),
)
```

## Consequences

### Positive
-   **Eliminates Overflow**: Layouts will simply scroll if they don't fit, preventing critical rendering errors.
-   **Consistent UX**: Large devices maintain their nice, spaced-out aesthetic due to `Spacer()` support in `SliverFillRemaining`.
-   **Future-Proofing**: Adjusting font sizes (Dynamic Type) or adding more content won't break the build.

### Negative
-   **Complexity**: `CustomScrollView` is slightly more verbose than a simple `Column`.
-   **Scroll Physics**: We must ensure standard scroll physics (bouncing on iOS) remains natural.

## Compliance
All future "full screen" entry or onboarding screens **MUST** be tested against an iPhone SE (or simulated 667px height) and **MUST** implement this scrolling fallback.
