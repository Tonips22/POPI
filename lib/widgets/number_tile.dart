import 'package:flutter/material.dart';
import '../screens/sort_numbers_game.dart' show DragItem;

/// Ficha con número que puede arrastrarse o tocarse.
///
/// - draggableData: dato que se "transporta" al arrastrar.
/// - onTap: acción cuando se toca la ficha (p. ej. colocar en la primera casilla libre).
/// - shape: forma del tile ('circle', 'square', 'triangle')
class NumberTile extends StatelessWidget {
  final int value;
  final VoidCallback? onTap;
  final DragItem draggableData;
  final Color color;
  final String shape;

  const NumberTile({
    super.key,
    required this.value,
    this.onTap,
    required this.draggableData,
    this.color = const Color(0xFF42A5F5), // Colors.blue.shade400 default
    this.shape = 'circle',
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
    return ClipPath(
      clipper: shape == 'triangle' ? TriangleClipper() : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: shape == 'square' ? BorderRadius.circular(16) : null,
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