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
class TargetSlot extends StatelessWidget {
  final int index;
  final int? value;
  final void Function(DragItem) onAccept;
  final VoidCallback onRemove;
  final Color color;

  const TargetSlot({
    super.key,
    required this.index,
    required this.value,
    required this.onAccept,
    required this.onRemove,
    this.color = const Color(0xFF42A5F5), // Colors.blue.shade400 default
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
              Container(
                width: slotSize,
                height: slotSize,
                decoration: BoxDecoration(
                  color: highlight ? color.withOpacity(0.1) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2,
                  ),
                ),
              ),

              // Ficha draggable: usamos LongPressDraggable para evitar arrastres accidentales
              LongPressDraggable<DragItem>(
                data: dragItem,
                feedback: Material(
                  color: Colors.transparent,
                  elevation: 8,
                  child: NumberTile(value: value!, draggableData: dragItem, color: color),
                ),
                childWhenDragging: Container(
                  width: slotSize,
                  height: slotSize,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                ),
                child: GestureDetector(
                  onTap: onRemove, // tocar la ficha la devuelve al pool
                  child: NumberTile(value: value!, draggableData: dragItem, color: color),
                ),
              ),
            ],
          );
        }

        // Si está vacía, mostramos el cuadro vacío (resaltado si hay candidate)
        return Container(
          width: slotSize,
          height: slotSize,
          decoration: BoxDecoration(
            color: highlight ? color.withOpacity(0.1) : Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        );
      },
    );
  }
}