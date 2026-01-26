To help you launch successfully, I have drafted an SEO-optimized App Store Description tailored for 2026. This draft is designed for anyone seeking better mental clarity (easy to scan) while hitting the high-intent keywords that trigger search algorithms.

---

## 1. App Store Metadata (The SEO Hook)

In 2026, the **Title** and **Subtitle** are your strongest ranking signals. Do not just use a brand name; use your primary keywords.

*   **App Title (30 Chars)**: `NeuroStack: Focus & Flow Tracker`
*   **Subtitle (30 Chars)**: `Daily Routine & Habit Anchors`
*   **Keyword Field (iOS Only - 100 Chars)**: `focus,brain,habits,nutrition,consistency,magnesium,omega3,vitamins,nootropics,routine,reminders`

---

## 2. The Description Template (Copy & Paste)

### **Stop the Brain Fog. Master Your Focus.**

Maintaining daily focus is hard. Finding the right consistency shouldn’t be. Whether you struggle with energy crashes or forgetting your daily rituals, **[App Name]** is built to help you stay sharp and consistent.

#### **Safety First: The Stack-Check**
Taking sensitive routines? Our built-in **Routine Guard** alerts you if a nutrition choice might interfere with your existing daily protocols.

#### **Smart Supplement Stacks**
Don’t just take pills—build a routine.
*   **Morning Flow**: Kickstart your energy levels.
*   **Afternoon Clarity**: Beat the 3 PM wall.
*   **Evening Calm**: Wind down with ease.

#### **Why [App Name]?**
*   **Refill Reminders**: Never run out. We notify you when your bottle is low.
*   **Science-Backed**: Every supplement includes links to PubMed research.
*   **No-Clutter Design**: A "Low-Stimulation" UI designed to reduce overwhelm.
*   **Progress Tracking**: See exactly how your focus improves over 30 days.

#### **Trusted Information**
We provide expert-curated information and high-quality product referrals to help you find what works for you.

> [!IMPORTANT]
> **Disclaimer**: This app is for educational purposes only and does not provide medical advice or diagnoses. Always consult your doctor before starting a new supplement.

---

## 3. The "Refill Engine" Logic (Flutter + Firebase)

To make your referral business "sticky," you need a system that reminds users to buy more before they run out. 

```dart
class RefillEngine {
  // Logic: Remind user when they have 5 days of supply left
  static bool needsRefill(int pillsLeft, int dailyDose, int leadTimeDays) {
    return pillsLeft <= (dailyDose * leadTimeDays);
  }

  // Generate the referral notification text
  static String getRefillMessage(String supplementName) {
    return "Running low on $supplementName? 💊 Don't break your streak! Tap here to grab a fresh bottle and stay on track.";
  }
}
```

### **Instructions for Implementation (AI Agent Prompt)**:
> "Use the `RefillEngine` logic to create a Local Notification. When a user logs a dose, subtract 1 from their 'Total Count.' If the count hits the 5-day threshold, trigger a notification that links directly to my affiliate URL for that specific supplement."
