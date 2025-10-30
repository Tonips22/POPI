import 'package:flutter/material.dart';

/// Widget reutilizable que representa cada opción de personalización
/// 
/// Muestra una tarjeta con:
/// - Un icono a la izquierda
/// - Un texto descriptivo en el centro
/// - Una flecha de navegación a la derecha
class CustomizationOptionCard extends StatelessWidget {
  // Icono que se mostrará a la izquierda
  final IconData icon;
  
  // Texto que describe la opción
  final String title;
  
  // Color de fondo del icono
  final Color iconBackgroundColor;
  
  // Función que se ejecuta al tocar la tarjeta
  final VoidCallback onTap;

  const CustomizationOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // Elevación para dar sensación de profundidad
        elevation: 2,
        // Bordes redondeados
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          // Hace la tarjeta clickeable con efecto visual
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // === ICONO A LA IZQUIERDA ===
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // === TEXTO EN EL CENTRO ===
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // === FLECHA A LA DERECHA ===
                const Icon(
                  Icons.chevron_right,
                  size: 32,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}