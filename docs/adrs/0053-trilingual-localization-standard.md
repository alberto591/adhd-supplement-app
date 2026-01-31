# 0053. Trilingual Localization & CI/CD Optimization Standard

Date: 2026-01-31

## Status

Accepted

## Context

The application is expanding to Italian and Spanish markets. Previously, supplement data was primarily in English, with minimal localization. Additionally, tracking production crashes required manual symbolication, which was slow and error-prone. We needed a scalable way to seed rich, trilingual supplement data and ensure production stability through automated CI/CD symbolization.

## Decision

We will implement a trilingual (EN, IT, ES) localization standard for all core supplement data and automate the Firebase Crashlytics symbol upload process.

### Implementation Details:

1. **Trilingual Seeding**:
   - `SeedingService` now includes complete translations for `name`, `description`, `mechanismOfAction`, `detailedBenefits`, `timingRationale`, `dosageFrequency`, `dosageWarnings`, and `tldr`.
   - Data is stored in a structured JSON-like map within `seeding_service.dart`, facilitating easy updates and consistency across languages.
   - A `check_translations.py` script ensures all required fields are present in all three languages.

2. **Safety-First Warnings**:
   - Every supplement and food additive entry includes localized `dosageWarnings` to prioritize user safety and ADHD-specific guidance (e.g., avoiding certain food dyes).

3. **CI/CD Optimization**:
   - GitHub Actions workflow (`build.yml`) is enhanced to automatically identify and isolate `dSYM` symbols (iOS) and `mapping.txt` files (Android).
   - The `upload-symbols` script from the Firebase Crashlytics Pod is used to automate the upload process directly during the build phase.

## Consequences

**Positive:**
- Seamless user experience for Italian and Spanish speakers.
- Elevated safety standards through localized, ADHD-specific warnings.
- Significantly improved production debuggability through automated symbolication.
- Reproducible and verifiable data seeding process.

**Negative:**
- Increased maintenance overhead for `seeding_service.dart` (requires translation for every new supplement).
- Build times may slightly increase due to the symbol upload step.
- Requires careful management of Firebase credentials in CI/CD environments.
