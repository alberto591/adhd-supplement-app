# ADR 0043: Slot-Aware Intake Tracking

## Status
Accepted

## Context
A bug was identified where users taking multiple doses of the same supplement (e.g., Acetyl-L-Carnitine in both Morning and Afternoon stacks) would have their progress overwritten. Taking the afternoon dose would delete or replace the morning dose's log entry, causing daily progress percentages to fluctuate and preventing cumulative XP gains.

## Decision
We decided to make the daily intake logging system "slot-aware." 
1. **Key Matching**: The `LogEntry` now includes an optional `slot` field (e.g., 'morning', 'afternoon').
2. **Replacement Logic**: In `DailyStackViewModel.dart`, the `_updateTodayLog` method was modified to check for both `supplementId` AND `slot` when determining if an existing entry should be replaced.
3. **Progress Calculation**: All progress-related getters (`todayProgress`, `pendingItems`, `skippedItems`) were updated to iterate through stacks and their specific slots rather than treating supplement IDs as global unique keys for the day.

## Consequences
- **Positive**: Accurate tracking for multi-dose regimens.
- **Positive**: Correct gamification (XP) behavior for every dose taken.
- **Positive**: Improved reliability of the "Daily Completion" metric.
- **Negative**: Increased complexity in the mapping between `SupplementStack` items and `DailyLog` entries.

## Compliance
- **Focus UI Optimizer**: Supports "Reward Consistency" and "Progress Visuals."
- **Architecture**: Adheres to the Repository pattern by extending the `LogEntry` domain entity effectively.
