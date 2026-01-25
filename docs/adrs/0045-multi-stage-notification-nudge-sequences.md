# ADR 0045: Multi-Stage Notification Nudge Sequences

**Date:** 2026-01-25  
**Status:** Accepted  
**Deciders:** Antigravity (AI Architect), User

## Context

ADHD users face significant challenges with "time blindness" and task switching. A single notification is often dismissed and immediately forgotten. ADR 0040 established the concept of a 3-step nudge cycle, but the initial implementation relied on the View Model to schedule individual notifications. This led to fragmented logic and potential inconsistencies in how sequences were handled.

## Decision

Centralize the multi-stage nudge logic within the `NotificationService` through a dedicated `scheduleRecurringNudgeSequence` method. This allows the service to encapsulate the timing, content escalation, and urgency patterns, providing a cleaner API for View Models.

### Technical Implementation

A new method in `NotificationService` was introduced:

```dart
Future<void> scheduleRecurringNudgeSequence({
  required int baseId,
  required String title,
  required String body,
  required int hour,
  required int minute,
  required NotificationMode mode,
});
```

- **ID Mapping**: The service automatically generates unique IDs for the sequence stages (e.g., `baseId`, `baseId + 1`, `baseId + 2`).
- **Escalation Pattern**:
  - **Stage 1 (T+0)**: Initial reminder with custom body.
  - **Stage 2 (T+15m)**: "Warned" state nudge with increased urgency in message.
  - **Stage 3 (T+30m)**: "Critical" state nudge with high-urgency signaling.
- **Mode-Based Logic**: The `NotificationMode` enum (Gentle, Urgent) allows for varying the intensity and frequency of the sequence without changing the calling code.

### Cancellation Consistency

The `cancelAllSupplementNudges` method ensures that all stages of a sequence are cleared simultaneously when a user logs an intake, preventing "ghost notifications" for completed tasks.

## consequences

### Positive
- **Modularity**: Domain/Application layers don't need to know the specifics of notification timing.
- **Reliability**: Centralized logic reduces the risk of missed nudges in the sequence.
- **Scalability**: New escalation patterns or modes can be added to the service without refactoring every call site.

### Negative
- **ID Collisions**: Requires strict enforcement of ID ranges to ensure separate supplement sequences don't overwrite each other.

## Mitigations
- Standardized ID offsets (+10, +20 etc.) are used within the service to isolate sequence stages.
- The `NotificationMode` provides a path for Future 1:1 user customization of intervals.
