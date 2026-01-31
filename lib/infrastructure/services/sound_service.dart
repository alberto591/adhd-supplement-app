import 'package:audioplayers/audioplayers.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../utils/logger.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  final SettingsRepository _settingsRepository;

  SoundService(this._settingsRepository) {
    _configureAudio();
  }

  void _configureAudio() {
    AudioPlayer.global.setAudioContext(AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
        options: const {
          AVAudioSessionOptions.mixWithOthers,
          AVAudioSessionOptions.duckOthers,
        },
      ),
      android: const AudioContextAndroid(
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.none,
      ),
    ));
  }

  Future<void> playSuccess() async {
    if (!_settingsRepository.getSoundsEnabled()) return;
    try {
      await _player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      AppLogger.e('Failed to play success sound', e);
    }
  }

  Future<void> playTriumphant() async {
    if (!_settingsRepository.getSoundsEnabled()) return;
    try {
      // Play a rhythmic sequence for a more "celebratory" feel
      await _player.play(AssetSource('sounds/success.mp3'), volume: 1.0);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await _player.play(AssetSource('sounds/success.mp3'), volume: 0.8);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _player.play(AssetSource('sounds/success.mp3'), volume: 1.0);
    } catch (e) {
      AppLogger.e('Failed to play triumphant sound', e);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
