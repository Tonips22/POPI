import 'dart:math';
import 'dart:math' as math;

class OrdenarGameController {
  // --- SINGLETON ---
  static final OrdenarGameController _instance = OrdenarGameController._internal();
  factory OrdenarGameController() => _instance;
  OrdenarGameController._internal();

  // --- CONFIGURACIÓN ---
  int difficulty = 4; // Tamaño de la secuencia
  int minRange = 0;
  int maxRange = 10;

  // --- LISTAS DEL JUEGO ---
  List<int> pool = [];
  List<int> sorted = [];

  // Cambiar dificultad
  void setDifficulty(int d) {
    difficulty = d;
  }

  // Cambiar rangos
  void setRange(int min, int max) {
    minRange = min;
    maxRange = max;
  }

  // Crea nueva ronda
  void initGame() {
    sorted.clear();
    pool.clear();

    final rand = math.Random();

    // Conjunto para evitar repetidos
    final Set<int> generated = {};

    while (generated.length < difficulty) {
      final n = minRange + rand.nextInt(maxRange - minRange + 1);
      generated.add(n); // si ya existe, no se añade
    }

    pool = generated.toList();
    sorted = List<int>.from(pool)..sort();
  }


  // Verifica si el número colocado es correcto
  bool isCorrectPlacement(int value, int index) {
    return sorted[index] == value;
  }
}
