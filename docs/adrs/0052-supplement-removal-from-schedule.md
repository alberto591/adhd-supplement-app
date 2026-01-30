# 0052. Supplement Removal from Schedule

Date: 2026-01-30

## Status

Accepted

## Context

Users frequently need to adjust their daily routines based on personal experience with supplements (e.g., stopping a supplement due to side effects or lack of benefit). Previously, removing a supplement required navigating through the supplement detail page or settings, which was friction-heavy. The user requested a direct way to remove a supplement from their schedule from the "Today" dashboard.

## Decision

We will implement a "Remove from Schedule" feature accessible directly from the supplement options bottom sheet on the Today dashboard.

### Implementation Details:

1. **ViewModel Logic**:
   - `DailyStackViewModel` implements `removeSupplementFromStack(String supplementId, String slot)`.
   - The method identifies the target stack, filters out the supplement, and persists the updated stack.
   - It also cleans up today's log entries for that supplement to ensure immediate removal from the dashboard.

2. **UI/UX**:
   - A new action tile is added to the bottom sheet in `DailyStackScreen`.
   - The action is styled in **red** to indicate a destructive/permanent change.
   - A **Confirmation Dialog** is mandatory before proceeding to prevent accidental deletions.

3. **Localization**:
   - Full support for English, Spanish, and Italian is included for the action label, confirmation title, and confirmation message.

4. **Consistency**:
   - The feature uses existing `StackRepository` patterns to ensure cross-device sync and persistence.

## Consequences

**Positive:**
- Significant reduction in UX friction for routine adjustments.
- Empowers users to iterate on their "Daily Stack" quickly based on real-world feedback.
- Maintains data integrity by cleaning up log entries associated with the removed routine item.

**Negative:**
- Adds complexity to the `DailyStackViewModel`.
- Requires careful handling of "slot" parameters to ensure the correct stack is modified in multi-dose scenarios.
