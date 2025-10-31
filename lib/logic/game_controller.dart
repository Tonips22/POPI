import 'dart:math';

class GameController {
  static final GameController _instance = GameController._internal();

  factory GameController() => _instance;

  GameController._internal();

  int difficulty = 3;
  int minRange = 0;
  int maxRange = 10;

  late List<int> currentNumbers;
  late int targetNumber;
  final Random _random = Random();

  void initGame() {
    _generateNumbers();
  }

  void _generateNumbers() {
    int rangeSize = maxRange - minRange + 1;
    if (difficulty > rangeSize) {
      throw Exception(
        "La dificultad ($difficulty) no puede ser mayor que la cantidad de números únicos posibles ($rangeSize).",
      );
    }

    List<int> allNumbers =
    List.generate(rangeSize, (i) => minRange + i)..shuffle(_random);

    currentNumbers = allNumbers.take(difficulty).toList();
    targetNumber = currentNumbers[_random.nextInt(currentNumbers.length)];
  }

  bool checkAnswer(int selected) {
    return selected == targetNumber;
  }

  void nextRound() {
    _generateNumbers();
  }

  void setDifficulty(int value) {
    int maxAllowed = _calculateMaxDifficulty();
    difficulty = value.clamp(1, maxAllowed);
  }

  void setRange(int min, int max) {
    minRange = min;
    maxRange = max;

    int maxAllowed = _calculateMaxDifficulty();
    if (difficulty > maxAllowed) {
      difficulty = maxAllowed;
    }
  }

  int _calculateMaxDifficulty() {
    if (minRange == 0 && maxRange == 10) return 10;
    return 12;
  }
}