import 'package:neurostack_app/domain/services/billing_service.dart';

/// A no-op implementation of [BillingService] that always returns false/empty.
/// Used to disable monetization features without removing code architecture.
class NoOpBillingService implements BillingService {
  @override
  Future<bool> initialize() async => true;

  @override
  Future<bool> get isSubscribed async => false;

  @override
  Future<bool> hasEntitlement(String entitlementId) async => false;

  @override
  Future<List<String>> getEntitlements() async => [];

  @override
  Future<void> presentCustomerCenter() async {}

  @override
  Future<bool> purchaseSubscription({required String planId}) async => false;

  @override
  Future<bool> restorePurchases() async => false;
}
