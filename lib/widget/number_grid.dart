import 'package:flutter/material.dart';
import '../logic/game_controller.dart';

class NumberGrid extends StatelessWidget {
  final GameController controller;
  final Function(bool) onAnswer;

  const NumberGrid({
    super.key,
    required this.controller,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center, // Centra los elementos horizontalmente
        spacing: 20,
        runSpacing: 20,
        children: controller.currentNumbers
            .map(
              (num) => GestureDetector(
            onTap: () {
              bool isCorrect = controller.checkAnswer(num);
              onAnswer(isCorrect);
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(60),
              ),
              alignment: Alignment.center,
              child: Text(
                '$num',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
