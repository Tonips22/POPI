import 'package:flutter/material.dart';

/// Widget que muestra un icono de check grande en la parte inferior de la pantalla
class CheckIconOverlay extends StatelessWidget {
  final Color color;
  final double size;
  final double bottomPosition;
  final IconData icon;

  const CheckIconOverlay({
    super.key,
    required this.color,
    this.size = 120,
    this.bottomPosition = 40,
    this.icon = Icons.check_circle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPosition,
      left: 0,
      right: 0,
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
