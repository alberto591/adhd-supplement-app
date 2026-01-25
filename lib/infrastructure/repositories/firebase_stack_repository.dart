import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../utils/logger.dart';

import 'dart:async';

class FirebaseStackRepository implements StackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-memory cache: userId -> List<SupplementStack>
  final Map<String, List<SupplementStack>> _cache = {};

  // Stream controller for broadcasting updates (userId -> stacks)
  final StreamController<Map<String, List<SupplementStack>>>
      _stackUpdateController =
      StreamController<Map<String, List<SupplementStack>>>.broadcast();

  @override
  Future<void> saveStack(String userId, SupplementStack stack) async {
    try {
      // Update cache instantly (Optimistic Update)
      final currentStacks = List<SupplementStack>.from(_cache[userId] ?? []);
      final index = currentStacks.indexWhere((s) => s.id == stack.id);
      if (index >= 0) {
        currentStacks[index] = stack;
      } else {
        currentStacks.add(stack);
      }
      _cache[userId] = currentStacks;

      // Broadcast update to stream immediately
      AppLogger.d(
          'Optimistic Broadcast: UPDATED stacks for $userId: ${currentStacks.length} stacks');
      _stackUpdateController.add({userId: currentStacks});

      // Persist to Firestore in background
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .doc(stack.id)
          .set(stack.toJson());
    } catch (e) {
      AppLogger.e('Error saving stack', e);
      throw Exception('Failed to save stack: $e');
    }
  }

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async {
    try {
      // 1. Check in-memory cache first
      if (_cache.containsKey(userId) && _cache[userId]!.isNotEmpty) {
        return List.from(_cache[userId]!);
      }

      // 2. Fetch from Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 3));

      final stacks = snapshot.docs
          .map((doc) => SupplementStack.fromJson(doc.data()))
          .toList();

      // 3. Update cache
      _cache[userId] = stacks;
      return stacks;
    } catch (e) {
      AppLogger.w('Fetching stacks fallback to cache', e);
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .get(const GetOptions(source: Source.cache));
      final stacks = snapshot.docs
          .map((doc) => SupplementStack.fromJson(doc.data()))
          .toList();
      _cache[userId] = stacks;
      return stacks;
    }
  }

  @override
  Future<SupplementStack?> getStack(String userId) async {
    // This method seems specialized or legacy, usually we use getUserStacks
    return null;
  }

  @override
  Stream<List<SupplementStack>> watchUserStacks(String userId) {
    // Use Firestore snapshots for real-time cross-device sync
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('stacks')
        .snapshots()
        .map((snapshot) {
      final stacks = snapshot.docs
          .map((doc) => SupplementStack.fromJson(doc.data()))
          .toList();

      // Update local cache
      _cache[userId] = stacks;
      return stacks;
    });
  }
}
