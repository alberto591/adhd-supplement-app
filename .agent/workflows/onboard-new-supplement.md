---
description: Workflow for adding new supplements to the NeuroStack library ensuring medical compliance.
---

# /onboard-new-supplement

This workflow ensures that every new supplement added to the NeuroStack library meets our strict scientific evidence and trilingual localization standards.

## 1. Research & Data Gathering
Collect the following for the new supplement:
- **Scientific Evidence Rank (0-100)**: Based on meta-analyses and consensus.
- **Mechanism of Action**: Clear, evidence-based description.
- **Study Links**: At least 3 links to peer-reviewed studies (PubMed preferred).
- **Dosage Guidelines**: 4 weight tiers (40-60kg, 60-80kg, 80-100kg, 100-120kg).

## 2. Translation Preparation
Translate all strings into **Italian** and **Spanish**.
- Ensure `studyLinks` keys are translated to the target language.
- Maintain consistent terminology (e.g., use "concentrazione" consistently in Italian).

## 3. Implementation in `seeding_service.dart`
Add the supplement map to `defaultSupplements` list.
- **CRITICAL**: Use the exact same identifiers (anchors) for `detailedBenefits` and `studyLinks` across all languages to ensure the UI can cross-reference them.

## 4. Verification
- Run `dart analyze lib/infrastructure/services/seeding_service.dart` to check for syntax errors.
- Verify the new ID is unique.
- Trigger a manual build check via `workflow_dispatch` if needed.

## 5. Compliance Check
- Cross-reference with `med-safety-checker` skill.
- Ensure "Avoid" items have clear "Core Impacts" in their benefits.
