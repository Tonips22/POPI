import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../widget/number_grid.dart';
import '../services/tts_service.dart';
import 'settings_screen.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final GameController _controller = GameController();
  final TtsService _tts = TtsService(); // Instancia del TTS
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller.initGame();
  }

  void _handleAnswer(bool isCorrect) {
    setState(() {
      _message = isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto';
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _controller.nextRound();
        _message = '';
      });
    });
  }

  void _speakTargetNumber() {
    _tts.speak("El número a adivinar es ${_controller.targetNumber}");
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
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
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            NumberGrid(
              controller: _controller,
              onAnswer: _handleAnswer,
            ),
            const SizedBox(height: 40),
            Text(
              _message,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _message.contains('Correcto') ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 60),
            IconButton(
              iconSize: 60,
              color: Colors.black,
              onPressed: _speakTargetNumber,
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.volume_up),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
