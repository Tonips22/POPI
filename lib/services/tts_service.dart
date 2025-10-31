import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal() {
    _initTts();
  }

  final FlutterTts _flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  void _initTts() {
    _flutterTts.setStartHandler(() {
      print("TTS start");
      ttsState = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      print("TTS completed");
      ttsState = TtsState.stopped;
    });

    _flutterTts.setCancelHandler(() {
      print("TTS cancelled");
      ttsState = TtsState.stopped;
    });

    _flutterTts.setPauseHandler(() {
      print("TTS paused");
      ttsState = TtsState.paused;
    });

    _flutterTts.setContinueHandler(() {
      print("TTS continued");
      ttsState = TtsState.continued;
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS ERROR: $msg");
      ttsState = TtsState.stopped;
    });

    _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop();
      if (isAndroid) await _flutterTts.setLanguage("es-ES");
      if (isIOS) await _flutterTts.setLanguage("es-ES");

      await _flutterTts.setVolume(volume);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.setSpeechRate(rate);

      await _flutterTts.speak(text);
    } catch (e) {
      print("TTS exception: $e");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    ttsState = TtsState.stopped;
  }

  void dispose() {
    _flutterTts.stop();
  }
}
