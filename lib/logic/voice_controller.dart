import 'package:flutter_tts/flutter_tts.dart';

class VoiceController {
  static final VoiceController _instance =
  VoiceController._internal();
  factory VoiceController() => _instance;
  VoiceController._internal();

  bool isEnabled = false;
  String activationMode = 'double'; // double / long

  final FlutterTts tts = FlutterTts();

  void setEnabled(bool value) {
    isEnabled = value;
  }

  void setActivationMode(String mode) {
    activationMode = mode;
  }

  Future<void> speak(String text) async {
    if (!isEnabled) return;
    await tts.stop();
    await tts.speak(text);
  }
}