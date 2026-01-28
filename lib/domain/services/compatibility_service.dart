import '../entities/supplement.dart';
import '../entities/routine_element.dart';

abstract class CompatibilityService {
  /// Check if a supplement is compatible with any of the user's routine elements.
  /// Returns a list of [CompatibilityGuidance]s.
  Future<List<CompatibilityGuidance>> checkRoutineOptimization({
    required Supplement supplement,
    required List<RoutineElement> userElements,
  });

  /// Check if a set of supplements (a Stack) has internal compatibility status.
  Future<List<CompatibilityGuidance>> checkStackOptimization({
    required List<Supplement> supplements,
    required List<RoutineElement> userElements,
  });
}
