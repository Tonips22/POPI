import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Servicio ligero para reproducir los sonidos de refuerzo positivos.
class ReactionSoundPlayer {
  ReactionSoundPlayer._internal() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  static final ReactionSoundPlayer _instance =
      ReactionSoundPlayer._internal();

  factory ReactionSoundPlayer() => _instance;

  final AudioPlayer _player = AudioPlayer();

  static const Map<String, String> _soundAssetMap = {
    'sound_bells': 'sounds/reward_bells.wav',
    'sound_marimba': 'sounds/reward_marimba.wav',
    'sound_whistle': 'sounds/reward_whistle.wav',
  };

  Future<void> play(String? soundId) async {
    if (soundId == null || soundId.isEmpty || soundId == 'none') return;
    final assetPath = _soundAssetMap[soundId];
    if (assetPath == null) return;

    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e, stackTrace) {
      debugPrint('❌ Error al reproducir sonido $soundId: $e');
      debugPrint('$stackTrace');
    }
  }
}
