# Roadmap: Version 2 (V2)

This document tracks technical improvements, optimizations, and features deferred from the initial launch to Version 2.

## Technical Optimizations

### 1. UI Performance & Granular Rebuilds
- **Problem**: Long Flutter framework stack traces detected in logs, indicating deep widget tree rebuilds and potential "jank" on high-traffic screens.
- **Proposed Solution**:
    - Port `HomeScreen` and `Dashboard` to use `Selector` or `context.select` instead of full-screen `Consumer` widgets.
    - Isolate the rebuild cycles of heavy components like the Progress Bar and the Daily Stack cards.
    - Implement an audit of `notifyListeners()` in `DailyStackViewModel` to ensure it's not called redundantly during large sync operations.

### 2. State Management Splitting
- **Proposal**: Split `DailyStackViewModel` into smaller, focused ViewModels (e.g., `LogStateViewModel`, `NavigationStateViewModel`) to further reduce rebuild impact.

## Future Features
- [ ] Science Hub (Science Library & Education)
- [ ] Advanced Insight Visualizations (V2)
- [ ] Community Focus Buddy deep-integration
- [ ] Medical Provider Export v2 (PDF formatting improvements)
