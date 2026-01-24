# ADR 0040: Standardized 3-Step ADHD Nudge Cycle

**Date:** 2026-01-24  
**Status:** Accepted  
**Deciders:** Antigravity (AI Architect), User

## Context

ADHD users often experience "time blindness" and can easily dismiss or forget a single notification. While ADR 0011 established a 3-tier persistent notification system, it lacked a specific, automated escalation timeline that standardizes how the app "nudges" the user without requiring manual snoozing for every interval.

## Decision

Implement a specific **3-step automated nudge cycle** for all scheduled supplements and stacks. This cycle is designed to overcome hyperfocus/time blindness by increasing the frequency and urgency of alerts in the critical "post-dose" window.

### The Cycle Definition

1.  **Soft Nudge (+5 min)**: A gentle reminder that the target time has passed.
2.  **Medium Nudge (+15 min)**: A follow-up to ensure visibility if the first was missed.
3.  **CRITICAL Alert (+30 min)**: A final high-priority alert marking the dose as significantly overdue.

### Technical Implementation

- **PersistentRemindersViewModel**: Calculates the offsets based on the user's `nudgeTime` or specific slot schedule.
- **NotificationService**: Maps these offsets to unique notification IDs (offset + 1000) to allow concurrent active nudges.
- **nudge_engine.py**: A maintenance script provided for developers to verify and test the schedule logic.

```dart
// Logic in PersistentRemindersViewModel
await _notificationService.scheduleRecurringNotification(
  id: 1000, 
  title: 'Soft Nudge (+5m)',
  hour: time.hour,
  minute: time.minute + 5,
);
```

### Smart Cancellation Rule

All active nudges for a specific supplement or stack MUST be canceled immediately upon a "Take" action in the `DailyStackViewModel`. This prevents the "notification spam" effect where users are reminded of a task they just completed.

## Consequences

**Positive:**
- Automated persistence: Users don't need to manually snooze; the app handles the "pestering" logic.
- Predictability: Users learn the rhythm of the app's reminders.
- Smart Cleanup: No annoying alerts after the dose is logged.

**Negative:**
- Increased notification volume during the first 30 minutes.
- Complexity in ID management for overlapping reminders.

## Mitigations
- Unique ID ranges (1000-1003) for the nudge cycle.
- Global `cancelAllNotifications` utility in the System Health screen for emergency resets.
