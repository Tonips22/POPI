// lib/logic/voice_controller.dart
import 'package:flutter_tts/flutter_tts.dart';

class VoiceController {
  // --------- SINGLETON ---------
  static final VoiceController _instance = VoiceController._internal();
  factory VoiceController() => _instance;

  VoiceController._internal() {
    _tts = FlutterTts();
    // Configuración básica (se puede repetir sin problema)
    _tts.setLanguage('es-ES');
    _tts.setPitch(1.0);
  }

  // --------- ESTADO GLOBAL ---------
  late final FlutterTts _tts;

  /// ¿Está activada la lectura por voz en general?
  bool isEnabled = false;

  /// Modo de activación para VoiceText: 'none', 'double', 'long'
  String activationMode = 'none';

  // --------- MÉTODOS PÚBLICOS ---------

  void setEnabled(bool enabled) {
    isEnabled = enabled;
  }

  void setActivationMode(String mode) {
    activationMode = mode;
  }

  /// Habla el texto indicado.
  /// NO miramos isEnabled aquí: VoiceText decide cuándo llamar a speak().
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }
}