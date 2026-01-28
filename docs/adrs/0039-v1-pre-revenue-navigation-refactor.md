# ADR 0039: V1 Pre-Revenue Navigation & Premium Gating Refactor

## Status
Accepted

## Context
For the initial Version 1.0 release, the application will be distributed as a free-to-use experience without active revenue implementation (Stripe/RevenueCat). However, we want to maintain visibility of premium features to tease future releases (V2.0) and encourage early adoption. The existing navigation bar was cluttered with 5 items, and premium features like the "Stack Builder" were accessible without clear gating or "Coming Soon" messaging.

## Decision
1. **Simplified Navigation**: Reduced the bottom navigation bar to 4 core items: Today, Library, Hub (Science Hub), and Profile. The "Stacks" tab was removed to simplify the user journey.
2. **Coming Soon State**: Refactored the `PaywallScreen` to a "Coming Soon" state. Removed pricing cards and trial buttons, replacing them with an announcement for V2.0 and "Free for Early Adopters" branding.
3. **Revenue Logic Deactivation**: Safely commented out the Stripe and RevenueCat logic in the `SubscriptionViewModel`.
4. **Universal Premium Gating**: 
    - Implemented lock icons on all premium entry points (Stack Builder buttons, Insights tiles, Science Hub tab).
    - Updated `AppRouter` to intercept premium routes (Insights, Stack Builder, Science Hub) and redirect free-tier users to the "Coming Soon" Paywall.
5. **History-Preserving Navigation**: Updated premium routes to use `pushNamed` instead of `pushReplacementNamed` to ensure the back button correctly returns the user to their previous context from the Paywall.

## Consequences
- **Positive**: Clear product roadmap for users; professional handling of pre-revenue state; simplified UI/UX; improved navigation reliability.
- **Negative**: Adds conditional logic for lock icons and routing in multiple places.
- **Neutral**: Requires manual updating of flags when transitioning to active revenue in V2.0.

## Compliance
- **Focus UI Optimizer**: Simplifies navigation and reduces cognitive load by removing the redundant "Stacks" tab.
- **Med-Safety Checker**: Ensures users are notified that advanced safety features are part of the upcoming Pro tier.
- **Architecture**: Maintains clean separation by gating at the Router level and using the existing `AuthProvider` for entitlement checks.
