import '../../domain/services/billing_service.dart';

class MockBillingService implements BillingService {
  bool _isSubscribed = false;

  @override
  Future<bool> initialize() async {
    await Future.delayed<void>(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> get isSubscribed async {
    return _isSubscribed;
  }

  @override
  Future<bool> purchaseSubscription({required String planId}) async {
    await Future.delayed<void>(const Duration(seconds: 2));
    _isSubscribed = true;
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    await Future.delayed<void>(const Duration(seconds: 2));
    _isSubscribed = true;
    return true;
  }
}
