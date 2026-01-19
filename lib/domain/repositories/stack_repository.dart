import '../entities/supplement_stack.dart';

abstract class StackRepository {
  /// Get all stacks for a user
  Future<List<SupplementStack>> getUserStacks(String userId);

  /// Get a specific stack by ID
  Future<SupplementStack?> getStack(String stackId);

  /// Create a new stack
  Future<SupplementStack> createStack(SupplementStack stack);

  /// Update an existing stack
  Future<void> updateStack(SupplementStack stack);

  /// Delete a stack
  Future<void> deleteStack(String stackId);

  /// Stream of user's stacks (real-time updates)
  Stream<List<SupplementStack>> watchUserStacks(String userId);
}
