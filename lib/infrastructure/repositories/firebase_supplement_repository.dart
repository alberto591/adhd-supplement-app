import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../utils/logger.dart';

class FirebaseSupplementRepository implements SupplementRepository {
  final FirebaseFirestore _firestore;

  // In-memory cache
  List<Supplement>? _cache;

  FirebaseSupplementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Supplement>> getAllSupplements() async {
    if (_cache != null) return _cache!;

    try {
      final snapshot = await _firestore
          .collection('supplements')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 10));
      _cache = snapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return _cache!;
    } catch (e) {
      AppLogger.w('Fetching supplements from cache', e);
      try {
        final snapshot = await _firestore
            .collection('supplements')
            .get(const GetOptions(source: Source.cache));
        _cache = snapshot.docs
            .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
        return _cache!;
      } catch (cacheErr) {
        AppLogger.e('Supplements cache failure', cacheErr);
        return _cache ?? [];
      }
    }
  }

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category) async {
    try {
      final all = await getAllSupplements();
      return all.where((s) => s.category == category).toList();
    } catch (e) {
      throw Exception('Failed to fetch supplements by category: $e');
    }
  }

  @override
  Future<List<Supplement>> searchSupplements(String query) async {
    try {
      final allSupplements = await getAllSupplements();

      // Simple client-side filtering
      // For production, consider using Algolia or similar search service
      final lowerQuery = query.toLowerCase();
      return allSupplements.where((supplement) {
        return supplement.name.toLowerCase().contains(lowerQuery) ||
            supplement.category.toLowerCase().contains(lowerQuery) ||
            supplement.benefits
                .any((b) => b.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      throw Exception('Failed to search supplements: $e');
    }
  }

  @override
  Future<Supplement?> getSupplement(String id) async {
    try {
      final doc = await _firestore
          .collection('supplements')
          .doc(id)
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 10));
      if (!doc.exists) return null;
      return Supplement.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      AppLogger.w('Fetching supplement $id from cache', e);
      try {
        final doc = await _firestore
            .collection('supplements')
            .doc(id)
            .get(const GetOptions(source: Source.cache));
        if (!doc.exists) return null;
        return Supplement.fromJson({...doc.data()!, 'id': doc.id});
      } catch (cacheErr) {
        AppLogger.e('Supplement $id cache failure', cacheErr);
        return null;
      }
    }
  }

  @override
  Stream<List<Supplement>> watchSupplements() {
    return _firestore.collection('supplements').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  @override
  Future<void> trackReferralClick(String supplementId) async {
    try {
      await _firestore.collection('referral_clicks').add({
        'supplementId': supplementId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.e('Error tracking referral click', e);
    }
  }
}
