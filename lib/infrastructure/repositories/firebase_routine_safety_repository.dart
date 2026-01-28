import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplement_compatibility.dart';
import '../../domain/entities/routine_override.dart';
import '../../domain/repositories/routine_safety_repository.dart';

class FirebaseRoutineSafetyRepository implements RoutineSafetyRepository {
  final FirebaseFirestore _firestore;

  FirebaseRoutineSafetyRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<SupplementCompatibility>> getCompatibilitysForSupplements(
      List<String> supplementIds) async {
    if (supplementIds.length < 2) return [];

    try {
      // For simplicity, we fetch all compatibilitys and filter locally
      // In a large database, we would use a more optimized query
      final snapshot = await _firestore.collection('compatibilitys').get();

      final allCompatibilitys = snapshot.docs
          .map((doc) =>
              SupplementCompatibility.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return allCompatibilitys.where((compatibility) {
        return supplementIds.contains(compatibility.supplementAId) &&
            supplementIds.contains(compatibility.supplementBId);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch compatibilitys: $e');
    }
  }

  @override
  Future<void> logRoutineOverride(RoutineOverride override) async {
    try {
      await _firestore
          .collection('safety_overrides')
          .doc(override.id)
          .set(override.toJson());
    } catch (e) {
      throw Exception('Failed to log safety override: $e');
    }
  }

  @override
  Future<List<RoutineOverride>> getRoutineOverrides(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('safety_overrides')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => RoutineOverride.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch safety overrides: $e');
    }
  }

  @override
  Future<SupplementCompatibility?> getCompatibilityById(String id) async {
    try {
      final doc = await _firestore.collection('compatibilitys').doc(id).get();
      if (!doc.exists) return null;
      return SupplementCompatibility.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to fetch compatibility: $e');
    }
  }
}
