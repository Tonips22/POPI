import 'package:flutter/material.dart';
import 'package:popi/screens/settings_screen.dart';
import '../logic/game_controller.dart';
import '../logic/voice_controller.dart';
import '../widget/number_grid.dart';
import '../widgets/voice_text.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final GameController _controller = GameController();
  final VoiceController _voiceController = VoiceController();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller.initGame();
    _speakInstruction();
  }

  void _handleAnswer(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _message = '✅ ¡Correcto!';
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _controller.nextRound();
          _message = '';
        });
        _speakInstruction();
      });
    } else {
      setState(() {
        _message = '❌ Incorrecto';
      });
    }
  }

  Future<void> _speakTarget() async {
    await _voiceController.speak('${_controller.targetNumber}');
  }

  Future<void> _speakInstruction() async {
    await _voiceController.speak(
      'Toca el número ${_controller.targetNumber}',
    );
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

        title: const VoiceText(
          "Toca el número que suena",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
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
          const SizedBox(height: 30),

          // Botón de altavoz para repetir el número
          Center(
            child: IconButton(
              iconSize: screenWidth * 0.05,
              color: Colors.black,
              onPressed: _speakTarget,
              icon: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.volume_up),
              ),
            ),
          ),

          const SizedBox(height: 30),

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
            child: VoiceText(
              _message,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: _message.contains('Correcto')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}