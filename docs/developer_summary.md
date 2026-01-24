# FocusStack: Developer Handoff Summary

This document serves as the technical "Source of Truth" for building the FocusStack backend and integrating it with the frontend.

## 1. Core Logic & State Triggers

### The "Persistent Nudge" (Critical)
- **Trigger**: Stack scheduled time reached.
- **Logic**: Send Push Notification. If no "Taken" event is received from the client within 5 minutes, repeat the notification.
- **Metadata**: Increment "Nudge Count" metadata.
- **Stop Condition**: Stop only upon "Taken" or manual "Snooze" (5m delay).

### XP & Gamification
- **Trigger**: "Mark as Taken" event.
- **Logic**: Increment User XP by +10.
- **Streaks**: If 7-day consistency is met, trigger "Badge Unlock" event.

### The "Grace Day" System
- **Trigger**: End of day (00:00) with no "Taken" log.
- **Logic**: Check User `grace_day_balance`.
  - If > 0, decrement by 1 and preserve the `current_streak`.
  - If 0, reset `current_streak` to 0.

## 2. Safety & Medical Engine

### Real-time Interaction Scan
- **Trigger**: Adding a supplement to a Stack or during initial Onboarding.
- **Logic**: Cross-reference `new_supplement_id` with User `medication_ids` (e.g., Stimulants).
- **Conflict Handling**: If a conflict exists (e.g., Vitamin C + Amphetamines), return the `Safety_Alert` object and block "Taken" until a `Safety_Override` is confirmed.

### Late Dose Triage
- **Trigger**: User attempts to log a stack > 3 hours after scheduled time.
- **Logic**: Instead of direct logging, serve the `Triage_Modal`.
- **States**: Options must map to different database flags: `log_as_late`, `skip_dose`, or `adjust_backdate`.

## 3. Data Schema Requirements

### Supplements Table
- `id`
- `name`
- `benefit_tag`
- `evidence_level`
- `shape_icon`
- `color_hex`
- `interaction_warnings`

### User Stacks Table
- `id`
- `user_id`
- `name` (e.g., Morning Focus)
- `scheduled_time`
- `supplement_list` (array of IDs)

### Daily Logs Table
- `id`
- `user_id`
- `stack_id`
- `timestamp`
- `mood_score`
- `focus_score`
- `status` (taken/skipped/late)

## 4. Frontend-Backend Syncing

### Offline First
- The app must allow logging without a connection.

### Conflict Resolution
- On reconnection, the client pushes local logs.
- If a log exists for the same `stack_id` on the server, the server timestamp takes priority unless marked as "Backdated."

## 5. Technical Navigation Map

### Primary Bottom Nav (V1.0)
- **Today**: Daily checklist and focus state.
- **Library**: Supplement encyclopedia and stack creation.
- **Hub**: (Gated) Expert-verified ADHD science and community.
- **Profile**: Settings, gamification levels, and medical configuration.

## 6. Premium Gating & V1.0 Strategy

### Pre-Revenue Architecture
- **State**: The `SubscriptionViewModel` is set to "Coming Soon" mode.
- **Logic**: All active `purchase` and `restore` calls are deactivated to allow for a free v1 distribution.

### Gating Triggers
- **Static Guards**: `AppRouter` intercepts navigation to `insights`, `stackBuilder`, and `scienceHub` for users without active entitlements.
- **UI Gating**: Premium entry points must display the `AppColors.primaryGold` lock icon.
- **Redirection**: Unauthorized access attempts trigger the `PaywallScreen`, which uses history-preserving `pushNamed` navigation to allow graceful "Back" behavior.
