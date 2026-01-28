# Notification Service

This document describes the local notification infrastructure.

## Overview
The app uses `flutter_local_notifications` for scheduling and displaying local push notifications.

## Component

### `NotificationService` (Infrastructure Service)
**Location**: `lib/infrastructure/services/notification_service.dart`

**Key Methods:**
- `init()`: Initializes the native notification plugin (Android/iOS settings).
- `scheduleNotification({id, title, body, scheduledDate})`: Schedules a one-time notification.
- `scheduleRecurringNudgeSequence({baseId, title, body, hour, minute, mode})`: Schedules a 3-step automated nudge sequence (Gentle/Urgent).
- `cancelAllSupplementNudges(supplementId)`: Cancels all active nudges for a supplement.

**Android Configuration:**
- Channel ID: `focus_channel`
- Channel Name: `Focus Notifications`
- Importance: `max`
- Priority: `high`

## Current State
The service is fully functional as a local-first reminder engine. It supports:
- **Multi-stage escalation**: Automated 3-step nudges to overcome time blindness.
- **Contextual urgency**: `NotificationMode` for varying intensity.
- **Cleanup logic**: Atomic cancellation upon task completion.

## ADR Reference
- [ADR-004: Notification Architecture](file:///Users/lycanbeats/Desktop/focus_supplement_app/docs/adrs/004-notification-system-architecture.md)
- [ADR-011: Persistent Notifications](file:///Users/lycanbeats/Desktop/focus_supplement_app/docs/adrs/0011-persistent-notifications.md)
- [ADR-040: Standardized Nudge Cycle](file:///Users/lycanbeats/Desktop/focus_supplement_app/docs/adrs/0040-standardized-nudge-cycle.md)
- [ADR-045: Multi-Stage Nudge Sequences](file:///Users/lycanbeats/Desktop/focus_supplement_app/docs/adrs/0045-multi-stage-notification-nudge-sequences.md)
