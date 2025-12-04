import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:popi/screens/settings_screen.dart';
import '../logic/game_controller.dart';
import '../widget/number_grid.dart';
import '../widgets/preference_provider.dart';
import '../widgets/check_icon_overlay.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final GameController _controller = GameController();
  final FlutterTts _flutterTts = FlutterTts();
  bool _showCheckIcon = false;
  bool _showErrorIcon = false;

  @override
  void initState() {
    super.initState();
    _controller.initGame();
    _speakInstruction();
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _showCheckIcon = true;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _controller.nextRound();
          _showCheckIcon = false;
        });
        _speakInstruction();
      });
    } else {
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

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenceProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        title: Text(
          "Toca el número que suena",
          style: TextStyle(
            fontSize: prefs?.getFontSizeValue() ?? 18,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
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
                      color: Colors.blue.shade400,
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
            CheckIconOverlay(color: Colors.blue.shade400),

          if (_showErrorIcon)
            CheckIconOverlay(
              color: Colors.red,
              icon: Icons.cancel,
            ),
        ],
      ),
    );
  }
}
