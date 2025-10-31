import 'dart:math';

class GameController {
  static final GameController _instance = GameController._internal();

  factory GameController() => _instance;

  GameController._internal();

  // ===============================
  // 🔧 CONFIGURACIÓN DEL JUEGO
  // ===============================
  int difficulty = 3; // cantidad de números a mostrar
  int minRange = 0;
  int maxRange = 10;

  // ===============================
  // 🎮 ESTADO DEL JUEGO
  // ===============================
  late List<int> currentNumbers;
  late int targetNumber;
  final Random _random = Random();

  // ===============================
  // ⚙️ MÉTODOS DE INICIALIZACIÓN
  // ===============================
  void initGame() {
    _generateNumbers();
  }

  void _generateNumbers() {
    int rangeSize = maxRange - minRange + 1;

    // Evita errores si la dificultad es mayor que el rango disponible
    if (difficulty > rangeSize) {
      throw Exception(
        "La dificultad ($difficulty) no puede ser mayor que la cantidad de números únicos posibles ($rangeSize).",
      );
    }

    // Genera lista de números únicos dentro del rango y la mezcla
    List<int> allNumbers =
    List.generate(rangeSize, (i) => minRange + i)..shuffle(_random);

    // Toma solo los primeros 'difficulty' números únicos
    currentNumbers = allNumbers.take(difficulty).toList();

    // Selecciona un número objetivo aleatorio
    targetNumber = currentNumbers[_random.nextInt(currentNumbers.length)];
  }

  // ===============================
  // 🎯 LÓGICA DEL JUEGO
  // ===============================
  bool checkAnswer(int selected) {
    return selected == targetNumber;
  }

  void nextRound() {
    _generateNumbers();
  }

  // ===============================
  // 🧩 MÉTODOS DE CONFIGURACIÓN
  // ===============================

  /// Ajusta la dificultad sin superar el máximo permitido según el rango
  void setDifficulty(int value) {
    int maxAllowed = _calculateMaxDifficulty();
    difficulty = value.clamp(1, maxAllowed);
  }

  /// Ajusta el rango y valida que la dificultad siga siendo válida
  void setRange(int min, int max) {
    minRange = min;
    maxRange = max;

    // Recalcular dificultad máxima y ajustar si es necesario
    int maxAllowed = _calculateMaxDifficulty();
    if (difficulty > maxAllowed) {
      difficulty = maxAllowed;
    }
  }

  /// Calcula la dificultad máxima en función del rango actual
  int _calculateMaxDifficulty() {
    // Si el rango es 0–10, dificultad máxima 10
    if (minRange == 0 && maxRange == 10) return 10;

    // En otros casos, se permite hasta 12 por defecto
    return 12;
  }
}
