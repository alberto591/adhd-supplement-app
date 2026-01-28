# 4. Safety Guard System Implementation

Date: 2026-01-18

## Status

Accepted

## Context

Supplement interactions with prescription Focus routines (specifically stimulants) pose a significant health/efficacy risk. For example, Vitamin C can drastically reduce the effectiveness of amphetamines. Users need a reliable way to check these interactions.

## Decision

We will implement a **SafetyGuard** logic engine and UI component.

### Logic (`FocusInteractionGuard`)
- **Mechanism**: Cross-reference user-selected routines against a database of interaction rules.
- **Critical Rule**: Explicitly flag **High-Dose Vitamin C (>500mg) + Amphetamine Stimulants**.
- **Explanation**: Warnings must explain *why* the interaction occurs (e.g., "Increased GI/urinary acidity flushes routine faster").

### UI (`SafetyGuardWidget`)
- **Input**: specific dropdowns for "Your Routine" (e.g. Adderall, Vyvanse) and "Supplement".
- **Feedback**: Immediate visual feedback.
    - **Safe**: Green Checkmark (`#00E676`).
    - **Interaction**: Amber Warning (`#FFAB40`) with explicit "Timing Tip" (space by 2 hours).
- **Legitimacy**: Include direct links to wellness sources (e.g., PubMed) for verification.
- **Disclaimer**: Mandatory standard wellness disclaimer on all results.

## Consequences

### Positive
- **User Safety**: Proactively prevents common efficacy issues with routine.
- **Trust**: Providing wellness reasoning and source links builds authority and trust.

### Negative
- **Liability Risk**: Providing health information carries risk. We mitigate this with strict disclaimers stating "this is not wellness advice."
- **Maintenance**: Interaction rules must be kept up-to-date with wellness research.
