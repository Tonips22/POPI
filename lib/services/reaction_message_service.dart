import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';

import 'app_service.dart';

/// Servicio que reproduce mensajes motivacionales usando TTS.
class ReactionMessageService {
  ReactionMessageService._internal() {
    _tts.setLanguage('es-ES');
    _tts.setPitch(1.0);
    _tts.awaitSpeakCompletion(true);
  }

  static final ReactionMessageService _instance =
      ReactionMessageService._internal();
  factory ReactionMessageService() => _instance;

  final FlutterTts _tts = FlutterTts();
  final Random _random = Random();

  final List<String> _successMessages = const [
    '¡Bien hecho!',
    '¡Excelente trabajo!',
    '¡Lo lograste!',
    '¡Así se hace!',
    '¡Sigue así!',
  ];

  final List<String> _failMessages = const [
    '¡Tú puedes!',
    'Inténtalo de nuevo.',
    'No pasa nada, sigue probando.',
    '¡Ánimo, lo conseguirás!',
    'Cada intento cuenta.',
  ];

  final List<String> _finalHighScore = const [
    '¡Impresionante, superaste todos los retos!',
    '¡Gran resultado, eres una estrella!',
    '¡Excelente sesión, lo hiciste genial!',
  ];

  final List<String> _finalPerfect = const [
    '¡Increíble, no cometiste ningún fallo!',
    '¡Lograste todas las rondas sin errores, bravo!',
    '¡Perfecto, acertaste absolutamente todo!',
  ];

  final List<String> _finalBalanced = const [
    '¡Buen trabajo, seguiste adelante hasta el final!',
    '¡Muy bien, cada ronda te hizo más fuerte!',
    '¡Lo lograste, gracias a tu esfuerzo constante!',
  ];

  final List<String> _finalEncouragement = const [
    '¡Lo importante es que seguiste intentándolo!',
    'Gran esfuerzo, mañana será aún mejor.',
    'Cada intento suma, ¡no te rindas!',
  ];

  Future<void> speakSuccess() async {
    final prefs = AppService().currentUser?.preferences;
    if (prefs == null || !prefs.reactionMessageSuccess) return;
    await _speakRandom(_successMessages);
  }

  Future<void> speakFail() async {
    final prefs = AppService().currentUser?.preferences;
    if (prefs == null || !prefs.reactionMessageFail) return;
    await _speakRandom(_failMessages);
  }

  Future<void> speakFinal(int hits, int fails) async {
    final prefs = AppService().currentUser?.preferences;
    if (prefs == null || !prefs.reactionMessageFinal) return;
    final message = _pickFinalMessage(hits, fails);
    if (message == null) return;
    await _speak(message);
  }

  String? _pickFinalMessage(int hits, int fails) {
    final int total = (hits + fails).clamp(1, 9999);
    final double accuracy = hits / total;
    if (fails == 0 && hits > 0) {
      return _finalPerfect[_random.nextInt(_finalPerfect.length)];
    }
    if (accuracy >= 0.8) {
      return _finalHighScore[_random.nextInt(_finalHighScore.length)];
    }
    if (accuracy >= 0.5) {
      return _finalBalanced[_random.nextInt(_finalBalanced.length)];
    }
    return _finalEncouragement[_random.nextInt(_finalEncouragement.length)];
  }

  Future<void> _speakRandom(List<String> options) async {
    if (options.isEmpty) return;
    final text = options[_random.nextInt(options.length)];
    await _speak(text);
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }
}
