import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/number_tile.dart';
import '../widgets/target_slot.dart';

/// Pantalla básica del minijuego "Ordena la secuencia"
///
/// - Genera una lista de números únicos aleatorios según `count` y `range`.
/// - Muestra las fichas en la parte superior (pool) como Draggables/tocables.
/// - Muestra las casillas objetivo (targets) en la parte inferior.
/// - Permite colocar, reemplazar y retirar números.
/// - Botones: Comprobar (si están ordenados de forma ascendente), Mezclar, Reiniciar.
///
/// Esta implementación prioriza claridad y legibilidad para principiantes.
/// No usa patrones avanzados de estado.
class SortNumbersGame extends StatefulWidget {
  const SortNumbersGame({super.key});

  @override
  State<SortNumbersGame> createState() => _SortNumbersGameState();
}

class _SortNumbersGameState extends State<SortNumbersGame> {
  // Configuración básica del juego (más adelante podría ser configurable)
  final int count = 9; // número de elementos a ordenar
  final int rangeMax = 20; // números aleatorios entre 1..rangeMax

  // Estado del juego:
  // - pool: fichas disponibles para colocar (valores únicos)
  // - targets: lista de longitud `count` con `int?` (null = vacío)
  late List<int> pool;
  late List<int?> targets;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final generated = _generateUniqueRandomNumbers(count, rangeMax);
    // Mostramos los números DESORDENADOS (mezclados)
    pool = List<int>.from(generated)..shuffle();
    targets = List<int?>.filled(count, null);
    setState(() {});
  }

  List<int> _generateUniqueRandomNumbers(int n, int maxExclusive) {
    // Genera una lista de n valores únicos entre 1 y maxExclusive (inclusive)
    final rnd = Random();
    final set = <int>{};
    while (set.length < n) {
      set.add(1 + rnd.nextInt(maxExclusive)); // 1..maxExclusive
    }
    return set.toList();
  }

  // Coloca un valor en el target index. Si el target ya tenía un valor,
  // lo devuelve al pool.
  void _placeValueInTarget(int value, int targetIndex, {int fromTargetIndex = -1}) {
    setState(() {
      // Si venía desde otro target, limpiamos ese origen
      if (fromTargetIndex >= 0 && fromTargetIndex < targets.length) {
        targets[fromTargetIndex] = null;
      } else {
        // Si venía del pool, lo removemos del pool
        pool.remove(value);
      }

      // Si el target ya tenía algo, lo devolvemos al pool
      final previous = targets[targetIndex];
      if (previous != null) {
        pool.add(previous);
      }

      targets[targetIndex] = value;
    });
  }

  // Quita el valor de un target y lo devuelve al pool
  void _removeFromTarget(int targetIndex) {
    setState(() {
      final value = targets[targetIndex];
      if (value != null) {
        pool.add(value);
      }
      targets[targetIndex] = null;
    });
  }

  // Mueve un valor del pool al primer target vacío (si existe)
  void _placeInFirstEmptyTarget(int value) {
    final emptyIndex = targets.indexOf(null);
    if (emptyIndex != -1) {
      _placeValueInTarget(value, emptyIndex);
    } else {
      // Si no hay vacíos, muestra un mensaje corto
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quedan casillas libres')),
      );
    }
  }

  // Comprueba si la secuencia en targets está ordenada de forma ascendente y sin huecos
  bool _isCorrectOrder() {
    // Si hay casillas vacías -> no está completo
    if (targets.any((e) => e == null)) return false;

    final list = targets.cast<int>().toList();
    for (var i = 1; i < list.length; i++) {
      if (list[i] < list[i - 1]) return false;
    }
    return true;
  }

  // Mezcla pool (vuelve a poner en pool todos los valores y los desordena)
  void _shuffleGame() {
    setState(() {
      // mover todo a pool
      for (final v in targets) {
        if (v != null) pool.add(v);
      }
      targets = List<int?>.filled(count, null);
      pool.shuffle();
    });
  }

  // Reinicia generando nuevos números
  void _resetGame() => _initializeGame();

  @override
  Widget build(BuildContext context) {
    // Para tablets, usamos mucho espacio horizontal; por eso centramos y limitamos ancho
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ordena la secuencia'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // INSTRUCCIÓN SIMPLE
                const Text(
                  'Arrastra o toca las fichas para colocarlas en las casillas abajo en orden creciente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                // --- POOL (fichas disponibles) ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pool.map((value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: NumberTile(
                          value: value,
                          // Al tocar la ficha la colocamos en la primera casilla libre
                          onTap: () => _placeInFirstEmptyTarget(value),
                          // Cuando se arrastra desde el pool, data indica value y fromTargetIndex = -1
                          draggableData: DragItem(value: value, fromIndex: -1),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // --- CASILLAS TARGET ---
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(targets.length, (index) {
                    final val = targets[index];
                    return TargetSlot(
                      index: index,
                      value: val,
                      // Aceptamos DragItem y lo procesamos
                      onAccept: (dragItem) {
                        // Si viene desde otro target, pasamos su index
                        _placeValueInTarget(dragItem.value, index, fromTargetIndex: dragItem.fromIndex);
                      },
                      onRemove: () => _removeFromTarget(index),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // --- BOTONES DE ACCIÓN ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Mezclar'),
                      onPressed: _shuffleGame,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restore),
                      label: const Text('Reiniciar'),
                      onPressed: _resetGame,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Comprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        final ok = _isCorrectOrder();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok ? '¡Correcto! Secuencia ordenada.' : 'Aún no está correcto.'),
                            backgroundColor: ok ? Colors.green : Colors.redAccent,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Estructura simple que transporta el valor arrastrado y su origen
class DragItem {
  final int value;
  /// fromIndex = -1 indica que viene del "pool" de fichas; >=0 indica el index del target origen
  final int fromIndex;

  DragItem({required this.value, required this.fromIndex});
}