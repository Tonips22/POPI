import 'package:flutter/foundation.dart';

import 'sesion_juego_service.dart';

/// Controla la sesión activa de un juego para registrar estadísticas
class GameSessionTracker {
  GameSessionTracker({
    required this.gameType,
    required this.userNumericId,
  });

  final int gameType;
  final int userNumericId;
  final SesionJuegoService _service = SesionJuegoService();

  String? _docId;
  bool _hasStarted = false;
  bool _isFinishing = false;
  Future<void>? _startFuture;
  int _hits = 0;
  int _fails = 0;

  /// Inicia la sesión en Firestore si aún no existe
  void start() {
    _startFuture ??= _createSession();
  }

  Future<void> _createSession() async {
    try {
      final nextId = await _service.getNextSessionId();
      final nextCounter =
          await _service.getNextSessionCounter(userNumericId);
      _docId = await _service.createEmptySession(
        sessionId: nextId,
        userNumericId: userNumericId,
        gameType: gameType,
        sessionCounter: nextCounter,
      );
      _hasStarted = true;
    } catch (e) {
      debugPrint('❌ No se pudo crear sesión de juego: $e');
      _hasStarted = false;
    }
  }

  void recordHit() {
    _hits++;
  }

  void recordFail() {
    _fails++;
  }

  Future<void> finish() async {
    if (_isFinishing) return;
    _isFinishing = true;
    try {
      if (_startFuture != null) {
        await _startFuture;
      }
      if (!_hasStarted || _docId == null) return;

      if (_hits == 0 && _fails == 0) {
        await _service.deleteSessionByDoc(_docId!);
      } else {
        await _service.updateSessionStats(
          docId: _docId!,
          hits: _hits,
          fails: _fails,
        );
      }
    } finally {
      _docId = null;
      _hasStarted = false;
      _isFinishing = false;
    }
  }
}
