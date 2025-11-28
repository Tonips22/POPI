import 'package:flutter/material.dart';
import '../screens/sort_numbers_game.dart' show DragItem;

/// Ficha con número que puede arrastrarse o tocarse.
///
/// - draggableData: dato que se "transporta" al arrastrar.
/// - onTap: acción cuando se toca la ficha (p. ej. colocar en la primera casilla libre).
class NumberTile extends StatelessWidget {
  final int value;
  final VoidCallback? onTap;
  final DragItem draggableData;

  const NumberTile({
    super.key,
    required this.value,
    this.onTap,
    required this.draggableData,
  });

  @override
  Widget build(BuildContext context) {
    // Tamaño pensado para tablet; puedes ajustar según necesidades
    final tileSize = 80.0;
    return Draggable<DragItem>(
      data: draggableData,
      feedback: Material(
        color: Colors.transparent,
        elevation: 8,
        child: _buildTile(tileSize, opacity: 0.95),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildTile(tileSize),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: _buildTile(tileSize),
      ),
    );
  }

  Widget _buildTile(double size, {double opacity = 1.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue.shade400.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$value',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}