import 'package:flutter/material.dart';
import '../screens/sort_numbers_game.dart' show DragItem;
import 'number_tile.dart';

/// Casilla objetivo que acepta fichas arrastradas y también permite
/// arrastrar la ficha cuando ya contiene un valor.
///
/// Cambios realizados:
/// - Siempre actúa como DragTarget (aunque tenga valor). Esto permite
///   soltar sobre una casilla ocupada para intercambiar valores.
/// - Dentro del builder, si tiene valor, mostramos la ficha y la hacemos
///   LongPressDraggable para poder arrastrarla a otra casilla.
/// - shape: forma de la casilla ('circle', 'square', 'triangle')
class TargetSlot extends StatelessWidget {
  final int index;
  final int? value;
  final void Function(DragItem) onAccept;
  final VoidCallback onRemove;
  final Color color;
  final String shape;

  const TargetSlot({
    super.key,
    required this.index,
    required this.value,
    required this.onAccept,
    required this.onRemove,
    this.color = const Color(0xFF42A5F5), // Colors.blue.shade400 default
    this.shape = 'circle',
  });

  @override
  Widget build(BuildContext context) {
    const slotSize = 90.0;

    return DragTarget<DragItem>(
      onWillAccept: (data) => data != null,
      onAccept: (data) => onAccept(data),
      builder: (context, candidateData, rejectedData) {
        final highlight = candidateData.isNotEmpty;

        // Si tiene valor mostramos la ficha (draggable dentro del DragTarget).
        if (value != null) {
          final dragItem = DragItem(value: value!, fromIndex: index);
          return Stack(
            alignment: Alignment.center,
            children: [
              // Fondo de la casilla (resalta si hay un candidate)
              _buildEmptySlot(slotSize, highlight, color),

              // Ficha draggable: usamos LongPressDraggable para evitar arrastres accidentales
              LongPressDraggable<DragItem>(
                data: dragItem,
                feedback: Material(
                  color: Colors.transparent,
                  elevation: 8,
                  child: NumberTile(
                    value: value!,
                    draggableData: dragItem,
                    color: color,
                    shape: shape,
                  ),
                ),
                childWhenDragging: _buildEmptySlot(slotSize, false, Colors.grey.shade400),
                child: GestureDetector(
                  onTap: onRemove, // tocar la ficha la devuelve al pool
                  child: NumberTile(
                    value: value!,
                    draggableData: dragItem,
                    color: color,
                    shape: shape,
                  ),
                ),
              ),
            ],
          );
        }

        // Si está vacía, mostramos el cuadro vacío (resaltado si hay candidate)
        return _buildEmptySlot(slotSize, highlight, color);
      },
    );
  }

  /// Construye la casilla vacía con la forma adecuada
  Widget _buildEmptySlot(double size, bool highlight, Color accentColor) {
    return ClipPath(
      clipper: shape == 'triangle' ? TriangleClipper() : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: highlight ? accentColor.withOpacity(0.1) : Colors.grey.shade200,
          shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: shape == 'square' ? BorderRadius.circular(16) : null,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// CustomClipper para crear triángulos
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0); // Punto superior (centro arriba)
    path.lineTo(size.width, size.height); // Esquina inferior derecha
    path.lineTo(0, size.height); // Esquina inferior izquierda
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}