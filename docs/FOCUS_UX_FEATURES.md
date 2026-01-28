# Focus-Friendly UX Features

This document outlines the specific features implemented to support users with Focus, focusing on reducing cognitive load, managing time blindness, and encouraging consistency.

## 1. "Quick Take" Swipe Gesture
**Problem**: Logging supplement intake required multiple taps (navigate to daily stack -> find item -> tap checkmark), which creates friction for users with Focus.
**Solution**: Implemented a swipe-right gesture on any supplement card in the Daily Stack.
- **Visual Feedback**: A green background with a checkmark icon appears behind the card as it is swiped.
- **Effect**: Instantly logs the supplement as taken and removes it from the "due" list.
- **Benefit**: Reduces the motor and cognitive effort required to keep logs accurate.

## 2. Time Urgency & Countdown
**Problem**: "Time blindness" makes it difficult for users with Focus to gauge how much time they have left before a dose is due or how long it has been since a dose was missed.
**Solution**: Dynamic time status labels on supplement cards.
- **Format**: 
  - `in 30m` / `in 2h 15m`: Countdown to scheduled dose.
  - `Overdue by 15m`: Clear indicator of missed time.
  - `Overdue`: If missed by more than 4 hours.
- **Implementation**: Normalizes broad time slots (Morning, Afternoon, Evening, Night) to specific anchor hours (08:00, 13:00, 18:00, 21:00) to provide relative urgency.

## 3. Persistent Nudge Notifications
**Problem**: A single notification is easily ignored or forgotten immediately after being dismissed.
**Solution**: A sequence of reminders.
- **Morning Sequence**:
  - `08:00`: Main reminder.
  - `08:15`: Warning nudge if not logged.
  - `08:30`: Final follow-up.
- **Evening Summary**:
  - `20:00`: A prompt to review the day's progress and "close the loop" on any unlogged items.
- **Benefit**: Creates multiple "re-entry points" for the user to remember their routine.

## 4. Simplified Onboarding
**Problem**: Long onboarding flows with too many decisions lead to "choice paralysis" and app abandonment.
**Solution**: Reduced the flow from 6+ steps to 3 core value-driven decisions.
1.  **Goal Selection**: Focuses on *why* the user is here (e.g., "Mental Clarity").
2.  **Safety Check**: High-impact decision about existing routines (Ensures safety early).
3.  **Direct-to-Dashboard**: Skips manual stack building initially, allowing users to explore pre-configured suggestions or add items contextually.

## 6. Progressive Disclosure for Cognitive Focus
**Problem**: Wellness and pharmacological data is dense and overwhelming, causing "cognitive freeze."
**Solution**: Collapsible information blocks in the Supplement Detail screen.
- **Implementation**: Pharmacology and dosage tables are hidden behind `ExpansionTile` headers.
- **Benefit**: Allows users to focus on high-level benefits (the "what") before choosing to dive into the technical details (the "how").

## 7. "Morning Fog Lifter" Template
**Problem**: Developing a routine from scratch is a high executive function task.
**Solution**: Pre-built "Starter Stacks" like the **Morning Fog Lifter**.
- **Components**: Vitamin D, Tyrosine, Alpha-GPC.
- **Benefit**: Provides a low-friction entry point for users specifically looking to overcome morning brain fog.
