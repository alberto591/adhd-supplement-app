import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/entities/supplement_stack.dart';

class FirebaseStackRepository implements StackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveStack(String userId, SupplementStack stack) async {
    try {
      // Saving to a subcollection 'stacks' for the user, or a specific document 'daily_stack'
      // Assuming a single daily stack for now
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .doc('daily_stack')
          .set(stack.toJson());
    } catch (e) {
      throw Exception('Failed to save stack: $e');
    }
  }

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .get();

      return snapshot.docs
          .map((doc) => SupplementStack.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load user stacks: $e');
    }
  }

  @override
  Future<SupplementStack?> getStack(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .doc('daily_stack')
          .get();

      if (doc.exists && doc.data() != null) {
        return SupplementStack.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load stack: $e');
    }
  }
}
