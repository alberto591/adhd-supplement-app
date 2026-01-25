import 'package:audioplayers/audioplayers.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../utils/logger.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  final SettingsRepository _settingsRepository;

  SoundService(this._settingsRepository) {
    // Pre-load or configure if needed
  }

  Future<void> playSuccess() async {
    if (!_settingsRepository.getSoundsEnabled()) return;
    try {
      // Using Source from assets directory
      await _player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      AppLogger.e('Failed to play success sound', e);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
