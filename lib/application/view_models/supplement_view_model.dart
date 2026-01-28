import 'package:flutter/material.dart';

import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/domain/repositories/supplement_repository.dart';
import 'package:neurostack_app/domain/services/analytics_service.dart';
import 'package:neurostack_app/infrastructure/services/url_service.dart';
import 'package:neurostack_app/utils/logger.dart';
import 'package:neurostack_app/domain/repositories/settings_repository.dart';

class SupplementViewModel extends ChangeNotifier {
  final SupplementRepository _repository;
  final UrlService _urlService;
  final AnalyticsService _analyticsService;

  final SettingsRepository _settingsRepository;

  SupplementViewModel(this._repository, this._urlService,
      this._analyticsService, this._settingsRepository) {
    _fetchSupplements();
  }

  bool _isLoading = false;
  bool _isDownloadingLibrary = false;
  List<Supplement> _supplements = [];
  String? _error;

  bool get isLoading => _isLoading;
  bool get isDownloadingLibrary => _isDownloadingLibrary;
  List<Supplement> get supplements => _supplements;
  String? get error => _error;

  bool get isLibraryDownloaded =>
      _settingsRepository.getLastLibraryDownloadTime() != null;
  DateTime? get lastDownloadTime =>
      _settingsRepository.getLastLibraryDownloadTime();

  Future<void> _fetchSupplements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _supplements = await _repository.getAllSupplements();
    } catch (e) {
      _error = 'Failed to load supplements';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadLibraryForOffline() async {
    if (_isDownloadingLibrary) return;

    _isDownloadingLibrary = true;
    notifyListeners();

    try {
      await _repository.downloadLibrary();
      // After downloading, refresh the local list to ensure even the in-memory cache is hot
      _supplements = await _repository.getAllSupplements();
      await _settingsRepository.setLastLibraryDownloadTime(DateTime.now());
    } catch (e) {
      AppLogger.e('Error during manual library download', e);
      rethrow;
    } finally {
      _isDownloadingLibrary = false;
      notifyListeners();
    }
  }

  Future<void> onReferralClicked(Supplement supplement) async {
    await _repository.trackReferralClick(supplement.id);
    await _analyticsService.logEvent('referral_clicked', parameters: {
      'supplement_id': supplement.id,
      'supplement_name': supplement.name,
      'category': supplement.category,
    });
    await _urlService.launchReferral(supplement.referralUrl);
  }
}
