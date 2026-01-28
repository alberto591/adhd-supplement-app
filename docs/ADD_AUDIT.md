# Audit: ADD (Predominantly Inattentive Type) Support

This audit evaluates the current application's support for users with ADD (Focus Predominantly Inattentive Presentation) and identifies opportunities for improvement.

## Current State

### 1. User Profile
- **Feature**: `focusType` field exists in the `User` model.
- **Values**: Users can select "Predominantly Inattentive" in their profile settings.
- **Impact**: Currently appears to be informational only, without driving significant logic changes in the app experience.

### 2. Notifications
- **Feature**: `NotificationMode` enum (`gentle`, `persistent`, `urgent`).
- **Relevance**: `NotificationMode.gentle` (every 15 mins) is likely more suitable for Inattentive types who may get overwhelmed by aggressive "Persistent" nags.
- **Gap**: The default might not auto-switch based on the selected `focusType`.

### 3. Supplements
- **Content**: The app covers broad Focus supplements but doesn't explicitly filter or highlight those best for *focus* and *alertness* vs. *calm*.
- **Gap**: No "Recommended for Inattentive Type" tags or filters.

## Recommendations for V2

### 1. "Gentle" Default for Inattentive Type
- **Logic**: If `focusType == 'Predominantly Inattentive'`, auto-set the default Notification Mode to **Gentle** instead of **Persistent**.
- **Rationale**: Inattentive users often drift off; aggressive buzzing can cause anxiety or paralysis. Gentle nudges act as "anchors" to bring them back.

### 2. Visual "Clutter Control" Mode
- **Feature**: A "Focus Mode" for the Dashboard that hides all non-essential stacks (e.g., hiding Evening/Night stacks during the morning).
- **Rationale**: Reducing visual noise is critical for the inattentive brain to prevent cognitive overload.

### 3. "Body Doubling" Features
- **Feature**: Highlight "Focus Buddies" or "Co-working" features more prominently for Inattentive users.
- **Rationale**: External accountability (body doubling) is a primary coping mechanism for inattentive Focus.

### 4. Smart Supplement filtering
- **Feature**: Tag supplements like *L-Tyrosine* or *Rhodiola Rosea* as "Inattentive Boosters" (for alertness/dopamine) vs. *Magnesium* (for Hyperactive/calm).
- **Rationale**: Tailors the "Supplement Intelligence" to the specific neurochemical gaps (often low arousal in ADD).

### 5. "Doom Scrolling" Interrupter
- **Feature**: A specific notification type: "Lost in scrolling? Here's your stack."
- **Rationale**: Inattentive types are prone to "time blindness" and getting stuck in low-dopamine loops.
