import '../entities/supplement.dart';

abstract class SupplementRepository {
  /// Get all available supplements
  Future<List<Supplement>> getAllSupplements();

  /// Get supplements by category
  Future<List<Supplement>> getSupplementsByCategory(String category);

  /// Search supplements by name or benefits
  Future<List<Supplement>> searchSupplements(String query);

  /// Get a specific supplement by ID
  Future<Supplement?> getSupplement(String id);

  /// Stream of all supplements (real-time updates)
  Stream<List<Supplement>> watchSupplements();

  /// Track a referral click
  Future<void> trackReferralClick(String supplementId);
}
