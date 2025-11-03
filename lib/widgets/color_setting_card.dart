import 'package:flutter/material.dart';
import 'color_picker_dialog.dart';
import '../utils/color_constants.dart';

/// Tarjeta que muestra una opción de configuración de color
///
/// Incluye:
/// - Un icono a la izquierda
/// - Un texto descriptivo
/// - Un círculo de color a la derecha que muestra el color seleccionado
/// - Al tocar, abre un diálogo para elegir un nuevo color
class ColorSettingCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final Color? selectedColor;
  final List<ColorOption> availableColors;
  final String dialogTitle;
  final Function(Color) onColorSelected;

  const ColorSettingCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.selectedColor,
    required this.availableColors,
    required this.dialogTitle,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _showColorPicker(context),
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
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // === CÍRCULO DE COLOR A LA DERECHA ===
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedColor ?? Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo para seleccionar un color
  Future<void> _showColorPicker(BuildContext context) async {
    final Color? newColor = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: selectedColor,
        colors: availableColors,
        title: dialogTitle,
      ),
    );

    // Si el usuario seleccionó un color (no canceló), lo aplicamos
    if (newColor != null) {
      onColorSelected(newColor);
    }
  }
}