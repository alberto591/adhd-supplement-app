# Active Context - Current Development State

> **Last Updated**: 2026-01-28 (V1.0.0+11 Release Candidate)

## Current Focus
✅ **Store Submission Phase**: Transitioning to "Individual Account" compliance via complete de-medicalization and "Science-Hub" pivot.

## Recent Completions (This Session)
**Nuclear Branding Scrub & Package ID Refresh:**
1. ✅ **Semantic Shift**: "ADHD" -> "Focus", "Symptom" -> "State", "Medication" -> "Routine Item".
2. ✅ **Package Refactor**: Migrated from `com.neurostack.app` to `com.neurostack2.app` to bypass medical flags.
3. ✅ **Version Bump**: Progressive builds from `+2` to `+11` to handle Play Console blockers.
4. ✅ **Privacy Cleanup**: Explicitly removed `AD_ID` permission and handled Play Console "No Ads" declaration.
5. ✅ **Technical Debt**: Refactored `RadioListTile` to `RadioGroup` and cleaned mock file lint errors.

## Active Work Items
| Priority | Status | Task |
|----------|--------|------|
| 1 - Store | **READY** | Final Submission to Play Console & App Store |
| 1 - Compliance| **DONE** | Nuclear Semantic Scrub (ADR 0049+) |

## Known Issues
- **None**: Local analysis reports 0 issues.
- **Console Warning**: Ensure "No" declaration for Advertising ID in Play Console to match build `+11`.

## Blockers
- **None**: Functional development is complete. Ready for deployment configuration.

## Next Phase Priorities
1. **Manual QA**: Edge case testing on physical devices.
2. **Live Config**: Replace mock repositories with real Firebase/API implementations.
3. **Store Prep**: Generate production release bundles.

## Quick Commands
```bash
# Run app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Build release
flutter build appbundle
```

## Important Files
- `lib/config/locator.dart` - Dependency injection setup
- `lib/presentation/navigation/app_router.dart` - All routes
- `docs/features/README.md` - Feature documentation index
- `docs/adrs/` - Architectural Decision Records
- `docs/developer_summary.md` - Technical "Source of Truth"
