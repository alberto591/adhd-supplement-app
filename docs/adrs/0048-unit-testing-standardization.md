# 0048. Unit Testing Standardization

Date: 2026-01-25

## Status

Accepted

## Context

The project has grown to include complex view models, repositories, and services. As the code quality standards (ADR 0020) enforce robustness, there is a need for a unified approach to unit testing to ensure consistency, reliability, and maintainability. Inconsistent testing patterns lead to flaky tests, lower coverage confidence, and increased onboarding time for new developers.

## Decision

We will standardize unit testing using the following libraries and patterns:

### 1. Libraries
- **Core Framework**: `flutter_test` for all unit and widget tests.
- **Mocking**: `mockito` with `@GenerateNiceMocks` for stubbing dependencies.
- **Matchers**: Standard `package:flutter_test` matchers (e.g., `throwsA`, `isA`).

### 2. File Organization
- Tests must mirror the `lib/` directory structure within the `test/` folder.
- **Example**:
    - Source: `lib/application/view_models/user_view_model.dart`
    - Test: `test/unit/application/view_models/user_view_model_test.dart`

### 3. Test Structure
All test files must follow this structure:
1.  **Imports**: Standard order (Flutter, packages, project imports).
2.  **Mocks Generation**: `@GenerateNiceMocks` annotation at the file level.
3.  **Setup**: A `setUp()` function to initialize SUT (System Under Test) and mocks for every test.
4.  **Grouping**: Use `group('Method Name', ...)` to organize tests by the method being tested.
5.  **Naming**: Test descriptions should follow the pattern: "should [expected result] when [condition]".

### 4. Mocking Strategy
- Do **not** mock value objects or simple data classes (DTOs, Entities).
- **Do** mock external dependencies: Repositories, Services, and Providers.
- Use `when(...).thenReturn(...)` or `thenAnswer(...)` for success scenarios.
- Use `when(...).thenThrow(...)` for error parsing scenarios.

### 5. Scope
- **View Models**: Test initial state, state transitions, method calls, and error handling.
- **Repositories**: Test mapping logic, exception handling, and data transformation.
- **Services**: Test logic flows and external package interactions (wrappers).

## Consequences

**Positive:**
- Consistent test suites make it easier to debug regressions.
- Higher confidence in refactoring due to standardized verification patterns.
- Clear separation of concerns between unit tests and integration tests.

**Negative:**
- Initial setup overhead for declaring mocks in every test file (mitigated by `build_runner`).
- Requires maintenance of mock signatures when interfaces change.

## Compliance
- All new features defined in implementation plans must include a "Verification Plan" section referencing these standards.
- Run `flutter test` before merging any PR.
