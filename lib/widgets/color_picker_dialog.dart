import 'package:flutter/material.dart';
import '../utils/color_constants.dart';

/// Diálogo que muestra una cuadrícula de colores para que el usuario elija
///
/// Parámetros:
/// - initialColor: Color actualmente seleccionado (para marcarlo)
/// - colors: Lista de opciones de color disponibles
/// - title: Título del diálogo
class ColorPickerDialog extends StatelessWidget {
  final Color? initialColor;
  final List<ColorOption> colors;
  final String title;

  const ColorPickerDialog({
    super.key,
    this.initialColor,
    required this.colors,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla para hacer el diálogo adaptable
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      // Hace el diálogo más grande y cómodo para tablets
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          // Limita el ancho máximo
          maxWidth: 600,
          // Limita el alto máximo para evitar desbordamientos
          maxHeight: screenHeight * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === TÍTULO DEL DIÁLOGO ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Botón para cerrar el diálogo
                IconButton(
                  icon: const Icon(Icons.close, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === CUADRÍCULA DE COLORES CON SCROLL ===
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  // Evita que el GridView intente desplazarse dentro del SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // Ajustamos las columnas según el ancho de la pantalla
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // En tablets más anchas, mostramos 5 columnas; en más estrechas, 4
                    crossAxisCount: screenWidth > 600 ? 5 : 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    // 👇 MUY IMPORTANTE: Reducimos más para dar espacio extra
                    childAspectRatio: 0.7,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final colorOption = colors[index];
                    final isSelected = initialColor?.value == colorOption.color.value;

                    return _ColorCircle(
                      colorOption: colorOption,
                      isSelected: isSelected,
                      onTap: () {
                        // Devuelve el color seleccionado y cierra el diálogo
                        Navigator.pop(context, colorOption.color);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que muestra un círculo de color individual
///
/// 👇 REDISEÑADO: Usa LayoutBuilder para calcular el espacio disponible
class _ColorCircle extends StatelessWidget {
  final ColorOption colorOption;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCircle({
    required this.colorOption,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 👇 CLAVE: LayoutBuilder nos dice cuánto espacio tenemos disponible
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos el tamaño del círculo basándonos en el espacio disponible
        // Usamos el 60% del ancho o alto (el que sea menor) para el círculo
        final circleSize = (constraints.maxWidth * 0.6).clamp(40.0, 55.0);

        // Calculamos el tamaño del texto basándonos en el espacio restante
        final textFontSize = (circleSize * 0.2).clamp(10.0, 12.0);

        return GestureDetector(
          onTap: onTap,
          // 👇 NUEVO: Usamos un Stack en lugar de Column para controlar mejor las posiciones
          child: Stack(
            children: [
              // === ÁREA COMPLETA (INVISIBLE, SOLO PARA HACER CLIC) ===
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.transparent,
              ),

              // === CONTENIDO CENTRADO ===
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // === CÍRCULO DE COLOR ===
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: colorOption.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black26,
                          width: 2,
                        ),
                        // Si está seleccionado, añade sombra
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                            : null,
                      ),
                      // Si está seleccionado, muestra un check
                      child: isSelected
                          ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: circleSize * 0.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                          ),
                        ],
                      )
                          : null,
                    ),

                    // === ESPACIADO ===
                    SizedBox(height: constraints.maxHeight * 0.05),

                    // === NOMBRE DEL COLOR ===
                    // 👇 NUEVO: Contenedor con altura limitada para el texto
                    SizedBox(
                      height: constraints.maxHeight * 0.25,
                      child: Center(
                        child: Text(
                          colorOption.name,
                          style: TextStyle(
                            fontSize: textFontSize,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}