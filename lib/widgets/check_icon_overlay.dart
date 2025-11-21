import 'package:flutter/material.dart';

/// Widget que muestra un icono de check grande en la parte inferior de la pantalla
class CheckIconOverlay extends StatelessWidget {
  final Color color;
  final double size;
  final double bottomPosition;

  const CheckIconOverlay({
    super.key,
    required this.color,
    this.size = 120,
    this.bottomPosition = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPosition,
      left: 0,
      right: 0,
      child: Center(
        child: Icon(
          Icons.check_circle,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
