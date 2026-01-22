import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/entities/supplement_stack.dart';

class FirebaseStackRepository implements StackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-memory cache: userId -> List<SupplementStack>
  final Map<String, List<SupplementStack>> _cache = {};

  @override
  Future<void> saveStack(String userId, SupplementStack stack) async {
    try {
      // Use the stack's ID as the document ID
      // NOTE: We remove .timeout() here to allow Firestore to queue writes locally
      // while offline. It will sync automatically when connection returns.
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('stacks')
          .doc(stack.id)
          .set(stack.toJson());

      // Update cache instantly
      final currentStacks = _cache[userId] ?? [];
      final index = currentStacks.indexWhere((s) => s.id == stack.id);
      if (index >= 0) {
        currentStacks[index] = stack;
      } else {
        currentStacks.add(stack);
      }
      _cache[userId] = currentStacks;
    } catch (e) {
      debugPrint('Error saving stack: $e');
      // Still throw if it's a permission or structural error,
      // but Firestore .set() rarely throws when offline.
      throw Exception('Failed to save stack: $e');
    }
  }

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async {
    try {
      // 1. Check in-memory cache first (Instant load)
      if (_cache.containsKey(userId) && _cache[userId]!.isNotEmpty) {
        debugPrint('Returning stacks from memory cache (0ms)');
        return _cache[userId]!;
      }

      // 2. Try to get from server with a short timeout
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
      debugPrint('Fetching stacks from cache (likely offline/slow): $e');
      // Fallback: Force read from local cache
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('stacks')
            .get(const GetOptions(source: Source.cache));
        return snapshot.docs
            .map((doc) => SupplementStack.fromJson(doc.data()))
            .toList();
      } catch (cacheError) {
        debugPrint('Cache read failed: $cacheError');
        return [];
      }
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
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 3));

      if (doc.exists && doc.data() != null) {
        return SupplementStack.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Fetching stack from cache: $e');
      try {
        final doc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('stacks')
            .doc('daily_stack')
            .get(const GetOptions(source: Source.cache));
        if (doc.exists && doc.data() != null) {
          return SupplementStack.fromJson(doc.data()!);
        }
        return null;
      } catch (cacheErr) {
        debugPrint('Stack cache failure: $cacheErr');
        return null;
      }
    }
  }
}
