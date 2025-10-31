import 'package:flutter/material.dart';

/// Lista de colores predefinidos disponibles para que el usuario elija
///
/// Estos colores están pensados para:
/// - Ser fácilmente distinguibles
/// - Tener buen contraste
/// - Ser accesibles para personas con discapacidad visual
class AppColors {
  // Lista de colores disponibles con sus nombres
  static final List<ColorOption> availableColors = [
    ColorOption(color: Colors.blue, name: 'Azul'),
    ColorOption(color: Colors.green, name: 'Verde'),
    ColorOption(color: Colors.red, name: 'Rojo'),
    ColorOption(color: Colors.orange, name: 'Naranja'),
    ColorOption(color: Colors.purple, name: 'Morado'),
    ColorOption(color: Colors.pink, name: 'Rosa'),
    ColorOption(color: Colors.yellow.shade700, name: 'Amarillo'),
    ColorOption(color: Colors.teal, name: 'Turquesa'),
    ColorOption(color: Colors.brown, name: 'Marrón'),
    ColorOption(color: Colors.grey, name: 'Gris'),
  ];

  // Colores para fondos (tonos más claros y suaves)
  static final List<ColorOption> backgroundColors = [
    ColorOption(color: Colors.white, name: 'Blanco'),
    ColorOption(color: Colors.grey.shade100, name: 'Gris claro'),
    ColorOption(color: Colors.blue.shade50, name: 'Azul claro'),
    ColorOption(color: Colors.green.shade50, name: 'Verde claro'),
    ColorOption(color: Colors.yellow.shade50, name: 'Amarillo claro'),
    ColorOption(color: Colors.pink.shade50, name: 'Rosa claro'),
    ColorOption(color: Colors.purple.shade50, name: 'Morado claro'),
    ColorOption(color: Colors.orange.shade50, name: 'Naranja claro'),
  ];
}

/// Clase que representa una opción de color con su nombre
class ColorOption {
  final Color color;
  final String name;

  ColorOption({
    required this.color,
    required this.name,
  });
}