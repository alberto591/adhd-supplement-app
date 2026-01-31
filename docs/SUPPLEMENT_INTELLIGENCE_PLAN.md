# Supplement Intelligence & Data Plan

## 1. Classification & Ratings (Stars)
**Problem**: Currently all supplements default to 3/5 stars for `focusLevel`.
**Proposed Solution**: Implement a dynamic rating system based on:
- **Evidence Level**: High (5 stars), Moderate (4 stars), Low (3 stars).
- **Focus-Specific Utility**: Boost or penalize based on study relevance to Focus.
- **User Feedback**: (Future) Aggregate user efficacy scores.

### Implementation Status:
- [x] Update `SeedingService` with varied `focusLevel` and `scientificEvidenceRank`.
- [x] **Trilingual Support**: All supplement data is now localized in EN, IT, and ES.
- [x] **Expanded Detail Info**: Added `mechanismOfAction`, `detailedBenefits`, `timingRationale`, `dosageFrequency`, and `dosageWarnings` to all supplements.
- [x] **CI/CD Symbolization**: Automated dSYM and mapping file identification for Crashlytics.

---

## 4. Next Steps
1. **Verification**: Run `check_translations.py` regularly to ensure data integrity during updates.
2. **UI Polish**: Ensure `SupplementDetailScreen` renders all new fields (detailed benefits, warnings) with optimal focus UX.
3. **User Feedback Integrated**: Future phase will aggregate efficacy scores for dynamic `focusLevel` adjustment.
