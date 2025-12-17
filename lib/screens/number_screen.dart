import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:popi/screens/settings_screen.dart';
import '../logic/game_controller.dart';
import '../widget/number_grid.dart';
// import '../widgets/preference_provider.dart';
import '../widgets/check_icon_overlay.dart';
import '../widgets/reaction_overlay.dart';
import '../services/app_service.dart';
import '../services/game_session_tracker.dart';
import 'game_selector_screen.dart';
import 'game_victory_screen.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final GameController _controller = GameController();
  final FlutterTts _flutterTts = FlutterTts();
  final AppService _service = AppService();
  bool _showCheckIcon = false;
  bool _showErrorIcon = false;
  GameSessionTracker? _sessionTracker;
  int _hits = 0;
  int _fails = 0;
  bool _showReactionEffect = false;

  int get _targetRounds {
    final prefs = _service.currentUser?.preferences;
    return prefs?.touchGameRounds ?? 5;
  }

  @override
  void initState() {
    super.initState();
    _applyDifficultySettings();
    _controller.initGame();
    _speakInstruction();
    _initSessionTracker();
  }

  void _applyDifficultySettings() {
    final prefs = _service.currentUser?.preferences;
    if (prefs == null) return;
    final minRange = prefs.touchGameRangeMin;
    final maxRange = prefs.touchGameRangeMax > minRange
        ? prefs.touchGameRangeMax
        : minRange + 10;
    _controller.setRange(minRange, maxRange);
    _controller.setDifficulty(prefs.touchGameDifficulty);
  }

  void _initSessionTracker() {
    if (!_service.hasStudentSession) return;
    final tracker = GameSessionTracker(
      gameType: 1,
      userNumericId: _service.numericUserId,
    );
    _sessionTracker = tracker;
    tracker.start();
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      _hits++;
      final int maxRounds = _targetRounds;
      final bool hasCompletedSession =
          maxRounds > 0 && _hits >= maxRounds;
      _sessionTracker?.recordHit();
      final bool showReaction =
          _service.currentUser?.preferences.reactionType == 'confetti';
      setState(() {
        _showCheckIcon = true;
        _showReactionEffect = showReaction;
      });

      final successDelay =
          showReaction ? const Duration(milliseconds: 1400) : const Duration(milliseconds: 800);
      Future.delayed(successDelay, () async {
        setState(() {
          _showCheckIcon = false;
          _showReactionEffect = false;
          if (!hasCompletedSession) {
            _controller.nextRound();
          }
        });
        if (hasCompletedSession) {
          await _showVictoryScreen();
        } else {
          _speakInstruction();
        }
      });
    } else {
      _fails++;
      _sessionTracker?.recordFail();
      setState(() {
        _showErrorIcon = true;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _showErrorIcon = false;
        });
      });
    }
  }

  void _speakTarget() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("${_controller.targetNumber}");
  }

  void _speakInstruction() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("Toca el número ${_controller.targetNumber}");
  }

  Future<void> _finishSession() async {
    await _sessionTracker?.finish();
  }

  Future<void> _showVictoryScreen() async {
    await _finishSession();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (victoryContext) => GameVictoryScreen(
          onRestart: () {
            Navigator.pushReplacement(
              victoryContext,
              MaterialPageRoute(builder: (_) => const NumberScreen()),
            );
          },
          onHome: () {
            Navigator.pushReplacement(
              victoryContext,
              MaterialPageRoute(builder: (_) => const ChooseGameScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sessionTracker?.finish();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final prefs = PreferenceProvider.of(context);
    final userColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.primaryColor))
        : Colors.blue.shade400;
    final secondaryColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.secondaryColor))
        : Colors.green;
    final backgroundColor = _service.currentUser != null
        ? Color(int.parse(_service.currentUser!.preferences.backgroundColor))
        : Colors.grey[50]!;
    final titleFontSize = _service.fontSizeWithFallback();
    final titleFontFamily = _service.fontFamilyWithFallback();
    final userShape = _service.currentUser?.preferences.shape ?? 'circle';

    return WillPopScope(
      onWillPop: () async {
        await _finishSession();
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          "Toca el número que suena",
          style: TextStyle(
            fontSize: titleFontSize * 0.9,
            fontFamily: titleFontFamily,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              setState(() {
                _applyDifficultySettings();
                _controller.initGame();
              });
              _speakInstruction();
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de volumen
                    IconButton(
                      iconSize: 64,
                      color: userColor,
                      onPressed: _speakTarget,
                      icon: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.volume_up, size: 48),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Grid de números
                    Expanded(
                      child: NumberGrid(
                        controller: _controller,
                        onAnswer: _handleAnswer,
                        primaryColor: userColor,
                        shape: userShape,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Mensaje de feedback (oculto pero mantiene espacio)
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          if (_showCheckIcon)
            CheckIconOverlay(color: secondaryColor),

          ReactionOverlay(enabled: _showReactionEffect),

          if (_showErrorIcon)
            CheckIconOverlay(
              color: Colors.grey.shade400,
              icon: Icons.cancel,
            ),
        ],
      ),
    ),
    );
  }
}
