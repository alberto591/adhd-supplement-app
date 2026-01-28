import '../entities/supplement_compatibility.dart';
import '../entities/routine_override.dart';

abstract class RoutineSafetyRepository {
  /// Get all known compatibilitys between a list of supplements
  Future<List<SupplementCompatibility>> getCompatibilitysForSupplements(
      List<String> supplementIds);

  /// Log a user's decision to override a safety warning
  Future<void> logRoutineOverride(RoutineOverride override);

  /// Get all safety overrides for a specific user
  Future<List<RoutineOverride>> getRoutineOverrides(String userId);

  /// Get a specific compatibility by ID
  Future<SupplementCompatibility?> getCompatibilityById(String id);
}
