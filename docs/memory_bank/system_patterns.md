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

### 4. Strategy Pattern (Safety Guards)
Multiple safety checking strategies that can be composed.
```dart
class SafetyGuard { ... }
class ADHDInteractionGuard { ... }
```

## Key Domain Entities
| Entity | Purpose |
|--------|---------|
| `Supplement` | Catalog item with benefits, dosage, interactions |
| `SupplementStack` | User's grouped supplements (Morning, Evening) |
| `DailyLog` | Daily intake record with timestamps |
| `LogEntry` | Individual supplement intake event |
| `Medication` | User's ADHD medication for safety checks |
| `InteractionWarning` | Safety alert with severity level |

## Navigation Pattern
Centralized routing via `AppRouter` with named routes.
```dart
Navigator.pushNamed(context, AppRouter.dashboard);
```
