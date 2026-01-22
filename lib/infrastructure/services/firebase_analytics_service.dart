import 'package:adhd_supplement_app/domain/services/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    debugPrint('Analytics: Log Event -> $name, Params: $parameters');
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> logScreenView(String screenName) async {
    debugPrint('Analytics: Screen View -> $screenName');
    await _analytics.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
  }

  @override
  Future<void> setUserId(String userId) async {
    debugPrint('Analytics: Set User ID -> $userId');
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    debugPrint('Analytics: Set User Property -> $name : $value');
    await _analytics.setUserProperty(name: name, value: value);
  }
}
