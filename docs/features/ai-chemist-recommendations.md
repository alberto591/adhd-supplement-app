# AI Chemist Recommendations

The AI Chemist is an advanced recommendation engine designed to provide personalized, science-backed supplement advice based on user-selected goals.

## Architecture

The system operates in two distinct layers:

### 1. Local "Smart Matching" Layer
This layer provides instant feedback by matching user goals to supplement benefits using pre-defined keyword mappings.

- **Entrance**: User selects goals during onboarding (e.g., "Better Sleep").
- **Logic**: The `LibraryViewModel` maps these goals to keywords (e.g., "sleep", "rest", "insomnia").
- **Filtering**: Supplements in the library whose benefits contain these keywords are prioritized in the "For You" tab.

### 2. "Deep Intelligence" AI Layer
This layer leverages the `PerplexityService` (powered by `sonar-reasoning-pro`) to perform clinical-style reasoning.

- **Trigger**: User taps the "Analyze" button in the Library.
- **Analysis**: The AI analyzes the user's goals and current stack.
- **Output**: Returns the Top 3 recommendations with specific "Chemist Notes" explaining the biochemistry behind the pick.

## Technical Details

- **Service**: `lib/infrastructure/services/perplexity_service.dart`
- **View Model**: `lib/presentation/view_models/library_view_model.dart`
- **UI Components**: In `LibraryScreen`, the AI section is conditionally rendered when the `currentStatus` is `recommended`.

## Maintenance

To update the AI's reasoning or the local matching logic:
1. Modify `_getKeywordsForGoal` in `LibraryViewModel` to tune local matching.
2. Update the `systemPrompt` in `PerplexityService.getPersonalizedRecommendations` to refine the AI's persona or output constraints.
