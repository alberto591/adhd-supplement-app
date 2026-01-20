# System Patterns - Architecture Overview

## High-Level Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────┐ ┌──────────────┐ ┌───────────────────────────┐ │
│  │ Screens │ │   Widgets    │ │      View Models          │ │
│  └────┬────┘ └──────┬───────┘ └────────────┬──────────────┘ │
└───────┼─────────────┼──────────────────────┼────────────────┘
        │             │                      │
┌───────▼─────────────▼──────────────────────▼────────────────┐
│                    Application Layer                         │
│  ┌───────────────────┐  ┌──────────────────────────────────┐│
│  │   Use Cases       │  │        ViewModels (MVVM)         ││
│  │   (Services)      │  │ DailyStack, Library, Symptom     ││
│  └─────────┬─────────┘  └──────────────────────────────────┘│
└────────────┼────────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌──────────┐  ┌────────────┐  ┌──────────────────────────┐ │
│  │ Entities │  │  Services  │  │      Repositories        │ │
│  │Supplement│  │SafetyGuard │  │    (Port Interfaces)     │ │
│  │  Stack   │  │ Affiliate  │  │                          │ │
│  │ DailyLog │  │            │  │                          │ │
│  └──────────┘  └────────────┘  └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────────────┐
│                  Infrastructure Layer                        │
│  ┌───────────────┐  ┌─────────────┐  ┌────────────────────┐ │
│  │   Firebase    │  │ Notification│  │   Local Storage    │ │
│  │ Repositories  │  │   Service   │  │   (Hive/SQLite)    │ │
│  └───────────────┘  └─────────────┘  └────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Design Patterns Used

### 1. MVVM (Model-View-ViewModel)
ViewModels manage screen state and expose reactive getters.
```dart
class DailyStackViewModel extends ChangeNotifier {
  List<SupplementStack> _stacks = [];
  List<SupplementStack> get stacks => _stacks;
}
```

### 2. Repository Pattern
Abstract data sources behind interfaces (Ports).
```dart
abstract class StackRepository {
  Future<List<SupplementStack>> getUserStacks(String userId);
}
```

### 3. Service Locator (GetIt)
Dependency injection at the composition root.
```dart
final locator = GetIt.instance;
locator.registerLazySingleton<StackRepository>(() => FirebaseStackRepository());
```

### 5. Strategy Pattern (Safety Guards)
Multiple safety checking strategies that can be composed.
```dart
class SafetyGuard { ... }
class ADHDInteractionGuard { ... }
```

### 6. Command/Action Pattern (Dashboard)
Decoupling long-press and menu actions from screen builds.
```dart
void _showMedicationOptions(BuildContext context, Supplement supplement) { ... }
```

## UI/UX Patterns (Gold Standard)

### 1. Depth & Branding (Deep Focus Gold)
Standardized branding applied to all primary user-facing screens.
- **Font**: `Lexend` (Readability optimized for neurodivergent users).
- **Colors**: `primaryGold` (#D4AF37) for all primary actions/status.
- **Card Style**: Standardized `boxShadow` and `borderRadius: 16`.

### 2. Unified Navigation (5-Tab)
Standardized `UnifiedBottomNav` used across 5 root screens to prevent navigation drift.
1. **Today** -> Dashboard
2. **Stacks** -> DailyStack
3. **Insights** -> SuccessStats
4. **Library** -> ScienceHub/Discovery
5. **Profile** -> UserProfile

## Key Domain Entities
| Entity | Purpose |
|--------|---------|
| `Supplement` | Catalog item with benefits, dosage, interactions |
| `SupplementStack` | User's grouped supplements (Morning, Evening) |
| `DailyLog` | Daily intake record with timestamps |
| `User` | User profile with XP, Level, and preferences |
| `NightlyReflection` | Evening focus and sleep readiness data |
| `Report` | PDF-generated summary for clinicians |

## Navigation Architecture
Centralized routing via `AppRouter` using a mix of `MaterialPageRoute` (standard) and `UnifiedBottomNav` (persistent root).
