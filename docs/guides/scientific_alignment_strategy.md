# Scientific Alignment Strategy: Verified Research Sources

This document serves as the **Source of Truth** for the "Verified Research Sources" component in the NeuroStack application. It defines the standards for how scientific evidence is referenced, labeled, and presented to users.

## 1. Core Objective
The primary goal is to ensure that every claim made within the application is backed by verified clinical research, with internal descriptions that are strictly aligned with the official headers (titles) of the cited studies.

## 2. Alignment Standards

### 2.1 Header Integrity (Strict Alignment)
Internal titles used for citations MUST reflect the primary claim and target population of the official paper.
- **Rule**: Do not substitute scientific terms with marketing or simplified terms (e.g., if a study mentions "Anxiety," do not use "Focus" even if the supplement is used for focus).
- **Format**: `[Primary Finding/Outcome] ([Population/Methodology if critical])`.
- **Example**: 
    - *Incorrect*: "Omega-3 for Attention"
    - *Correct*: "Omega-3 supplementation for ADHD symptomatology in children"

### 2.2 Shorthand vs. Full Context
- **UI Shorthand**: In the `LibraryScreen` or `SupplementDetail` badges, shorthand may be used for space.
- **Source Link Key**: In `seeding_service.dart`, the key in the `studyLinks` map must be the aligned title that will appear as the clickable link.

### 2.3 Branding
- Use the localization key `scientificEvidence` across all trilingual files (EN, ES, IT).
- The English standard is: **"Verified Research Sources"**.

## 3. Technical Implementation

### 3.1 Domain Layer
The `Supplement` entity ([supplement.dart](file:///Users/lycanbeats/Desktop/adhd_supplement_app/lib/domain/entities/supplement.dart)) governs the structure:
- `studyLinks` (Map<String, String>): Stores the Aligned Title -> PubMed URL.
- `scientificEvidenceRank` (int): 1-100 score based on evidence quality.
- `participantCount` (int): Total cohort size across studies.

### 3.2 Seeding & Consistency
Default data in [seeding_service.dart](file:///Users/lycanbeats/Desktop/adhd_supplement_app/lib/infrastructure/services/seeding_service.dart) must pass a **Scientific Audit** before any new supplement is released.

## 4. Maintenance Workflow
When adding a new research source:
1. Verify the URL is from a reputable source (PubMed preferred).
2. Extract the exact paper title from the header.
3. Summarize the title into the **Aligned Title** following Rule 2.1.
4. Update trilingual versions in the `Supplement` entity's translations.

---
*Last Updated: 2026-02-09*
