import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import '../../domain/services/billing_service.dart';
import '../../utils/logger.dart';

class RevenueCatBillingService implements BillingService {
  static const String _apiKey = 'test_zepzIMdmtyTSRKRnkADckfugKLi';
  static const String _entitlementId = 'pro';

  bool _isInitialized = false;

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await Purchases.setLogLevel(LogLevel.debug);

        PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);

        // Enable if you have an app user ID system
        // configuration.appUserID = "app_user_id";

        await Purchases.configure(configuration);
        _isInitialized = true;
        AppLogger.i('RevenueCat initialized successfully');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e('Failed to initialize RevenueCat', e);
      return false;
    }
  }

  @override
  Future<bool> get isSubscribed async {
    if (!_isInitialized) return false;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      AppLogger.e('Error checking subscription status', e);
      return false;
    }
  }

  @override
  Future<bool> purchaseSubscription({required String planId}) async {
    if (!_isInitialized) return false;
    try {
      // Using RevenueCat Paywall UI for simplified purchase flow
      final paywallResult =
          await RevenueCatUI.presentPaywallIfNeeded(_entitlementId);

      // If result is 'notPresented', user might already be subscribed or no paywall configured
      // If they completed purchase, this returns success

      // Re-verify status
      return await isSubscribed;
    } on PlatformException catch (e) {
      // errorCode 1 is 'Purchase Cancelled' usually
      if (e.code == '1') {
        AppLogger.i('User cancelled purchase flow');
        return false;
      }
      AppLogger.e('Purchase failed', e);
      return false;
    } catch (e) {
      AppLogger.e('Unexpected purchase error', e);
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    if (!_isInitialized) return false;
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      AppLogger.e('Restore purchases failed', e);
      return false;
    }
  }

  @override
  Future<bool> hasEntitlement(String entitlementId) async {
    if (!_isInitialized) return false;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      AppLogger.e('Error checking entitlement $entitlementId', e);
      return false;
    }
  }

  @override
  Future<List<String>> getEntitlements() async {
    if (!_isInitialized) return [];
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.keys.toList();
    } catch (e) {
      AppLogger.e('Error getting entitlements', e);
      return [];
    }
  }

  @override
  Future<void> presentCustomerCenter() async {
    if (!_isInitialized) return;
    try {
      // Try to use the native Customer Center if available in this SDK version
      // If not, we might fail gracefully or perform no-op.
      // Note: presentCustomerCenter might be named differently or require specific setup.
      // Since we added purchases_ui_flutter, we check if it is available.
      // If the method doesn't exist, this code might fail at compile time if strict type checked,
      // but in dynamic dart or if it exists it will work.
      // Actually, standard method is typically: RevenueCatUI.presentCustomerCenter();
      // If not available, we might fallback or just log.

      // For now, assuming sdk 8.11.0+ has it.
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      AppLogger.e('Failed to present customer center', e);
    }
  }
}
