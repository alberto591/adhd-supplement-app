# Daily Stack & Logging System

This document describes the core routine tracking and logging functionality.

## Overview
The "Daily Stack" is the heart of the app. Users build routines (Morning, Evening) with supplements, and the app tracks their adherence over time.

## Components

### 1. `DailyStackViewModel` (Presentation Layer)
**Location**: `lib/presentation/view_models/daily_stack_view_model.dart`

Manages the user's daily routine and intake logging.

**State:**
- `_stacks`: List of `SupplementStack` (Morning, Evening, etc.).
- `_todayLog`: `DailyLog` object for today's date.
- `_streakCount`: Consecutive days of completion.

**Key Methods:**
- `initialize()`: Loads stacks, today's log, and streak count in parallel.
- `markSupplementTaken(String supplementId)`: Logs intake.
- `markSupplementSkipped(String supplementId, {String? reason})`: Logs a skip.
- `toggleSupplement(String supplementId)`: Toggle taken/untaken.
- `isSupplementTaken(String supplementId)`: Check status.
- `saveSymptomRatings(Map<String, int> ratings)`: Save mood/focus/energy ratings.

**Computed Getters:**
- `todayProgress`: Double from 0.0 to 1.0.
- `progressText`: e.g., "2 of 3 stacks completed".

### 2. `HistoryLogViewModel` (Presentation Layer)
**Location**: `lib/presentation/view_models/history_log_view_model.dart`

Manages historical log viewing and filtering.

**State:**
- `_logs`: List of `DailyLog` for the past N days.
- `_selectedFilter`: `All`, `Taken`, `Missed`, `Dismissed`.

**Key Methods:**
- `initialize({int days = 30})`: Load recent history.
- `loadDateRange(DateTime start, DateTime end)`: Custom range.
- `setFilter(String filter)`: Filter entries.
- `getFilteredEntries(DailyLog log)`: Apply filter to a specific day's log.

**Computed Getters:**
- `groupedLogs`: Groups by "Today", "Yesterday", "This Week".
- `stats`: `{'total': N, 'taken': N, 'missed': N, 'completionRate': N}`.

### 3. `LibraryViewModel` (Presentation Layer)
**Location**: `lib/presentation/view_models/library_view_model.dart`

Manages the supplement discovery/search library.

**Key Methods:**
- `initialize()`: Load all supplements.
- `search(String query)`: Remote search.
- `filterByCategory(String? category)`: Local filter.
- `clearFilters()`: Reset.
- `getSupplement(String id)`: Fetch by ID.

**Computed Getters:**
- `categories`: Unique list of supplement categories.

## Data Entities
- `SupplementStack`: `{ id, name, userId, items: [...], time, isActive }`.
- `DailyLog`: `{ id, userId, date, entries: [...], symptomRatings, createdAt }`.
- `LogEntry`: `{ supplementId, takenAt, taken, skippedReason }`.
- `Supplement`: `{ id, name, category, benefits, dosage, amazonAsin, ... }`.

## Repositories (Domain Ports)
- `StackRepository`: CRUD for user stacks.
- `LogRepository`: Stores daily logs, streak calculation.
- `SupplementRepository`: Fetches supplement catalog.

## Firebase Implementations (Infrastructure)
- `FirebaseStackRepository`
- `FirebaseLogRepository`
- `FirebaseSupplementRepository`

> **Note**: These require a configured Firebase project. See `firebase_options.dart`.
