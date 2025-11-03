import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:popi/screens/settings_screen.dart';
import '../logic/game_controller.dart';
import '../widget/number_grid.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final GameController _controller = GameController();
  final FlutterTts _flutterTts = FlutterTts();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller.initGame();
    _speakInstruction();
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
      _speakInstruction();
    });
  }

  void _speakTarget() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("${_controller.targetNumber}");
  }

  void _speakInstruction() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("Selecciona el número ${_controller.targetNumber}");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberGrid(
                controller: _controller,
                onAnswer: _handleAnswer,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              _message,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: _message.contains('Correcto')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              iconSize: screenWidth * 0.08,
              color: Colors.black,
              onPressed: _speakTarget,
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(screenWidth * 0.015),
                child: const Icon(Icons.volume_up),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
