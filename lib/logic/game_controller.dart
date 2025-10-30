import 'dart:math';

class GameController {
  static final GameController _instance = GameController._internal();

  factory GameController() => _instance;

  GameController._internal();

  // ===============================
  // 🔧 CONFIGURACIÓN DEL JUEGO
  // ===============================
  int difficulty = 3; // cantidad de números
  int minRange = 0;
  int maxRange = 10;

  // ===============================
  // 🎮 ESTADO DEL JUEGO
  // ===============================
  late List<int> currentNumbers;
  late int targetNumber;
  final Random _random = Random();

  // Inicializa el juego con la configuración actual
  void initGame() {
    _generateNumbers();
  }

  void _generateNumbers() {
    currentNumbers = List.generate(
      difficulty,
          (_) => minRange + _random.nextInt(maxRange - minRange + 1),
    );

    targetNumber = currentNumbers[_random.nextInt(currentNumbers.length)];
  }

  // Comprueba si el número seleccionado es correcto
  bool checkAnswer(int selected) {
    return selected == targetNumber;
  }

  // Avanza al siguiente turno
  void nextRound() {
    _generateNumbers();
  }

  // ===============================
  // 🧩 MÉTODOS DE CONFIGURACIÓN
  // ===============================
  void setDifficulty(int value) {
    difficulty = value.clamp(1, 12);
  }

  void setRange(int min, int max) {
    minRange = min;
    maxRange = max;
  }
}
