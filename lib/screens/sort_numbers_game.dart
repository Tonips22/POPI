import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/number_tile.dart';
import '../widgets/target_slot.dart';
import '../widgets/check_icon_overlay.dart';
import 'settings_screen.dart'; // Pantalla de ajustes (ya existe en el repo)
import 'game_victory_screen.dart';
import 'game_selector_screen.dart';

/// Pantalla básica del minijuego "Ordena la secuencia"
///
/// Cambios importantes en esta versión:
/// - Botón de ajustes arriba a la derecha (navega a SettingsScreen).
/// - Al colocar un número en su posición correcta aparece un mensaje NO modal
///   que es una pastilla (pill) centrada abajo con el mismo color que los botones.
class SortNumbersGame extends StatefulWidget {
  const SortNumbersGame({super.key});

  @override
  State<SortNumbersGame> createState() => _SortNumbersGameState();
}

class _SortNumbersGameState extends State<SortNumbersGame> with SingleTickerProviderStateMixin {
  // Número de fichas (0..9)
  final int count = 10;

  // pool: fichas disponibles para colocar (valores únicos)
  // targets: casillas objetivo (int? null = vacía)
  late List<int> pool;
  late List<int?> targets;
  
  // Para la animación de temblor
  late AnimationController _shakeController;
  int? _shakingValue; // Qué número está temblando
  bool _showCheckIcon = false; // Controla la visibilidad del icono de check

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initializeGame();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    // Generamos 0..(count-1) y los mezclamos
    pool = List<int>.generate(count, (i) => i)..shuffle();
    targets = List<int?>.filled(count, null);
    setState(() {});
  }

  /// Lógica central para procesar una entrega (drop) sobre una casilla:
  /// - Solo permite colocar un número si coincide con el índice de la casilla.
  /// - Si viene desde otra casilla (fromIndex >= 0) -> intercambia/mueve solo si ambos están en posiciones correctas.
  /// - Si viene del pool (fromIndex == -1) -> mueve desde pool a la casilla solo si el número coincide con el índice,
  ///   y si la casilla ya tenía un valor, ese valor vuelve al pool.
  void _handleDrop(DragItem dragItem, int targetIndex) {
    final sourceIndex = dragItem.fromIndex;
    final sourceValue = dragItem.value;
    final targetPrev = targets[targetIndex];

    // VALIDACIÓN: Solo permitimos colocar el número si coincide con su posición
    if (sourceValue != targetIndex) {
      // El número no corresponde a esta posición, rechazamos el drop
      return;
    }

    setState(() {
      // Si viene desde otra casilla
      if (sourceIndex >= 0) {
        // Si es la misma casilla, no hacemos nada
        if (sourceIndex == targetIndex) return;

        // Intercambiamos: la casilla destino recibe el valor arrastrado
        // y la casilla origen recibe lo que antes había en la destino
        targets[targetIndex] = sourceValue;
        targets[sourceIndex] = targetPrev;
      } else {
        // Viene del pool: removemos el valor del pool
        pool.remove(sourceValue);

        // Si la casilla destino tenía un valor, lo devolvemos al pool
        if (targetPrev != null) {
          pool.add(targetPrev);
        }

        targets[targetIndex] = sourceValue;
      }
    });

    // Tras la actualización de estado mostramos feedback (siempre es correcto si llegamos aquí)
    _showPositivePill();

    // Tras cualquier colocación comprobamos si el tablero está completo
    _checkCompletionAndShowResultIfNeeded();
  }

  /// Muestra un icono de check grande en el centro de la pantalla
  void _showPositivePill() {
    setState(() {
      _showCheckIcon = true;
    });
    
    // Ocultarlo después de 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showCheckIcon = false;
        });
      }
    });
  }

  /// Anima un temblor para indicar que el número no puede colocarse ahí
  void _shakeNumber(int value) {
    setState(() {
      _shakingValue = value;
    });
    _shakeController.forward(from: 0.0).then((_) {
      setState(() {
        _shakingValue = null;
      });
    });
  }

  /// Vacía una casilla y devuelve su valor al pool (p. ej. al tocar la ficha).
  void _removeFromTarget(int targetIndex) {
    setState(() {
      final value = targets[targetIndex];
      if (value != null) {
        pool.add(value);
      }
      targets[targetIndex] = null;
    });
  }

  /// Comprueba si todas las casillas están llenas; si lo están,
  /// navega a la pantalla de victoria (ya que por lógica siempre están correctas).
  void _checkCompletionAndShowResultIfNeeded() {
    // Si hay alguna casilla vacía, no hacemos nada
    if (targets.any((e) => e == null)) return;

    // Si todas las casillas están llenas, el jugador ha ganado
    // (ya que solo se permiten números en sus posiciones correctas)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameVictoryScreen(
          onRestart: () {
            // Volver a esta pantalla y reiniciar el juego
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SortNumbersGame(),
              ),
            );
          },
          onHome: () {
            // Ir a la pantalla de selección de juegos
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ChooseGameScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CENTRADO: usamos Center con Column mainAxisSize.min para centrar todo
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ordena la secuencia'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),

        // === BOTÓN DE AJUSTES (tres puntitos verticales) ===
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Ajustes',
            onPressed: () {
              // Navega a settings_screen (ya existente en el repo).
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              // Column con mainAxisSize.min hace que su tamaño sea el mínimo
              // necesario, así el Center lo colocará correctamente centrado.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // POOL: fichas disponibles (0..9)
                    SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: pool.map((value) {
                      final isShaking = _shakingValue == value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AnimatedBuilder(
                          animation: _shakeController,
                          builder: (context, child) {
                            final offset = isShaking
                                ? math.sin(_shakeController.value * math.pi * 4) * 10
                                : 0.0;
                            return Transform.translate(
                              offset: Offset(offset, 0),
                              child: child,
                            );
                          },
                          child: NumberTile(
                          value: value,
                          onTap: () {
                            // Al tocar una ficha del pool, intentamos colocarla en la próxima casilla vacía
                            final emptyIndex = targets.indexOf(null);
                            if (emptyIndex != -1) {
                              // Verificamos si el número coincide con la posición vacía
                              if (value == emptyIndex) {
                                // Es la posición correcta, colocamos
                                _handleDrop(DragItem(value: value, fromIndex: -1), emptyIndex);
                              } else {
                                // No es la posición correcta, hacemos temblar el número
                                _shakeNumber(value);
                              }
                            } else {
                              // No hay casillas vacías
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No quedan casillas libres')),
                              );
                            }
                          },
                          draggableData: DragItem(value: value, fromIndex: -1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // CASILLAS: ahora son 'count' casillas que aceptan arrastres y permiten intercambios
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(targets.length, (index) {
                    final val = targets[index];
                    return TargetSlot(
                      index: index,
                      value: val,
                      onAccept: (dragItem) => _handleDrop(dragItem, index),
                      onRemove: () => _removeFromTarget(index),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Overlay con el icono de check
      if (_showCheckIcon)
        CheckIconOverlay(
          color: Colors.blue.shade400,
        ),
      ],
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