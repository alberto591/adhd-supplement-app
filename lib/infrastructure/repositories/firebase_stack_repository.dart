import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/repositories/stack_repository.dart';

class FirebaseStackRepository implements StackRepository {
  final FirebaseFirestore _firestore;

  FirebaseStackRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('stacks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => SupplementStack.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user stacks: $e');
    }
  }

  @override
  Future<SupplementStack?> getStack(String stackId) async {
    try {
      final doc = await _firestore.collection('stacks').doc(stackId).get();
      if (!doc.exists) return null;
      return SupplementStack.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to fetch stack: $e');
    }
  }

  @override
  Future<SupplementStack> createStack(SupplementStack stack) async {
    try {
      final docRef = await _firestore.collection('stacks').add(stack.toJson());
      final doc = await docRef.get();
      return SupplementStack.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to create stack: $e');
    }
  }

  @override
  Future<void> updateStack(SupplementStack stack) async {
    try {
      await _firestore.collection('stacks').doc(stack.id).update(stack.toJson());
    } catch (e) {
      throw Exception('Failed to update stack: $e');
    }
  }

  @override
  Future<void> deleteStack(String stackId) async {
    try {
      await _firestore.collection('stacks').doc(stackId).delete();
    } catch (e) {
      throw Exception('Failed to delete stack: $e');
    }
  }

  @override
  Stream<List<SupplementStack>> watchUserStacks(String userId) {
    return _firestore
        .collection('stacks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SupplementStack.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
}
