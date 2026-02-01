# ADR 0056: Responsive Layout Strategy (Small Device Handling)

## Status
Accepted

## Context
The application supports a wide range of iOS sizes, from the iPhone SE (1st/2nd Gen) to the iPhone 15 Pro Max.
Early testing revealed critical UI regressions on small screens:
- **Bottom Overflow**: Fixed-height columns caused "yellow branding tape" overflow warnings on 4.7" screens.
- **Unreachable Buttons**: Action buttons at the bottom of the screen were pushed off-viewport.
- **Inconsistent Scrolling**: Some screens were static, trapping content on small viewports.

## Decision
We will standardize on a **Fluid Scroll Layout** strategy for all content-heavy screens.

### 1. `CustomScrollView` + `SliverFillRemaining`
For screens that need to center content on large devices but scroll on small ones (e.g., Onboarding, Paywalls):
- Use `CustomScrollView` as the root body.
- Wrap content in `SliverFillRemaining(hasScrollBody: false)`.
- Use `Spacer()` within the content column to distribute space on large screens.
- When the screen is too small, `SliverFillRemaining` allows the content to scroll naturally.

### 2. `SingleChildScrollView` for Modals/Skeletons
For simpler wrappers or skeleton loaders:
- Wrap the column in `SingleChildScrollView`.
- Ensure no fixed heights are strictly enforced unless media queries confirmation is present.

## Consequences
### Positive
- **Zero Overflows**: No more bottom overflow errors.
- **Universal Design**: One layout code path handles both SE and Max sizes.
- **Native Feel**: Bouncing scroll physics feels native on iOS.

### Negative
- **Complexity**: Slightly more verbose than a simple `Column`.
- **Keyboard Handling**: Requires careful management with `KeyboardAvoidView` (handled separately).

## Compliance
All future UI screens must be tested against an iPhone SE (or simulator equivalent) to verify this behavior.
