import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplement_repository.dart';

class FirebaseSupplementRepository implements SupplementRepository {
  final FirebaseFirestore _firestore;

  FirebaseSupplementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Supplement>> getAllSupplements() async {
    try {
      final snapshot = await _firestore.collection('supplements').get();
      return snapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch supplements: $e');
    }
  }

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('supplements')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch supplements by category: $e');
    }
  }

  @override
  Future<List<Supplement>> searchSupplements(String query) async {
    try {
      final snapshot = await _firestore.collection('supplements').get();
      final allSupplements = snapshot.docs
          .map((doc) => Supplement.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

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
      final doc = await _firestore.collection('supplements').doc(id).get();
      if (!doc.exists) return null;
      return Supplement.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to fetch supplement: $e');
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
      // Log error but don't block user
      print('Error tracking referral click: $e');
    }
  }
}
