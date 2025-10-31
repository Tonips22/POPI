import 'package:flutter/material.dart';

/// Tarjeta de opción para seleccionar el formato de visualización de números
/// 
/// Muestra:
/// - Un icono representativo
/// - Un texto descriptivo
/// - Borde azul cuando está seleccionada
class NumberFormatOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NumberFormatOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // Si está seleccionado, borde azul grueso; si no, borde gris fino
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === ICONO ===
            Icon(
              icon,
              size: 64,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
            ),
            
            const SizedBox(height: 16),
            
            // === TEXTO ===
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}