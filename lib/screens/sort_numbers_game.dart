import 'package:flutter/material.dart';
import 'customization_screen.dart'; // Pantalla de ajustes (ya existe en el repo)
import '../widgets/number_tile.dart';
import '../widgets/target_slot.dart';

/// Pantalla básica del minijuego "Ordena la secuencia"
///
/// Cambios importantes en esta versión:
/// - Botón de ajustes arriba a la derecha (navega a CustomizationScreen).
/// - Al colocar un número en su posición correcta aparece un mensaje NO modal
///   que es una pastilla (pill) centrada abajo con el mismo color que los botones.
class SortNumbersGame extends StatefulWidget {
  const SortNumbersGame({super.key});

  @override
  State<SortNumbersGame> createState() => _SortNumbersGameState();
}

class _SortNumbersGameState extends State<SortNumbersGame> {
  // Número de fichas (0..9)
  final int count = 10;

  // pool: fichas disponibles para colocar (valores únicos)
  // targets: casillas objetivo (int? null = vacía)
  late List<int> pool;
  late List<int?> targets;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Generamos 0..(count-1) y los mezclamos
    pool = List<int>.generate(count, (i) => i)..shuffle();
    targets = List<int?>.filled(count, null);
    setState(() {});
  }

  /// Lógica central para procesar una entrega (drop) sobre una casilla:
  /// - Si viene desde otra casilla (fromIndex >= 0) -> intercambia/mueve.
  /// - Si viene del pool (fromIndex == -1) -> mueve desde pool a la casilla,
  ///   y si la casilla ya tenía un valor, ese valor vuelve al pool.
  void _handleDrop(DragItem dragItem, int targetIndex) {
    setState(() {
      final sourceIndex = dragItem.fromIndex;
      final sourceValue = dragItem.value;
      final targetPrev = targets[targetIndex];

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

    // Tras la actualización de estado mostramos feedback si la ficha está en su posición correcta
    final placedValue = targets[targetIndex];
    if (placedValue != null && placedValue == targetIndex) {
      _showPositivePill();
    }

    // Tras cualquier colocación comprobamos si el tablero está completo
    _checkCompletionAndShowResultIfNeeded();
  }

  /// Muestra un "pill" centrado en la parte baja de la pantalla.
  /// - Usa el color primario del Theme para que coincida con los botones.
  /// - Tiene borderRadius grande para apariencia circular/pastilla.
  /// - No ocupa todo el ancho (margin calculada para centrarlo).
  void _showPositivePill() {
    final messenger = ScaffoldMessenger.of(context);
    // Limpiamos cualquier SnackBar previo para evitar colas largas
    messenger.clearSnackBars();

    final screenWidth = MediaQuery.of(context).size.width;
    // Usamos una anchura aproximada del 50% de la pantalla para tablets
    final horizontalMargin = screenWidth * 0.25;

    // SnackBar con estilo "pill" y color primario del theme
    messenger.showSnackBar(
      SnackBar(
        // Texto motivador
        content: Text(
          '¡Correcto',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        // Margin permite controlar la anchura y la posición horizontal; bottom fija la distancia desde el final
        margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin, 24),
        backgroundColor: Colors.blue.shade400,
        // Forma con borderRadius alto para que parezca una pastilla (pill)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 6,
      ),
    );
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

  /// Comprueba si todas las casillas están llenas; si lo están, evalúa
  /// si la secuencia es ascendiente (ganado) o no (fallo), y muestra un diálogo.
  void _checkCompletionAndShowResultIfNeeded() {
    // Si hay alguna casilla vacía, no hacemos nada
    if (targets.any((e) => e == null)) return;

    final list = targets.cast<int>().toList();

    // Comprobamos orden ascendente (cada elemento >= anterior)
    bool isAscending = true;
    for (var i = 1; i < list.length; i++) {
      if (list[i] < list[i - 1]) {
        isAscending = false;
        break;
      }
    }

    // Mostramos resultado en un diálogo sencillo (modal pequeño)
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(isAscending ? '¡Ganado!' : 'No está correcto'),
        content: Text(isAscending
            ? '¡Enhorabuena! La secuencia está ordenada.'
            : 'La secuencia no está ordenada. Puedes volver a intentar.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
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
              // Navega a CustomizationScreen (ya existente en el repo).
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomizationScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: NumberTile(
                          value: value,
                          onTap: () {
                            // Al tocar una ficha del pool, la colocamos en la primera casilla vacía
                            final emptyIndex = targets.indexOf(null);
                            if (emptyIndex != -1) {
                              _handleDrop(DragItem(value: value, fromIndex: -1), emptyIndex);
                            } else {
                              // Mensaje simple si no hay huecos (usa SnackBar normal)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No quedan casillas libres')),
                              );
                            }
                          },
                          draggableData: DragItem(value: value, fromIndex: -1),
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