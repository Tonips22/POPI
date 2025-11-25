import 'package:flutter/material.dart';
import '../widgets/color_setting_card.dart';
import '../utils/color_constants.dart';
import '../widgets/preference_provider.dart';

/// Pantalla de configuración de colores
///
/// Permite al usuario personalizar:
/// - Color primario: usado en botones, elementos importantes
/// - Color secundario: usado en elementos de apoyo
/// - Color de fondo: color de fondo de las pantallas de los juegos
///
/// Los colores seleccionados se guardarán en el perfil del estudiante
class ColorSettingsScreen extends StatefulWidget {
  const ColorSettingsScreen({super.key});

  @override
  State<ColorSettingsScreen> createState() => _ColorSettingsScreenState();
}

class _ColorSettingsScreenState extends State<ColorSettingsScreen> {
  // === COLORES SELECCIONADOS (estado de la pantalla) ===
  // Estos valores deberían cargarse y guardarse en Firebase más adelante
  Color? primaryColor = Colors.blue;
  Color? secondaryColor = Colors.green;
  Color? backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenceProvider.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // === BARRA SUPERIOR ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Color',
          style: TextStyle(
            fontSize: (prefs?.getFontSizeValue() ?? 18.0) * 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: prefs?.getFontFamilyName() ?? 'Roboto',
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      // === CONTENIDO DE LA PANTALLA ===
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // === OPCIÓN 1: COLOR PRIMARIO ===
          ColorSettingCard(
            icon: Icons.palette,
            iconBackgroundColor: Colors.blue,
            title: 'Color primario',
            selectedColor: primaryColor,
            availableColors: AppColors.availableColors,
            dialogTitle: 'Elige un color primario',
            onColorSelected: (color) {
              setState(() {
                primaryColor = color;
              });
              // TODO: Guardar en Firebase o en el modelo del estudiante
              print('Color primario seleccionado: ${color.value}');
            },
          ),

          // === OPCIÓN 2: COLOR SECUNDARIO ===
          ColorSettingCard(
            icon: Icons.water_drop,
            iconBackgroundColor: Colors.green,
            title: 'Color secundario',
            selectedColor: secondaryColor,
            availableColors: AppColors.availableColors,
            dialogTitle: 'Elige un color secundario',
            onColorSelected: (color) {
              setState(() {
                secondaryColor = color;
              });
              // TODO: Guardar en Firebase o en el modelo del estudiante
              print('Color secundario seleccionado: ${color.value}');
            },
          ),

          // === OPCIÓN 3: COLOR DE FONDO ===
          ColorSettingCard(
            icon: Icons.format_color_fill,
            iconBackgroundColor: Colors.grey.shade600,
            title: 'Color de fondo',
            selectedColor: backgroundColor,
            availableColors: AppColors.backgroundColors,
            dialogTitle: 'Elige un color de fondo',
            onColorSelected: (color) {
              setState(() {
                backgroundColor = color;
              });
              // TODO: Guardar en Firebase o en el modelo del estudiante
              print('Color de fondo seleccionado: ${color.value}');
            },
          ),
        ],
      ),
    );
  }
}