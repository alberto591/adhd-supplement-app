import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../utils/logger.dart';

class FirebaseSupplementRepository implements SupplementRepository {
  final FirebaseFirestore _firestore;

  // In-memory cache: "userId" (or "global") -> List<Supplement>
  final Map<String, List<Supplement>> _userCache = {};
  final _cacheController = StreamController<void>.broadcast();

  FirebaseSupplementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Supplement>> getAllSupplements({String? userId}) async {
    final cacheKey = userId ?? 'global';
    if (_userCache.containsKey(cacheKey)) return _userCache[cacheKey]!;

    try {
      AppLogger.d(
          'DEBUG: getAllSupplements called for userId: $userId, projectId: ${_firestore.app.options.projectId}');

      // 1. Fetch Global Supplements
      final globalSnapshot = await _firestore
          .collection('supplements')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 10));

      final globalSupps = globalSnapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      AppLogger.d('DEBUG: Global supplements found: ${globalSupps.length}');

      List<Supplement> results = globalSupps;

      // 2. Fetch Custom Supplements if userId provided
      if (userId != null && userId.isNotEmpty) {
        final customSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('custom_supplements')
            .get(const GetOptions(source: Source.serverAndCache));

        final customSupps = customSnapshot.docs
            .map((doc) => Supplement.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                  'userId': userId,
                  'isCustom': true,
                }))
            .toList();

        AppLogger.d(
            'DEBUG: Custom supplements found for user $userId: ${customSupps.length}');
        results = [...globalSupps, ...customSupps];
      }

      AppLogger.d('DEBUG: Total supplements combined: ${results.length}');
      _userCache[cacheKey] = results;
      return results;
    } catch (e) {
      AppLogger.e('DEBUG: Fetching supplements failed: $e');
      AppLogger.w('Fetching supplements failed, falling back to cache', e);
      try {
        final globalSnapshot = await _firestore
            .collection('supplements')
            .get(const GetOptions(source: Source.cache));
        final globalSupps = globalSnapshot.docs
            .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
            .toList();

        if (userId == null) return globalSupps;

        final customSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('custom_supplements')
            .get(const GetOptions(source: Source.cache));
        final customSupps = customSnapshot.docs
            .map((doc) => Supplement.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                  'userId': userId,
                  'isCustom': true,
                }))
            .toList();

        return [...globalSupps, ...customSupps];
      } catch (cacheErr) {
        AppLogger.e('Supplements cache failure', cacheErr);
        return _userCache[cacheKey] ?? [];
      }
    }
  }

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category,
      {String? userId}) async {
    try {
      final all = await getAllSupplements(userId: userId);
      return all.where((s) => s.category == category).toList();
    } catch (e) {
      throw Exception('Failed to fetch supplements by category: $e');
    }
  }

  @override
  Future<List<Supplement>> searchSupplements(String query,
      {String? userId}) async {
    try {
      final allSupplements = await getAllSupplements(userId: userId);

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
  Future<Supplement?> getSupplement(String id, {String? userId}) async {
    // Check all segments if userId provided, otherwise just global
    try {
      // 1. Try global first with server/cache
      final doc = await _firestore
          .collection('supplements')
          .doc(id)
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 5));

      if (doc.exists && doc.data() != null) {
        return Supplement.fromJson({...doc.data()!, 'id': doc.id});
      }

      // 2. If not global and userId provided, try custom
      if (userId != null) {
        final customDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('custom_supplements')
            .doc(id)
            .get();

        if (customDoc.exists && customDoc.data() != null) {
          return Supplement.fromJson({
            ...customDoc.data()!,
            'id': customDoc.id,
            'userId': userId,
            'isCustom': true,
          });
        }
      }

      AppLogger.w(
          'Supplement $id not found in global or user ($userId) collections');
      return null;
    } catch (e) {
      AppLogger.w(
          'Fetching supplement $id from server failed, trying cache', e);
      try {
        // Fallback: Force read from local cache
        final cachedDoc = await _firestore
            .collection('supplements')
            .doc(id)
            .get(const GetOptions(source: Source.cache));

        if (cachedDoc.exists && cachedDoc.data() != null) {
          return Supplement.fromJson(
              {...cachedDoc.data()!, 'id': cachedDoc.id});
        }

        if (userId != null) {
          final cachedCustomDoc = await _firestore
              .collection('users')
              .doc(userId)
              .collection('custom_supplements')
              .doc(id)
              .get(const GetOptions(source: Source.cache));

          if (cachedCustomDoc.exists && cachedCustomDoc.data() != null) {
            return Supplement.fromJson({
              ...cachedCustomDoc.data()!,
              'id': cachedCustomDoc.id,
              'userId': userId,
              'isCustom': true,
            });
          }
        }
        return null;
      } catch (cacheError) {
        AppLogger.e('Supplement cache lookup failed for $id', cacheError);
        return null;
      }
    }
  }

  @override
  Stream<List<Supplement>> watchSupplements({String? userId}) {
    // This is more complex because we need to combine two streams
    // For simplicity in Phase 1, we return the global stream
    // and let UI refresh after custom adds.
    return _firestore.collection('supplements').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  @override
  Future<void> saveCustomSupplement(Supplement supplement) async {
    if (supplement.userId == null) {
      throw Exception('UserId is required to save a custom supplement');
    }

    try {
      final data = supplement.toJson();
      if (supplement.id.isEmpty) {
        // Generate a fresh ID explicitly to ensure consistency between doc.id and data['id']
        final docRef = _firestore
            .collection('users')
            .doc(supplement.userId)
            .collection('custom_supplements')
            .doc();

        final dataWithId = {...data, 'id': docRef.id};
        await docRef.set(dataWithId);
        AppLogger.i('Created new custom supplement with ID: ${docRef.id}');
      } else {
        await _firestore
            .collection('users')
            .doc(supplement.userId)
            .collection('custom_supplements')
            .doc(supplement.id)
            .set(data);
        AppLogger.i('Updated custom supplement: ${supplement.id}');
      }

      // Invalidate cache
      _userCache.clear(); // Clear all to ensure next fetch is fresh
    } catch (e) {
      AppLogger.e('Error saving custom supplement', e);
      throw Exception('Failed to save custom supplement: $e');
    }
  }

  @override
  Future<void> deleteCustomSupplement(String id, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('custom_supplements')
          .doc(id)
          .delete();

      // Invalidate cache
      _userCache.remove(userId);
    } catch (e) {
      AppLogger.e('Error deleting custom supplement', e);
      throw Exception('Failed to delete custom supplement: $e');
    }
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

  @override
  Future<void> downloadLibrary() async {
    try {
      AppLogger.i('Forcing library download for offline use...');
      // Fetch all global supplements from server to ensure they are in the local cache
      final snapshot = await _firestore
          .collection('supplements')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 20));

      final supplements = snapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Update in-memory global cache as well
      _userCache['global'] = supplements;
      _cacheController.add(null);

      AppLogger.i('Library download complete: ${supplements.length} items.');
    } catch (e) {
      AppLogger.e('Failed to download library for offline use', e);
      rethrow;
    }
  }

  @override
  Stream<void> get onCacheInvalidated => _cacheController.stream;
}
