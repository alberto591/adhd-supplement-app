# ADR 0042: Library Metadata & Self-Repair Mechanism

**Date:** 2026-01-24  
**Status:** Accepted  
**Deciders:** Antigravity (AI Architect), User

## Context

The Library feature's advanced filters (Form, Category, etc.) rely on specific metadata attached to each `Supplement` document in Firestore. In the transition to production data, some global supplements were missing the `"form"` field, causing filters to return zero results and degrading the user experience.

## Decision

Implement a **Self-Repair Mechanism** that allows the app to fix its own metadata without requiring a full app update or manual Firestore editing.

### Components

1.  **Metadata Enrichment**: The `SeedingService` was updated with a comprehensive mapping of "form" data (Capsule, Tablet, Liquid, etc.) for all primary supplements.
2.  **Repair UX**: A dedicated "Refresh Library Data" card was added to the `SystemHealthScreen`. 
3.  **Client-Side Logic**: Triggering this repair runs a batch update that overwrites existing supplement documents with the enriched metadata.

## Consequences

**Positive:**
- Immediate Recovery: Functional filters for existing users without data migrations.
- Extensibility: New metadata fields (e.g., pH balance, absorption rate) can be pushed to users using the same "Refresh" pattern.
- Robustness: The app provides a clear path for users to "fix" data inconsistencies themselves.

**Negative:**
- Overwrites custom edits: If global supplements were manually edited in Firestore, the seeding process will overwrite those changes (though global supplements are generally read-only for users).

## Mitigations
- The process is clearly labeled in the "System Health" section, intended for advanced troubleshooting or initialization.
- Added SnackBar feedback to confirm successful repair.
