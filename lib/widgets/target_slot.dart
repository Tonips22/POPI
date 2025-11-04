import 'package:flutter/material.dart';
import '../screens/sort_numbers_game.dart' show DragItem;
import 'number_tile.dart';

/// Casilla objetivo que acepta fichas arrastradas y también permite
/// arrastrar la ficha cuando ya contiene un valor.
class TargetSlot extends StatelessWidget {
  final int index;
  final int? value;
  final void Function(DragItem) onAccept;
  final VoidCallback onRemove;

  const TargetSlot({
    super.key,
    required this.index,
    required this.value,
    required this.onAccept,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final slotSize = 90.0;
    // Si tiene valor, mostramos la ficha dentro y la hacemos Draggable
    if (value != null) {
      // Draggable desde target: indicamos fromIndex = index
      final dragItem = DragItem(value: value!, fromIndex: index);
      return LongPressDraggable<DragItem>(
        data: dragItem,
        feedback: Material(
          color: Colors.transparent,
          elevation: 8,
          child: NumberTile(value: value!, draggableData: dragItem),
        ),
        childWhenDragging: _emptyBox(slotSize),
        child: GestureDetector(
          onTap: onRemove, // Tocando la casilla vaciamos (devuelve al pool)
          child: NumberTile(value: value!, draggableData: dragItem),
        ),
      );
    }

    // Si está vacía, es un DragTarget que acepta DragItem
    return DragTarget<DragItem>(
      onWillAccept: (data) => data != null,
      onAccept: (data) => onAccept(data),
      builder: (context, candidateData, rejectedData) {
        final highlight = candidateData.isNotEmpty;
        return Container(
          width: slotSize,
          height: slotSize,
          decoration: BoxDecoration(
            color: highlight ? Colors.blue.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _emptyBox(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
    );
  }
}