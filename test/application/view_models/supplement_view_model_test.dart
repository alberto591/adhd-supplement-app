import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/application/view_models/supplement_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:flutter/material.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/url_service.dart';
import 'package:adhd_supplement_app/domain/services/analytics_service.dart';

class MockSupplementRepository implements SupplementRepository {
  bool _shouldThrow = false;
  List<Supplement> _supplements = [];

  void setShouldThrow(bool value) => _shouldThrow = value;
  void setSupplements(List<Supplement> supplements) =>
      _supplements = supplements;

  @override
  Future<List<Supplement>> getAllSupplements({String? userId}) async {
    if (_shouldThrow) {
      throw Exception('Repository error');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _supplements;
  }

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category,
      {String? userId}) async {
    return _supplements.where((s) => s.category == category).toList();
  }

  @override
  Future<List<Supplement>> searchSupplements(String query,
      {String? userId}) async {
    return _supplements
        .where((s) =>
            s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.benefits
                .any((b) => b.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  @override
  Future<Supplement?> getSupplement(String id, {String? userId}) async {
    try {
      return _supplements.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<Supplement>> watchSupplements({String? userId}) {
    return Stream.value(_supplements);
  }

  @override
  Future<void> saveCustomSupplement(Supplement supplement) async {}

  @override
  Future<void> deleteCustomSupplement(String id, String userId) async {}

  @override
  Future<void> trackReferralClick(String supplementId) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> downloadLibrary() async {}
}

class MockSettingsRepository implements SettingsRepository {
  DateTime? lastDownloadTime;

  @override
  Future<void> init() async {}

  @override
  DateTime? getLastLibraryDownloadTime() => lastDownloadTime;

  @override
  Future<void> setLastLibraryDownloadTime(DateTime time) async {
    lastDownloadTime = time;
  }

  @override
  bool getNudgeModeEnabled() => true;
  @override
  Future<void> setNudgeModeEnabled(bool enabled) async {}
  @override
  NotificationMode getNotificationMode() => NotificationMode.gentle;
  @override
  Future<void> setNotificationMode(NotificationMode mode) async {}
  @override
  TimeOfDay getNudgeTime() => const TimeOfDay(hour: 8, minute: 0);
  @override
  Future<void> setNudgeTime(TimeOfDay time) async {}
  @override
  TimeOfDay getSlotTime(String slot) => const TimeOfDay(hour: 8, minute: 0);
  @override
  Future<void> setSlotTime(String slot, TimeOfDay time) async {}
  @override
  String getWarningNudgeOption() => '15m';
  @override
  Future<void> setWarningNudgeOption(String option) async {}
  @override
  bool getExtendedRemindersEnabled() => false;
  @override
  Future<void> setExtendedRemindersEnabled(bool enabled) async {}
  @override
  bool getBiometricLockEnabled() => false;
  @override
  Future<void> setBiometricLockEnabled(bool enabled) async {}
  @override
  bool getLocalStorageOnly() => false;
  @override
  Future<void> setLocalStorageOnly(bool enabled) async {}
  @override
  bool getAnalyticsEnabled() => true;
  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {}
  @override
  bool getCrashReportingEnabled() => true;
  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {}
  @override
  ThemeMode getThemeMode() => ThemeMode.system;
  @override
  Future<void> setThemeMode(ThemeMode mode) async {}
  @override
  bool getSoundsEnabled() => true;
  @override
  Future<void> setSoundsEnabled(bool enabled) async {}
  @override
  bool getReducedMotionEnabled() => false;
  @override
  Future<void> setReducedMotionEnabled(bool enabled) async {}
  @override
  bool getHapticFeedbackEnabled() => true;
  @override
  Future<void> setHapticFeedbackEnabled(bool enabled) async {}
  @override
  double getFontSizeScale() => 1.0;
  @override
  Future<void> setFontSizeScale(double scale) async {}
  @override
  bool hasAcceptedDisclaimer() => true;
  @override
  Future<void> setAcceptedDisclaimer(bool accepted) async {}
}

class MockUrlService extends UrlService {
  String? lastLaunchedUrl;
  bool _shouldThrow = false;

  void setShouldThrow(bool value) => _shouldThrow = value;

  @override
  Future<void> launchReferral(String url) async {
    if (_shouldThrow) {
      throw Exception('Could not launch $url');
    }
    lastLaunchedUrl = url;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

class MockAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name,
      {Map<String, dynamic>? parameters}) async {}
  @override
  Future<void> logScreenView(String screenName) async {}
  @override
  Future<void> setUserId(String userId) async {}
  @override
  Future<void> setUserProperty(String name, String value) async {}
}

void main() {
  late MockSupplementRepository mockRepository;
  late MockUrlService mockUrlService;
  late MockAnalyticsService mockAnalyticsService;
  late MockSettingsRepository mockSettingsRepository;
  late SupplementViewModel viewModel;

  setUp(() {
    mockRepository = MockSupplementRepository();
    mockUrlService = MockUrlService();
    mockAnalyticsService = MockAnalyticsService();
    mockSettingsRepository = MockSettingsRepository();
    viewModel = SupplementViewModel(mockRepository, mockUrlService,
        mockAnalyticsService, mockSettingsRepository);
  });

  group('SupplementViewModel', () {
    test('should initialize with correct initial state', () {
      // Constructor triggers an immediate fetch.
      expect(viewModel.isLoading, true);
      expect(viewModel.supplements, isEmpty);
      expect(viewModel.error, null);
    });

    test('should load supplements on initialization', () async {
      final supplements = [
        const Supplement(
          id: 'sup1',
          name: 'Magnesium',
          category: 'Minerals',
          benefits: ['Sleep', 'Focus'],
        ),
        const Supplement(
          id: 'sup2',
          name: 'Omega-3',
          category: 'Fats',
          benefits: ['Brain health'],
        ),
      ];
      mockRepository.setSupplements(supplements);

      // Wait for async initialization
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(viewModel.supplements.length, 2);
      expect(viewModel.supplements.first.id, 'sup1');
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
    });

    test('should set loading state during fetch', () async {
      mockRepository.setSupplements([]);

      // Create new view model to trigger fetch
      final newViewModel = SupplementViewModel(mockRepository, mockUrlService,
          mockAnalyticsService, mockSettingsRepository);

      // Immediately check loading state (before async completes)
      expect(newViewModel.isLoading, true);

      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(newViewModel.isLoading, false);
    });

    test('should handle repository errors', () async {
      mockRepository.setShouldThrow(true);

      final newViewModel = SupplementViewModel(mockRepository, mockUrlService,
          mockAnalyticsService, mockSettingsRepository);

      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(newViewModel.error, 'Failed to load supplements');
      expect(newViewModel.supplements, isEmpty);
      expect(newViewModel.isLoading, false);
    });

    test('onReferralClicked should track click and launch URL', () async {
      const supplement = Supplement(
        id: 'sup1',
        name: 'Magnesium',
        category: 'Minerals',
        referralUrl: 'https://example.com/magnesium',
      );
      mockRepository.setSupplements([supplement]);

      await Future<void>.delayed(const Duration(milliseconds: 200));

      await viewModel.onReferralClicked(supplement);

      expect(mockUrlService.lastLaunchedUrl, 'https://example.com/magnesium');
    });

    test('onReferralClicked should handle URL launch errors', () async {
      mockUrlService.setShouldThrow(true);
      const supplement = Supplement(
        id: 'sup1',
        name: 'Magnesium',
        category: 'Minerals',
        referralUrl: 'https://example.com/magnesium',
      );
      mockRepository.setSupplements([supplement]);

      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Should not throw, but error handling depends on implementation
      expect(() => viewModel.onReferralClicked(supplement), returnsNormally);
    });
  });
}
