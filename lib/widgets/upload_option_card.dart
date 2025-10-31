import 'package:flutter/material.dart';

/// Tarjeta de opción para subir contenido personalizado
/// 
/// Permite al estudiante subir:
/// - Imágenes propias para los objetos
/// - Audios propios para los números
class UploadOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasContent; // Indica si ya se subió algo

  const UploadOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === ICONO ===
            Stack(
              children: [
                Icon(
                  icon,
                  size: 64,
                  color: Colors.blue,
                ),
                // Si ya hay contenido, mostramos un check verde
                if (hasContent)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // === TEXTO ===
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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