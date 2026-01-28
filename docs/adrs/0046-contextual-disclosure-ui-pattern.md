# ADR 0046: Contextual Disclosure and Cognitive Load Management

**Date:** 2026-01-25  
**Status:** Accepted  
**Deciders:** Antigravity (AI Architect), User

## Context

Focus users often struggle with large blocks of text and dense information (the "wall of text" effect). The supplement detail screen provides critical safety and scientific data, but displaying all of it simultaneously can cause cognitive overwhelm, leading users to skip reading important warnings or technical mechanics.

## Decision

Implement a **Contextual Disclosure** pattern in the `SupplementDetailScreen` using collapsible sections (`ExpansionTile`).

### The Design Pattern

- **Immediate Visibility**: High-priority information (Name, Key Benefits, Active Status, Standard Dose) remains immediately visible in the main scroll view.
- **Progressive Disclosure**: Technical and secondary information is grouped into collapsible headers:
  - **Pharmacology & Mechanism**: Detailed scientific explanation of *how* the supplement works.
  - **Dosage & Forms**: Specific weight-based dosage tables and available forms.
- **Visual Distinction**: Headers use high-contrast styling and clear icons to denote their purpose.

## Consequences

### Positive
- **Reduced Overwhelm**: Users can focus on the core benefits first and dive deeper only when they have the cognitive energy/interest.
- **Improved Information Hierarchy**: Clearly separates "need to know" from "nice to know."
- **Visual Breathing Room**: The overall screen length is significantly reduced, making navigation easier.

### Negative
- **Hidden Information**: Crucial safety warnings could theoretically be hidden if placed in a collapsed section (Mitigation: Safety alerts are ALWAYS displayed as banners at the top of the screen).

## Mitigations
- Safety-critical warnings (Routine Interactions) are NEVER placed in collapsible sections; they remain as prominent, high-contrast banners.
- Expanded states are maintained during the session to avoid frustrating users who are trying to cross-reference data.
