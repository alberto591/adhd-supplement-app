import 'package:flutter/material.dart';
import '../../domain/entities/supplement_compatibility.dart';
import '../../domain/entities/routine_override.dart';
import '../../domain/repositories/routine_safety_repository.dart';
import 'package:uuid/uuid.dart';

class RoutineSafetyViewModel extends ChangeNotifier {
  final RoutineSafetyRepository _repository;
  final String userId;

  RoutineSafetyViewModel({
    required RoutineSafetyRepository repository,
    required this.userId,
  }) : _repository = repository;

  List<SupplementCompatibility> _currentCompatibilitys = [];
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  List<SupplementCompatibility> get currentCompatibilitys => _currentCompatibilitys;
  List<SupplementCompatibility> get activeRisks => _currentCompatibilitys;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Check for compatibilitys between a list of supplements
  Future<void> checkCompatibilitys(List<String> supplementIds) async {
    if (supplementIds.length < 2) {
      _currentCompatibilitys = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentCompatibilitys =
          await _repository.getCompatibilitysForSupplements(supplementIds);
    } catch (e) {
      _error = 'Failed to check compatibilitys: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Log a safety override
  Future<void> overrideCompatibility(String compatibilityId, String? reason) async {
    final override = RoutineOverride(
      id: const Uuid().v4(),
      userId: userId,
      compatibilityId: compatibilityId,
      timestamp: DateTime.now(),
      userReason: reason,
      isAcknowledged: true,
    );

    try {
      await _repository.logRoutineOverride(override);
    } catch (e) {
      _error = 'Failed to log override: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Check if there are any critical compatibilitys
  bool get hasCriticalCompatibilitys => _currentCompatibilitys
      .any((i) => i.severity == CompatibilityLevel.critical);

  /// Get recommendations for current compatibilitys
  List<String> get recommendations =>
      _currentCompatibilitys.map((i) => i.recommendation).toList();
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
